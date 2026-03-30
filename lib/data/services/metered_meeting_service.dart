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
  Function(MediaStream)? _onLocalStream;
  Function(Exception)? _onError;
  
  String? _sessionId;

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
    final configuration = <String, dynamic>{
      'sdpSemantics': 'unified-plan',
    };

    _peerConnection = await createPeerConnection(configuration);
    
    _peerConnection!.onTrack = (RTCTrackEvent event) {
      final trackId = event.track.id;
      final nick = _trackIdToNickname[trackId] ?? 'Remote User';
      
      final participant = Participant(
        externalUserId: trackId ?? 'unknown_${DateTime.now().millisecondsSinceEpoch}',
        name: nick,
        renderer: RTCVideoRenderer(),
        stream: event.streams[0],
      );
      
      participant.renderer.initialize().then((_) {
        participant.renderer.srcObject = event.streams[0];
        onJoined(participant);
      });
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
            
            if (!_subscribedTracks.contains(trackId) && trackInfo['sessionId'] != _sessionId) {
              await _subscribeToTrack(trackId, participantName, onJoined);
            }
          }
        }
      } catch (e) {
        print('SFU Polling error: $e');
      }
    });
  }

  Future<void> _subscribeToTrack(String trackId, String nickname, Function(Participant) onJoined) async {
    _subscribedTracks.add(trackId);
    
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
  }
}
