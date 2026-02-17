import 'package:flutter/material.dart';
import 'package:pow_note_ai/utils/app_radius.dart';
import 'package:pow_note_ai/utils/app_texts.dart';
import 'package:pow_note_ai/widgets/text_fields/custom_persian_date_picker.dart';
import 'package:pow_note_ai/widgets/text_fields/custom_text_field.dart';
import 'package:pow_note_ai/features/note/providers/note_provider.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_spacing.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox>
    with SingleTickerProviderStateMixin {
  final titleController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  String? gregorianStartDate;
  String? gregorianEndDate;
  ValueNotifier<bool> isExpanded = ValueNotifier(false);

  @override
  void dispose() {
    titleController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    isExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    final fieldWidth = isDesktop ? screenWidth * 0.15 : screenWidth * 0.7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: isDesktop ? screenWidth * 0.5 : fieldWidth,
              child: CustomTextField(
                controller: titleController,
                labelText: AppTexts.search,
                borderRadius: AppRadius.radius20,
                filled: false,
                prefixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: titleController,
                  builder: (context, value, child) {
                    return IconButton(
                      onPressed: () async {
                        final title = titleController.text.trim().isNotEmpty
                            ? titleController.text.trim()
                            : null;

                        await context.read<NoteProvider>().searchNotes(
                          title: title,
                          startDate: gregorianStartDate,
                          endDate: gregorianEndDate,
                        );
                      },
                      icon: const Icon(Icons.search_rounded),
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
                        context.read<NoteProvider>().loadNotes();
                      },
                      icon: const Icon(Icons.cancel_outlined),
                    );
                  },
                ),
              ),
            ),

            IconButton(
              onPressed: () => isExpanded.value = !isExpanded.value,
              icon: ValueListenableBuilder<bool>(
                valueListenable: isExpanded,
                builder: (_, expanded, __) => AnimatedRotation(
                  duration: const Duration(milliseconds: 250),
                  turns: expanded ? 0.5 : 0,
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
            ),
          ],
        ),

        AppSpacing.height24,

        ValueListenableBuilder<bool>(
          valueListenable: isExpanded,
          builder: (context, expanded, _) {
            return AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: expanded
                  ? isDesktop
                  ? Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  textDirection: TextDirection.rtl,
                  children: [
                    SizedBox(
                      width: fieldWidth,
                      child: _filterFields()[0],
                    ),
                    AppSpacing.width30,
                    SizedBox(
                      width: fieldWidth,
                      child: _filterFields()[1],
                    ),
                  ],
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: _filterFields()[0],
                  ),
                  AppSpacing.height10,
                  SizedBox(
                    width: fieldWidth,
                    child: _filterFields()[1],
                  ),
                ],
              )
                  : const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }

  List<Widget> _filterFields() {
    return [
      CustomPersianDateField(
        controller: startDateController,
        labelText: AppTexts.startDate,
        helpText: AppTexts.startDate,
        onDateSelected: (value){
          gregorianStartDate = value;
        },
      ),
      CustomPersianDateField(
        controller: endDateController,
        labelText: AppTexts.endDate,
        helpText: AppTexts.endDate,
        onDateSelected: (value){
          gregorianEndDate = value;
          print(gregorianEndDate.toString());
        },
      ),
    ];
  }
}



