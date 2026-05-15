import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/room_provider.dart';
import '../widgets/video_view_card.dart';
import '../widgets/chat_overlay.dart';
import '../widgets/room_controls.dart';
import '../../core/theme/app_theme.dart';

class RoomScreen extends ConsumerStatefulWidget {
  const RoomScreen({super.key});

  @override
  ConsumerState<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomScreen> {
  bool _showChat = false;

  @override
  Widget build(BuildContext context) {
    final roomState = ref.watch(roomProvider);
    
    // Custom error handling listener
    ref.listen<RoomState>(roomProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error && next.inRoom) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(roomProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          _buildParticipantsGrid(roomState),
          
          // Bottom Controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: RoomControls(
              isMicOn: roomState.isMicOn,
              isCameraOn: roomState.isCameraOn,
              isScreenSharing: roomState.isScreenSharing,
              onToggleMic: ref.read(roomProvider.notifier).toggleMic,
              onToggleCamera: ref.read(roomProvider.notifier).toggleCamera,
              onToggleScreenShare: ref.read(roomProvider.notifier).toggleScreenShare,
              onLeave: () {
                ref.read(roomProvider.notifier).leaveRoom();
                Navigator.of(context).pop();
              },
            ),
          ),

          // Message Button
          Positioned(
            top: 40,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white10,
              onPressed: () => setState(() => _showChat = !_showChat),
              child: Icon(_showChat ? LucideIcons.x : LucideIcons.messageSquare, color: Colors.white),
            ),
          ),
          
          if (_showChat)
            Positioned(
              top: 100,
              right: 20,
              bottom: 120, // Avoid overlapping with controls
              width: 350,
              child: ChatOverlay(
                messages: roomState.messages,
                onSendMessage: (text) => ref.read(roomProvider.notifier).sendMessage(text),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParticipantsGrid(RoomState roomState) {
    if (roomState.isJoining) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.accent));
    }

    if (roomState.participants.isEmpty) {
      return const Center(
        child: Text(
          'Awaiting participants...',
          style: TextStyle(color: Colors.white38, fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 16 / 9,
      ),
      itemCount: roomState.participants.length,
      itemBuilder: (context, index) {
        return VideoViewCard(participant: roomState.participants[index]);
      },
    );
  }
}
