import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/participant.dart';
import '../../domain/models/chat_message.dart';
import '../../data/services/metered_meeting_service.dart';
import '../../domain/repositories/meeting_repository.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../data/services/supabase_chat_service.dart';
import 'package:uuid/uuid.dart';

final meetingServiceProvider = Provider<MeetingRepository>((ref) {
  return MeteredMeetingService();
});

final chatServiceProvider = Provider<SupabaseChatService>((ref) {
  return SupabaseChatService();
});

class RoomState {
// ... existing state ...
  final bool isJoining;
  final Exception? error;
  final List<Participant> participants;
  final List<ChatMessage> messages;
  final bool inRoom;
  final bool isMicOn;
  final bool isCameraOn;
  final bool isScreenSharing;

  RoomState({
    this.isJoining = false,
    this.error,
    this.participants = const [],
    this.messages = const [],
    this.inRoom = false,
    this.isMicOn = true,
    this.isCameraOn = true,
    this.isScreenSharing = false,
  });

  RoomState copyWith({
    bool? isJoining,
    Exception? error,
    List<Participant>? participants,
    List<ChatMessage>? messages,
    bool? inRoom,
    bool? isMicOn,
    bool? isCameraOn,
    bool? isScreenSharing,
    bool clearError = false,
  }) {
    return RoomState(
      isJoining: isJoining ?? this.isJoining,
      error: clearError ? null : (error ?? this.error),
      participants: participants ?? this.participants,
      messages: messages ?? this.messages,
      inRoom: inRoom ?? this.inRoom,
      isMicOn: isMicOn ?? this.isMicOn,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      isScreenSharing: isScreenSharing ?? this.isScreenSharing,
    );
  }
}

class RoomNotifier extends Notifier<RoomState> {
  late MeetingRepository _meetingService;
  late SupabaseChatService _chatService;
  late String _currentRoomId;
  late String _userId;
  late String _currentNickname;

  @override
  RoomState build() {
    _meetingService = ref.watch(meetingServiceProvider);
    _chatService = ref.watch(chatServiceProvider);
    _userId = const Uuid().v4();
    return RoomState();
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<void> joinRoom(String nickname, String roomId) async {
    _currentNickname = nickname;
    _currentRoomId = roomId;
    state = state.copyWith(isJoining: true, clearError: true);

    // Subscribe to Supabase Chat
    _chatService.subscribeToMessages(roomId).listen((messages) {
      state = state.copyWith(messages: messages);
    });

    try {
      await _meetingService.join(
        nickname,
        roomId,
        onParticipantJoined: (p) {
          final participants = [...state.participants];
          final index = participants.indexWhere((existing) => existing.externalUserId == p.externalUserId);
          if (index != -1) {
            participants[index] = p;
          } else {
            participants.add(p);
          }
          state = state.copyWith(participants: participants);
        },
        onParticipantLeft: (id) {
          state = state.copyWith(
            participants: state.participants.where((p) => p.externalUserId != id).toList(),
          );
        },
        onLocalStream: (stream) async {
          final renderer = RTCVideoRenderer();
          await renderer.initialize();
          renderer.srcObject = stream;
          
          final localParticipant = Participant(
            externalUserId: 'local',
            name: nickname,
            isLocal: true,
            renderer: renderer,
            stream: stream,
          );
          
          state = state.copyWith(
            participants: [localParticipant, ...state.participants],
            isJoining: false,
            inRoom: true,
          );
        },
        onError: (e) {
          state = state.copyWith(error: e, isJoining: false);
        },
      );
    } catch (e) {
      state = state.copyWith(
        isJoining: false, 
        error: e is Exception ? e : Exception(e.toString())
      );
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;
    
    try {
      await _chatService.sendMessage(
        roomId: _currentRoomId,
        nickname: _currentNickname,
        text: text,
        userId: _userId,
      );
    } catch (e) {
      state = state.copyWith(error: Exception('Failed to send message: $e'));
    }
  }

  Future<void> toggleMic() async {
    final newState = !state.isMicOn;
    final localParticipant = state.participants.firstWhere((p) => p.isLocal);
    localParticipant.stream!.getAudioTracks().forEach((track) {
      track.enabled = newState;
    });
    state = state.copyWith(isMicOn: newState);
  }

  Future<void> toggleCamera() async {
    final newState = !state.isCameraOn;
    final localParticipant = state.participants.firstWhere((p) => p.isLocal);
    localParticipant.stream!.getVideoTracks().forEach((track) {
      track.enabled = newState;
    });
    state = state.copyWith(isCameraOn: newState);
  }

  Future<void> toggleScreenShare() async {
    if (state.isScreenSharing) {
      await _meetingService.stopScreenShare();
      state = state.copyWith(
        isScreenSharing: false,
        participants: state.participants.where((p) => p.externalUserId != 'screen').toList(),
      );
    } else {
      await _meetingService.startScreenShare((stream) async {
        final renderer = RTCVideoRenderer();
        await renderer.initialize();
        renderer.srcObject = stream;
        
        final screenParticipant = Participant(
          externalUserId: 'screen',
          name: 'Your Screen',
          isLocal: true,
          renderer: renderer,
          stream: stream,
        );
        
        state = state.copyWith(
          isScreenSharing: true,
          participants: [...state.participants, screenParticipant],
        );
      });
    }
  }

  Future<void> leaveRoom() async {
    await _meetingService.leave();
    for (var p in state.participants) {
      await p.renderer.dispose();
    }
    state = RoomState(); // Reset
  }
}

final roomProvider = NotifierProvider<RoomNotifier, RoomState>(RoomNotifier.new);
