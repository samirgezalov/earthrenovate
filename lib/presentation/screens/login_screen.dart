import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/room_provider.dart';
import '../../core/theme/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _nicknameController = TextEditingController();
  final _roomController = TextEditingController(
    text: const String.fromEnvironment('METERED_ROOM_ID', defaultValue: ''),
  );

  void _joinRoom() {
    final nickname = _nicknameController.text.trim();
    final roomId = _roomController.text.trim();
    if (nickname.isNotEmpty && roomId.isNotEmpty) {
      ref.read(roomProvider.notifier).joinRoom(nickname, roomId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomState = ref.watch(roomProvider);

    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.globe2, size: 64, color: AppTheme.accent),
              const SizedBox(height: 16),
              const Text(
                'Earth Renovation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your nickname to join the network.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  hintText: 'Nickname',
                  prefixIcon: Icon(LucideIcons.user),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _roomController,
                decoration: const InputDecoration(
                  hintText: 'Room ID',
                  prefixIcon: Icon(LucideIcons.hash),
                ),
                onSubmitted: (_) => _joinRoom(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: roomState.isJoining ? null : _joinRoom,
                  child: roomState.isJoining
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('JOIN SESSION'),
                ),
              ),
              if (roomState.error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                  ),
                  child: Text(
                    roomState.error.toString(),
                    style: const TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
