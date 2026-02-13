import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pow_note_ai/utils/app_texts.dart';

Future<String> improveRequest({
  required String form,
  required String title,
  required String content
}) async {
  final apiKey = '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';
  final url = Uri.parse('https://openrouter.ai/api/v1/completions');

  final prompt = AppTexts.prompt(form, title, content);

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      "model": "gpt-3.5-turbo",
      "prompt": prompt,
      "temperature": 0.7,
      "max_tokens": 500,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return data['choices'][0]['text'];
  } else {
    throw Exception('Error ${response.statusCode}: ${response.body}');
  }
}
