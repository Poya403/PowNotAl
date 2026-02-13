import 'package:share_plus/share_plus.dart';
import 'package:pow_note_ai/features/note/models/note_model.dart';
import 'package:pow_note_ai/utils/app_texts.dart';

class ShareService {
  static Future<void> shareNote(Note note) async {
    final formattedText = '''
      ${AppTexts.title} : ${note.title}
      
      ${note.content}
    ''';

    await Share.share(formattedText);
  }
}
