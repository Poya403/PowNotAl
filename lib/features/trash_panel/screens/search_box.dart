import 'package:flutter/material.dart';
import 'package:pow_note_ai/utils/app_radius.dart';
import 'package:pow_note_ai/utils/app_texts.dart';
import 'package:pow_note_ai/widgets/text_fields/custom_text_field.dart';
import 'package:pow_note_ai/features/note/providers/note_provider.dart';
import 'package:provider/provider.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final titleController = TextEditingController();
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextField(
          controller: titleController,
          labelText: AppTexts.search,
          borderRadius: AppRadius.radius20,
          filled: false,
          prefixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: titleController,
            builder: (context, value, child) {
              return IconButton(
                onPressed: value.text.isNotEmpty
                    ? () async => context.read<NoteProvider>().searchTrashNotes(
                        title: titleController.text.trim(),
                      )
                    : null,
                icon: Icon(Icons.search_rounded),
              );
            },
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: titleController,
            builder: (context, value, child) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                onPressed: () async {
                  titleController.clear();
                  context.read<NoteProvider>().loadTrashList();
                },
                icon: const Icon(Icons.cancel_outlined),
              );
            },
          ),
        ),
      ],
    );
  }
}
