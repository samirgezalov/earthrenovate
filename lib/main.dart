import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/room_provider.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/room_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL',),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', ),
  );

  // Ensure we have a session for Realtime/RLS
  if (Supabase.instance.client.auth.currentUser == null) {
    await Supabase.instance.client.auth.signInAnonymously();
  }

  runApp(
    const ProviderScope(
      child: SOSEarthApp(),
    ),
  );
}

class SOSEarthApp extends ConsumerWidget {
  const SOSEarthApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inRoom = ref.watch(roomProvider.select((state) => state.inRoom));

    return MaterialApp(
      title: 'Web Conference',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: inRoom ? const RoomScreen() : const LoginScreen(),
    );
  }
}
