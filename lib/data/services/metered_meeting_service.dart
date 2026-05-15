import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_webrtc/flutter_webrtc.dart';


import '../../core/utils/web_lifecycle_manager.dart';
import '../../domain/models/participant.dart';
import '../../domain/repositories/meeting_repository.dart';

class MeteredMeetingService implements MeetingRepository {
  static const String _meteredKey = String.fromEnvironment('METERED_KEY', defaultValue: '');
  static const String _meteredSecret = String.fromEnvironment('METERED_SECRET', defaultValue: '');
  static const String _meteredAppDomain = String.fromEnvironment('METERED_DOMAIN', defaultValue: 'sos-earth.metered.live');
  static const String _sfuHost = 'https://global.sfu.metered.ca';

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _screenStream;
  Function(MediaStream)? _onLocalStream;
  Function(Exception)? _onError;
  
  String? _sessionId;
  final Map<String, String> _trackIdToSessionId = {};
  final Map<String, String> _sessionIdToNickname = {};
  final Map<String, Participant> _sessionIdToParticipant = {};

  @override
  Future<void> join(
    String nickname,
    String roomId, {
    required Function(Participant) onParticipantJoined,
    required Function(String) onParticipantLeft,
    required Function(MediaStream) onLocalStream,
    required Function(Exception) onError,
  }) async {
    _onError = onError;
    _onLocalStream = onLocalStream;

    try {
      if (_meteredSecret.isNotEmpty) {
        await _joinSFU(nickname, roomId, onParticipantJoined);
      } else {
        await _joinMesh(nickname, roomId, onParticipantJoined);
      }
      
      WebLifecycleManager.registerOnBeforeUnload(() {
        dispose();
      });
    } catch (e) {
      _onError?.call(e is Exception ? e : Exception(e.toString()));
    }
  }

  final Map<String, String> _trackIdToNickname = {};

  Future<void> _joinSFU(String nickname, String roomId, Function(Participant) onJoined) async {
    final iceServers = await _fetchMeteredIceServers();
    final configuration = <String, dynamic>{
      'iceServers': iceServers,
      'sdpSemantics': 'unified-plan',
    };

    _peerConnection = await createPeerConnection(configuration);
    
    _peerConnection!.onTrack = (RTCTrackEvent event) {
      final trackId = event.track.id;
      final sessionId = _trackIdToSessionId[trackId];
      
      if (sessionId == null) return;

      final nick = _sessionIdToNickname[sessionId] ?? 'Remote User';
      
      // Screen shares should be separate participants
      final bool isScreen = nick.contains("Screen Share");
      final String participantId = isScreen ? trackId ?? '' : sessionId;
      
      Participant? participant = _sessionIdToParticipant[participantId];
      
      if (participant == null) {
        final stream = event.streams.isNotEmpty ? event.streams[0] : null;
        
        final newParticipant = Participant(
          externalUserId: participantId,
          name: nick,
          renderer: RTCVideoRenderer(),
          stream: stream,
        );
        
        _sessionIdToParticipant[participantId] = newParticipant;
        
        newParticipant.renderer.initialize().then((_) {
          newParticipant.renderer.srcObject = stream;
          onJoined(newParticipant);
        });
      } else {
        if (participant.stream != null && !participant.stream!.getTracks().any((t) => t.id == trackId)) {
          participant.stream!.addTrack(event.track);
        }
        onJoined(participant);
      }
    };

    // Setup local media
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {'facingMode': 'user'},
    });
    _onLocalStream?.call(_localStream!);

    // Add tracks BEFORE creating the first offer
    for (var track in _localStream!.getTracks()) {
      await _peerConnection!.addTrack(track, _localStream!);
    }

    // 1. Create SFU Session (with tracks)
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    final sessionResponse = await http.post(
      Uri.parse('$_sfuHost/api/sfu/$_meteredKey/session/new'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_meteredSecret',
      },
      body: jsonEncode({
        'sessionDescription': {
          'type': 'offer',
          'sdp': offer.sdp,
        },
      }),
    );

    if (sessionResponse.statusCode != 200) {
      final errorMsg = 'SFU Session failed: ${sessionResponse.statusCode} - ${sessionResponse.body}';
      print(errorMsg);
      throw Exception(errorMsg);
    }
    
    final sessionData = jsonDecode(sessionResponse.body);
    final sdpData = sessionData['sessionDescription'];
    _sessionId = sessionData['sessionId'];
    
    final answer = RTCSessionDescription(sdpData['sdp'], 'answer');
    await _peerConnection!.setRemoteDescription(answer);

    // 2. Publish tracks with names
    for (var track in _localStream!.getTracks()) {
      await _publishTrack(track, nickname);
    }

    // 3. Start track polling
    _startRemoteTrackPolling(roomId, onJoined);
  }

  Future<void> _publishTrack(MediaStreamTrack track, String nickname) async {
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    await http.post(
      Uri.parse('$_sfuHost/api/sfu/$_meteredKey/session/$_sessionId/track/publish'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_meteredSecret',
      },
      body: jsonEncode({
        'sessionDescription': {
          'type': 'offer',
          'sdp': offer.sdp,
        },
        'tracks': [
          {
            'trackId': track.id,
            'mid': track.kind == 'audio' ? '0' : '1',
            'customTrackName': nickname,
          }
        ],
      }),
    );
  }

  final Set<String> _subscribedTracks = {};
  Timer? _pollingTimer;

  void _startRemoteTrackPolling(String roomId, Function(Participant) onJoined) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (_sessionId == null) return;
      
      try {
        final response = await http.get(
          Uri.parse('$_sfuHost/api/sfu/$_meteredKey/session/$_sessionId/tracks'),
          headers: {'Authorization': 'Bearer $_meteredSecret'},
        );
        
        if (response.statusCode == 200) {
          final List<dynamic> tracks = jsonDecode(response.body);
          for (var trackInfo in tracks) {
            final trackId = trackInfo['trackId'];
            final participantName = trackInfo['customTrackName'] ?? 'Remote User';
            final remoteSessionId = trackInfo['sessionId'];
            final kind = trackInfo['type'] ?? 'video'; // Metered uses 'type' for audio/video
            
            if (!_subscribedTracks.contains(trackId) && remoteSessionId != _sessionId) {
              _trackIdToSessionId[trackId] = remoteSessionId;
              _sessionIdToNickname[remoteSessionId] = participantName;
              await _subscribeToTrack(trackId, participantName, kind, onJoined);
            }
          }
        }
      } catch (e) {
        print('SFU Polling error: $e');
      }
    });
  }

  Future<void> _subscribeToTrack(String trackId, String nickname, String kind, Function(Participant) onJoined) async {
    _subscribedTracks.add(trackId);
    
    // Ensure transceiver exists for the kind
    await _peerConnection!.addTransceiver(
      kind: kind == 'audio' ? RTCRtpMediaType.RTCRtpMediaTypeAudio : RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly),
    );
    
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    final response = await http.post(
      Uri.parse('$_sfuHost/api/sfu/$_meteredKey/session/$_sessionId/track/subscribe'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_meteredSecret',
      },
      body: jsonEncode({
        'sessionDescription': {
          'type': 'offer',
          'sdp': offer.sdp,
        },
        'trackId': trackId,
      }),
    );

    if (response.statusCode == 200) {
      _trackIdToNickname[trackId] = nickname;
      final data = jsonDecode(response.body);
      final sdpData = data['sessionDescription'];
      final answer = RTCSessionDescription(sdpData['sdp'], 'answer');
      await _peerConnection!.setRemoteDescription(answer);
    }
  }

  Future<void> _joinMesh(String nickname, String roomId, Function(Participant) onJoined) async {
      // existing TURN logic
      final iceServers = await _fetchMeteredIceServers();
      final configuration = <String, dynamic>{
        'iceServers': iceServers,
        'iceTransportPolicy': 'relay',
        'sdpSemantics': 'unified-plan',
      };
      _peerConnection = await createPeerConnection(configuration);
      _localStream = await navigator.mediaDevices.getUserMedia({'audio': true, 'video': true});
      _onLocalStream?.call(_localStream!);
      _localStream!.getTracks().forEach((track) => _peerConnection!.addTrack(track, _localStream!));
  }

  Future<List<Map<String, dynamic>>> _fetchMeteredIceServers() async {
    try {
      final url = Uri.parse('https://$_meteredAppDomain/api/v1/turn/credentials?apiKey=$_meteredKey');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
      }
      return [{'urls': 'stun:stun.l.google.com:19302'}];
    } catch (_) {
      return [{'urls': 'stun:stun.l.google.com:19302'}];
    }
  }

  @override
  Future<void> startScreenShare(Function(MediaStream) onStream) async {
    try {
      _screenStream = await navigator.mediaDevices.getDisplayMedia({
        'video': true,
        'audio': true,
      });
      
      for (var track in _screenStream!.getTracks()) {
        await _peerConnection!.addTrack(track, _screenStream!);
        await _publishTrack(track, "Screen Share");
      }
      onStream(_screenStream!);
    } catch (e) {
      print("Screen share error: $e");
    }
  }

  @override
  Future<void> stopScreenShare() async {
    _screenStream?.getTracks().forEach((track) => track.stop());
    _screenStream = null;
  }

  @override
  Future<void> leave() async => dispose();

  @override
  Future<void> dispose() async {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _subscribedTracks.clear();
    
    _localStream?.getTracks().forEach((t) => t.stop());
    await _localStream?.dispose();
    await _peerConnection?.close();
    _peerConnection = null;
    _localStream = null;
    _trackIdToSessionId.clear();
    _sessionIdToNickname.clear();
    _sessionIdToParticipant.clear();
  }
}
