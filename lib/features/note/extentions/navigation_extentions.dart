import 'package:flutter/material.dart';
import 'package:pow_note_ai/features/note/extentions/note_extentions.dart';
import '../../note/models/note_model.dart';

extension NoteNavigation on BuildContext {
  Future<dynamic> openNoteEditor({Note? note, bool isReadOnly = false}) {
    return Navigator.pushNamed(
      this,
      '/note_edit',
      arguments: {
        'note': note,
        'isReadOnly': isReadOnly
      },
    );
  }
}