import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';

extension NoteSaveExtension on Note {
  VoidCallback saveNote(BuildContext context) {
    return () async {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      await noteProvider.saveNote(this);
      if (context.mounted) Navigator.pop(context);
    };
  }

  VoidCallback delete(BuildContext context) {
    return () async {
      final provider = Provider.of<NoteProvider>(context, listen: false);
      await provider.deleteNote(id!);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('یادداشت با موفقیت حذف شد')),
        );
      }
    };
  }

  static VoidCallback load(BuildContext context) {
    return () async {
      final provider = Provider.of<NoteProvider>(context, listen: false);
      await provider.loadNotes();
    };
  }
}