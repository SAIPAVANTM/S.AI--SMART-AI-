// lib/services/chat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const List<String> _apiKeys = [
    "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",
    "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",
    "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",
    "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",
    "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",
    "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",
    "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",
    "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",
    "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",
    "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"
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
