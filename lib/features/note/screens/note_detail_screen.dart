import 'package:flutter/material.dart';
import 'package:pow_note_ai/features/note/models/note_model.dart';
import 'package:pow_note_ai/utils/app_radius.dart';
import 'package:pow_note_ai/utils/app_texts.dart';
import 'package:provider/provider.dart';
import 'package:pow_note_ai/features/note/providers/note_provider.dart';
import 'package:collection/collection.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({super.key});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  Note? note;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getArguments();
  }

  void _getArguments() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null) return;

    final int noteId = args['noteId'];

    final noteProvider = context.watch<NoteProvider>();
    note = noteProvider.notes.firstWhereOrNull((n) => n.id == noteId);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: AppTexts.editNote,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.radius30),
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () => Navigator.pushNamed(
            context,
            '/note_edit',
            arguments: {'note': note},
          ),
          child: const Icon(Icons.edit_outlined, color: Colors.white),
        ),
        appBar: AppBar(title: Text(note!.title), centerTitle: true),
        body: Align(
          alignment: Alignment.topCenter,
          child: FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 0.8,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.radius16),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: SelectableText(
                    note!.content,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final bool enabled;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 15.0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: AppRadius.radius6),
            elevation: 3,
            backgroundColor:
                backgroundColor ?? Theme.of(context).colorScheme.primary,
          ),
          onPressed: enabled ? onPressed : null,
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
