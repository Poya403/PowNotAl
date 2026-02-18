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
  final ValueNotifier<int> _updateNotifier = ValueNotifier(0);
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  Note? editingNote;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    titleController.addListener(_onTextChanged);
    contentController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _updateNotifier.value++;
  }

  @override
  void dispose() {
    titleController.removeListener(_onTextChanged);
    contentController.removeListener(_onTextChanged);
    _updateNotifier.dispose();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      editingNote = args?['note'];

      if (editingNote != null) {
        titleController.text = editingNote!.title;
        contentController.text = editingNote!.content;
      }

      _initialized = true;
    }
  }

  void _resetChanges() {
    if (editingNote != null) {
      titleController.text = editingNote!.title;
      contentController.text = editingNote!.content;
    } else {
      titleController.clear();
      contentController.clear();
    }
  }

  String get _pageTitle => editingNote != null ? AppTexts.editNote : AppTexts.addNote;

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
      appBar: AppBar(
          title: Text(
              _pageTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          centerTitle: true
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _actionButtons(),
              AppSpacing.height20,
              // title box
              CustomTextField(
                controller: titleController,
                labelText: AppTexts.title,
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: titleController,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      onPressed: () => titleController.clear(),
                      icon: const Icon(Icons.clear),
                    );
                  },
                ),
              ),
              AppSpacing.height20,
              // Artificial Intelligence Development Department
              NoteEnhancerScreen(
                titleController: titleController,
                contentController: contentController,
              ),
              AppSpacing.height20,
              //content box
              CustomTextField(
                controller: contentController,
                labelText: AppTexts.enterText,
                maxLines: null,
                minLines: 8,
                keyboardType: TextInputType.multiline,
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: contentController,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      onPressed: () => contentController.clear(),
                      icon: const Icon(Icons.clear),
                    );
                  },
                ),
              ),
              AppSpacing.height16,
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButtons() {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    return ValueListenableBuilder<int>(
      valueListenable: _updateNotifier,
      builder: (context, _, __) {
        final buttons = [
          CustomButton(
            title: AppTexts.save,
            iconData: Icons.save_as_outlined,
            onPressed: canSave ? _saveNote : null,
            enabled: canSave
          ),
          const SizedBox(width: 5, height: 5),
          if(editingNote != null)
            CustomButton(
              title: AppTexts.clearChanges,
              iconData: Icons.clear,
              onPressed: isModified ? _resetChanges : null,
              enabled: isModified,
              color: Colors.redAccent
            ),
        ];

        return SizedBox(
          width: isDesktop
              ? MediaQuery.of(context).size.width * 0.28
              : MediaQuery.of(context).size.width * 0.9
          ,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.radius10,
            ),
            margin: EdgeInsets.all(10.0),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: buttons,
              ),
            ),
          ),
        );
      },
    );
  }

}

class CustomButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  final bool enabled;
  final VoidCallback? onPressed;
  final Color color;

  const CustomButton({
    super.key,
    required this.title,
    required this.iconData,
    required this.onPressed,
    this.color = Colors.deepPurpleAccent,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: title,
      child: IconButton(
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.all(5.0),
          foregroundColor: color,
          disabledForegroundColor: Theme.of(context).colorScheme
              .onSurface.withValues(alpha: 0.38),
        ),
        onPressed: enabled ? onPressed : null,
        icon: Icon(
          iconData,
          size: 25,
        ),
      ),
    );
  }
}
