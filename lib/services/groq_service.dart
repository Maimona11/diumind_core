import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqService {
  final String apiKey;
  final String model;
  static const String baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  GroqService({
    String? apiKey,
    String? model,
  })  : apiKey = apiKey ?? dotenv.env['GROQ_API_KEY'] ?? '',
        model = model ?? dotenv.env['GROQ_MODEL'] ?? 'mixtral-8x7b-32768';

  Future<String> generateResponse(
    String userMessage,
    String context,
  ) async {
    try {
      final systemPrompt = '''You are a helpful student assistant for Daffodil International University (DIU). 
You have access to information about a student's courses, schedules, quizzes, and campus events.

When answering:
- Be concise and helpful
- Always provide specific details like room numbers, times, and dates
- If you don't have the information, say so politely
- Format dates and times clearly

Student Knowledge Base:
$context

Answer the student's question based on the information above.''';

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userMessage},
          ],
          'temperature': 0.7,
          'max_tokens': 1024,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ?? 'No response generated.';
      } else {
        throw Exception('Groq API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to generate response: $e');
    }
  }

  Future<String> chat(String message, String context) async {
    return await generateResponse(message, context);
  }
}
