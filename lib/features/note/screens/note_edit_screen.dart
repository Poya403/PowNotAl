import 'package:flutter/material.dart';
import 'package:pow_note_ai/utils/app_radius.dart';
import 'package:pow_note_ai/widgets/text_fields/custom_text_field.dart';
import 'package:pow_note_ai/utils/app_texts.dart';
import 'package:pow_note_ai/utils/app_spacing.dart';
import '../models/note_model.dart';
import '../screens/note_enhancer_screen.dart';
import 'package:pow_note_ai/features/note/providers/note_provider.dart';
import 'package:provider/provider.dart';

class NoteEditScreen extends StatefulWidget {
  const NoteEditScreen({super.key});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  Note? editingNote;

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

    final newEditingNote = args['note'] as Note?;

    if (editingNote?.id != newEditingNote?.id) {
      editingNote = newEditingNote;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (editingNote != null) {
          if (titleController.text.isEmpty) {
            titleController.text = editingNote!.title;
          }
          if (contentController.text.isEmpty) {
            contentController.text = editingNote!.content;
          }
        } else {
          if (titleController.text.isEmpty) titleController.clear();
          if (contentController.text.isEmpty) contentController.clear();
        }
      });
    }
  }


  void _initializeFields() {
    if (editingNote != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        titleController.text = editingNote!.title;
        contentController.text = editingNote!.content;
        contentController.selection = TextSelection.fromPosition(
          TextPosition(offset: contentController.text.length),
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        titleController.clear();
        contentController.clear();
      });
    }
  }


  String get _pageTitle {
    if (editingNote != null) {
      return AppTexts.editNote;
    } else {
      return AppTexts.addNote;
    }
  }

  bool get isModified {
    if (editingNote == null) return false;
    return titleController.text.trim() != editingNote!.title ||
        contentController.text.trim() != editingNote!.content;
  }
  
  bool get canSave {
    final isNotEmpty = titleController.text.trim().isNotEmpty &&
        contentController.text.trim().isNotEmpty;

    if (editingNote == null) return isNotEmpty;

    return isModified && isNotEmpty;
  }

  
  void _saveNote() async {
    final noteProvider = context.read<NoteProvider>();
    await noteProvider.saveNote(Note(
      id: editingNote?.id,
      title: titleController.text.trim(),
      content: contentController.text.trim(),
      createdDate: DateTime.now().toIso8601String(),
    ));

    if (context.mounted) {
      Navigator.pop(context, editingNote?.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_pageTitle), centerTitle: true),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppSpacing.height20,
              CustomTextField(
                controller: titleController,
                labelText: AppTexts.title,
                suffixIcon: IconButton(
                  onPressed: () => titleController.clear(),
                  icon: Icon(Icons.cancel_outlined),
                ),
              ),
              AppSpacing.height20,
              SingleChildScrollView(
                child: CustomTextField(
                  controller: contentController,
                  labelText: AppTexts.enterText,
                  maxLines: null,
                  minLines: 8,
                  keyboardType: TextInputType.multiline,
                  suffixIcon: IconButton(
                    onPressed: () => contentController.clear(),
                    icon: Icon(Icons.cancel_outlined),
                  ),
                ),
              ),
              AppSpacing.height20,
              NoteEnhancerScreen(
                titleController: titleController,
                contentController: contentController,
              ),
              AppSpacing.height30,
              _buildEditButtons()
            ],
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
        onPressed: _saveNote,
        enabled: canSave,
      ),
      const SizedBox(width: 10, height: 10),
      CustomButton(
        title: AppTexts.clearChanges,
        onPressed: _initializeFields,
        enabled: isModified,
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
  final VoidCallback? onPressed;
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
