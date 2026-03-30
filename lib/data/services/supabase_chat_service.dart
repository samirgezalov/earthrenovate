import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/chat_message.dart';

class SupabaseChatService {
  final _supabase = Supabase.instance.client;

  Future<List<ChatMessage>> getMessages(String roomId) async {
    final response = await _supabase
        .from('chat_messages')
        .select()
        .eq('room_id', roomId)
        .order('created_at', ascending: true);

    return (response as List).map((data) => _mapToModel(data)).toList();
  }

  Future<void> sendMessage({
    required String roomId,
    required String nickname,
    required String text,
    required String userId,
  }) async {
    try {
      await _supabase.from('chat_messages').insert({
        'room_id': roomId,
        'username': nickname,
        'message': text,
        'user_id': userId,
      });
    } catch (e) {
      print('Supabase sending error: $e');
      rethrow;
    }
  }

  Stream<List<ChatMessage>> subscribeToMessages(String roomId) {
    return _supabase
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at', ascending: true)
        .map((event) {
          print('Supabase stream event: ${event.length} messages');
          return event.map((data) => _mapToModel(data)).toList();
        })
        .handleError((e) {
          print('Supabase stream error: $e');
        });
  }

  ChatMessage _mapToModel(Map<String, dynamic> data) {
    final currentUserId = _supabase.auth.currentUser?.id;
    return ChatMessage(
      senderName: data['username'] ?? 'Unknown',
      text: data['message'] ?? '',
      timestamp: DateTime.parse(data['created_at']),
      isLocal: data['user_id'] == currentUserId || data['username'] == 'LocalUser', // Fallback for testing
    );
  }
}
