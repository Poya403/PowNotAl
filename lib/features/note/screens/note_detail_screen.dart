import 'package:flutter/material.dart';
import 'package:pow_note_ai/features/note/models/note_model.dart';
import 'package:pow_note_ai/utils/app_radius.dart';
import 'package:pow_note_ai/utils/app_spacing.dart';
import 'package:pow_note_ai/utils/app_texts.dart';
import 'package:provider/provider.dart';
import 'package:pow_note_ai/features/note/providers/note_provider.dart';
import 'package:collection/collection.dart';
import 'package:pow_note_ai/services/share_services.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({super.key});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  ShareService shareService = ShareService();
  Note? note;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getArguments();
  }

  void _getArguments() {
    final args =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, dynamic>?;
    if (args == null) return;

    final int noteId = args['noteId'];

    final noteProvider = context.watch<NoteProvider>();
    note = noteProvider.notes.firstWhereOrNull((n) => n.id == noteId);
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery
        .of(context)
        .size
        .width > 800;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            note!.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        centerTitle: true,
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              onPressed: () =>
                  Navigator.pushNamed(
                    context,
                    '/note_edit',
                    arguments: {'note': note},
                  ),
              title: AppTexts.editNote,
              icon: Icons.edit_outlined,
            ),
            AppSpacing.width24,
            CustomButton(
              onPressed: () => ShareService.shareNote(note!),
              title: AppTexts.share,
              icon: Icons.share_outlined,
            ),
          ],
        ),
      ),

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 30.0 : 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.radius16,
                  ),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        note!.content,
                        style: isDesktop ? Theme.of(context).textTheme.bodyLarge : Theme.of(context).textTheme.bodyMedium,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final bool enabled;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  const CustomButton({
    super.key,
    this.icon,
    this.title,
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
        child: Tooltip(
          message: title ?? '',
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: AppRadius.radius30),
              elevation: 0,
              backgroundColor:
                  backgroundColor ?? Theme.of(context).colorScheme.primary,
            ),
            onPressed: enabled ? onPressed : null,
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimary,
            )
          ),
        ),
      ),
    );
  }
}
