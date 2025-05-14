// lib/services/chat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const List<String> _apiKeys = [
    'a'
  ];

  static const String _baseUrl = "https://api.groq.com/openai/v1/chat/completions";

  Future<String> sendMessage(String message) async {
    for (final key in _apiKeys) {
      try {
        final response = await http.post(
          Uri.parse(_baseUrl),
          headers: {
            'Authorization': 'Bearer $key',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'model': 'llama-3.1-8b-instant',
            'messages': [
              {'role': 'system', 'content': 'You are a helpful AI assistant.'},
              {'role': 'user', 'content': message}
            ],
            'temperature': 1,
            'max_tokens': 1024,
            'top_p': 1,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data['choices'][0]['message']['content'];
        }
      } catch (e) {
        // Continue to next key
        continue;
      }
    }
    return "All API keys failed. Please try again later.";
  }
}
