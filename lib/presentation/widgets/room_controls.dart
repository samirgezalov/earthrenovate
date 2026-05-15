import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_theme.dart';

class RoomControls extends StatelessWidget {
  final bool isMicOn;
  final bool isCameraOn;
  final bool isScreenSharing;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleCamera;
  final VoidCallback onToggleScreenShare;
  final VoidCallback onLeave;

  const RoomControls({
    super.key,
    required this.isMicOn,
    required this.isCameraOn,
    required this.isScreenSharing,
    required this.onToggleMic,
    required this.onToggleCamera,
    required this.onToggleScreenShare,
    required this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withAlpha(204),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ControlButton(
              icon: isMicOn ? LucideIcons.mic : LucideIcons.micOff,
              color: isMicOn ? Colors.white24 : Colors.redAccent.withAlpha(128),
              onPressed: onToggleMic,
            ),
            const SizedBox(width: 20),
            _ControlButton(
              icon: isCameraOn ? LucideIcons.video : LucideIcons.videoOff,
              color: isCameraOn ? Colors.white24 : Colors.redAccent.withAlpha(128),
              onPressed: onToggleCamera,
            ),
            const SizedBox(width: 20),
            _ControlButton(
              icon: isScreenSharing ? LucideIcons.screenShareOff : LucideIcons.screenShare,
              color: isScreenSharing ? AppTheme.accent.withAlpha(128) : Colors.white24,
              onPressed: onToggleScreenShare,
            ),
            const SizedBox(width: 40),
            _ControlButton(
              icon: LucideIcons.phoneOff,
              color: Colors.red,
              onPressed: onLeave,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isDestructive;

  const _ControlButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white10,
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 28),
        onPressed: onPressed,
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
