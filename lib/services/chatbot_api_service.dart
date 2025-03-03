

import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ChatbotApiService {
  static const String _baseUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  final String _apiKey =
      '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'; // Replace with your actual API key

  Future<String> fetchJEEAnswer(String userQuery) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "llama3-8b-8192",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are an AI chatbot that only provides information related to the JEE exam, its syllabus, and related questions. If a question is unrelated to JEE, respond with 'I only answer JEE-related questions.'",
            },
            {"role": "user", "content": userQuery},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final answer = data['choices'][0]['message']['content'];
        return answer;
      } else {
        return 'API Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Failed to fetch response: $e';
    }
  }
}
