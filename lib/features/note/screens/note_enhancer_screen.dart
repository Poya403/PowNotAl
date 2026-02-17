import 'package:flutter/material.dart';
import 'package:pow_note_ai/utils/app_spacing.dart';
import 'package:pow_note_ai/utils/app_texts.dart';
import 'package:pow_note_ai/widgets/loading_widget.dart';
import 'package:pow_note_ai/widgets/text_fields/custom_drop_down_field.dart';
import '../enums/note_style.dart';
import 'package:pow_note_ai/core/ai_improvement/repositories/ai_note_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NoteEnhancerScreen extends StatefulWidget {
  const NoteEnhancerScreen({
    super.key,
    this.isExpanded = true,
    required this.titleController,
    required this.contentController
  });

  final bool isExpanded;
  final TextEditingController titleController;
  final TextEditingController contentController;

  @override
  State<NoteEnhancerScreen> createState() => _NoteEnhancerScreenState();
}

class _NoteEnhancerScreenState extends State<NoteEnhancerScreen> {
  bool hasInternet = true;
  late ValueNotifier<bool> isLoadingNotifier;
  late ValueNotifier<NoteStyle> selectedFormNotifier;

  @override
  void initState() {
    super.initState();
    isLoadingNotifier = ValueNotifier(false);
    selectedFormNotifier =
        ValueNotifier<NoteStyle>(NoteStyle.formal);
    checkInternet();
  }

  Future<void> checkInternet() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      hasInternet = result != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    return widget.isExpanded
        ? SingleChildScrollView(
      child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: isDesktop
                    ? MediaQuery.of(context).size.width * 0.5
                    : MediaQuery.of(context).size.width * 0.85,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(32.0, 10.0, 32, 10.0),
                    child: Column(
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          textDirection: TextDirection.rtl,
                          spacing: 15,
                          children: [
                            ValueListenableBuilder(
                                valueListenable: selectedFormNotifier,
                                builder: (context, selectedForm, _) {
                                  return CustomDropdownField(
                                    labelText: AppTexts.form,
                                    items: NoteStyle.values
                                        .map((e) => e.title)
                                        .toList(),
                                    value: selectedForm.title,
                                    onChanged: (value) {
                                      selectedFormNotifier.value =
                                          NoteStyle.values
                                              .firstWhere((e) =>
                                          e.title == value);
                                    },
                                  );
                                }
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Tooltip(
                                message: hasInternet
                                    ? ''
                                    : AppTexts.internetNeeded,
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: isLoadingNotifier,
                                  builder: (context, value, child) {
                                    return ElevatedButton(
                                      onPressed: (hasInternet && !isLoadingNotifier.value)
                                          ? () async {
                                        isLoadingNotifier.value = true;

                                        try {
                                          final improvedText = await improveRequest(
                                            form: selectedFormNotifier.value.title,
                                            title: widget.titleController.text.trim(),
                                            content: widget.contentController.text.trim(),
                                          );

                                          if (!mounted) return;

                                          widget.contentController.value = TextEditingValue(
                                            text: improvedText,
                                            selection: TextSelection.collapsed(
                                                offset: improvedText.length),
                                          );
                                        } catch (e) {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                                content: Text('خطا در دریافت متن از هوش مصنوعی')),
                                          );
                                        } finally {
                                          if (mounted) {
                                            isLoadingNotifier.value = false;
                                          }
                                        }
                                      } : null,

                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          backgroundColor: Theme
                                              .of(context)
                                              .primaryColor
                                      ),
                                      child: Text(
                                        AppTexts.developText,
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: Colors.white),
                                      ),
                                    );
                                  }
                                ),
                              ),
                            ),
                            AppSpacing.height16,
                          ],
                        ),
                        AppSpacing.height10,
                        Text(
                            'Powered by AI',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.blueGrey)
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isLoadingNotifier,
              builder: (context, isLoading, _) {
                return isLoading ? Loadingwidget() : const SizedBox.shrink();
              },
            ),

          ]
      ),
    )
        : SizedBox.shrink();
  }
}
