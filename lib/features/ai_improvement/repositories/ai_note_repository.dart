import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pow_note_ai/utils/app_texts.dart';

Future<String> improveRequest({
  required String form,
  required String title,
  required String content,
}) async {
  final url = Uri.parse('https://notepowaibackend-at12yuxm5-poya-aminis-projects.vercel.app/api/index');
  final prompt = AppTexts.prompt(form, title, content);

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'prompt': prompt}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return data['choices'][0]['text'];
  } else {
    throw Exception('Error ${response.statusCode}: ${response.body}');
  }
}
