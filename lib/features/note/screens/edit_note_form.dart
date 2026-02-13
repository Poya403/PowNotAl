import 'package:flutter/material.dart';
import 'package:pow_note_ai/features/note/extentions/note_extentions.dart';
import 'package:pow_note_ai/utils/app_radius.dart';
import 'package:pow_note_ai/widgets/text_fields/custom_text_field.dart';
import 'package:pow_note_ai/utils/app_texts.dart';
import 'package:pow_note_ai/utils/app_spacing.dart';
import '../models/note_model.dart';
import '../screens/note_enhancer_screen.dart';
import 'package:provider/provider.dart';
import '../../../features/note/providers/note_provider.dart';

class EditNoteForm extends StatefulWidget {
  const EditNoteForm({super.key});

  @override
  State<EditNoteForm> createState() => _EditNoteFormState();
}

class _EditNoteFormState extends State<EditNoteForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  Note? editingNote;
  late bool isReadOnly;

  @override
  void initState() {
    super.initState();
    titleController.addListener(_updateUI);
    contentController.addListener(_updateUI);
  }

  @override
  void dispose() {
    titleController.removeListener(_updateUI);
    contentController.removeListener(_updateUI);
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _updateUI() => setState(() {});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _getArguments();
    _initializeFields();
  }

  void _getArguments() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null) return;

    editingNote = args['note'] as Note?;
    isReadOnly = args['isReadOnly'] ?? false;
  }

  void _initializeFields() {
    if (editingNote != null) {
      titleController.text = editingNote!.title;
      contentController.text = editingNote!.content;
    } else {
      titleController.clear();
      contentController.clear();
    }
  }
  void _toggleReadOnly() => setState(() => isReadOnly = !isReadOnly);

  String get _pageTitle {
    if (isReadOnly) {
      return '';
    } else if (editingNote != null) {
      return AppTexts.editNote;
    } else {
      return AppTexts.addNote;
    }
  }

  bool get hasChanged {
    if (editingNote == null) {
      return titleController.text.isNotEmpty ||
          contentController.text.isNotEmpty;
    } else {
      return titleController.text != editingNote!.title ||
          contentController.text != editingNote!.content;
    }
  }

  bool get isFieldsNotEmpty =>
      (titleController.text.isNotEmpty && contentController.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_pageTitle), centerTitle: true),
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            top: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NoteEnhancerScreen(
                  isExpanded: !isReadOnly,
                  titleController: titleController,
                  contentController: contentController,
                ),
                AppSpacing.height30,
                CustomTextField(
                  controller: titleController,
                  labelText: AppTexts.title,
                  prefixIcon: Icon(Icons.title_outlined),
                  readOnly: isReadOnly,
                ),
                AppSpacing.height20,
                SingleChildScrollView(
                  child: CustomTextField(
                    controller: contentController,
                    labelText: isReadOnly ? AppTexts.text : AppTexts.enterText,
                    maxLines: null,
                    minLines: isReadOnly ? 3 : 10,
                    keyboardType: TextInputType.multiline,
                    prefixIcon: Icon(Icons.description),
                    suffixIcon: IconButton(
                      onPressed: () => contentController.clear(),
                      icon: Icon(Icons.cancel_outlined),
                    ),
                    readOnly: isReadOnly,
                  ),
                ),
                if(editingNote != null)
                  CustomButton(
                    title: isReadOnly ? AppTexts.editNote : AppTexts.close,
                    onPressed: _toggleReadOnly,
                  ),
                if (!isReadOnly) ...[_buildEditButtons()],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditButtons() {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final buttons = [
      CustomButton(
        title: AppTexts.save,
        onPressed: Note(
          id: editingNote?.id,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          createdDate: DateTime.now().toIso8601String(),
        ).saveNote(context),
      ),
      const SizedBox(width: 10, height: 10),
      CustomButton(
        title: AppTexts.clearChanges,
        onPressed: _initializeFields,
        enabled: hasChanged,
        backgroundColor: Colors.redAccent,
      ),
    ];
    return isDesktop
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: buttons)
        : Column(children: buttons);
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
