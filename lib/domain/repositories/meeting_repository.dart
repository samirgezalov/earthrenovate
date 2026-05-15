import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../models/participant.dart';

abstract class MeetingRepository {
  Future<void> join(
    String nickname,
    String roomId, {
    required Function(Participant) onParticipantJoined,
    required Function(String) onParticipantLeft,
    required Function(MediaStream) onLocalStream,
    required Function(Exception) onError,
  });
  
  Future<void> leave();
  Future<void> startScreenShare(Function(MediaStream) onStream);
  Future<void> stopScreenShare();
  Future<void> dispose();
}
