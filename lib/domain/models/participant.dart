import 'package:flutter_webrtc/flutter_webrtc.dart';

class Participant {
  final String externalUserId;
  final String name;
  final bool isLocal;
  final RTCVideoRenderer renderer;
  final MediaStream? stream;

  Participant({
    required this.externalUserId,
    required this.name,
    this.isLocal = false,
    required this.renderer,
    this.stream,
  });

  Participant copyWith({
    String? name,
    MediaStream? stream,
  }) {
    return Participant(
      externalUserId: externalUserId,
      name: name ?? this.name,
      isLocal: isLocal,
      renderer: renderer,
      stream: stream ?? this.stream,
    );
  }
}
