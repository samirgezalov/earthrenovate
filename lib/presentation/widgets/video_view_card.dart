import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../domain/models/participant.dart';
import '../../core/theme/app_theme.dart';
import 'package:lucide_icons/lucide_icons.dart';

class VideoViewCard extends StatelessWidget {
  final Participant participant;

  const VideoViewCard({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.glassmorphismDecoration,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RTCVideoView(
            participant.renderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            mirror: participant.isLocal, // Mirror local view
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    participant.isLocal ? LucideIcons.userCheck : LucideIcons.user,
                    size: 16,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    participant.name + (participant.isLocal ? " (You)" : ""),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
