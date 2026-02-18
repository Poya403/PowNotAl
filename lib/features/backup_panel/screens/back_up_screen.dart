import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_radius.dart';
import '../../../utils/app_texts.dart';
import '../../../widgets/text_fields/custom_drop_down_field.dart';
import '../providers/back_up_provider.dart';

class BackUpScreen extends StatefulWidget {
  const BackUpScreen({super.key});

  @override
  State<BackUpScreen> createState() => _BackUpScreenState();
}

class _BackUpScreenState extends State<BackUpScreen> {
  String? selectedFileId;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<BackUpProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.loadBackupFiles();
      if (provider.backupFiles.isNotEmpty) {
        setState(() {
          selectedFileId = provider.backupFiles.last.id;
          _initialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Center(
      child: SizedBox(
        width: isDesktop
            ? MediaQuery.of(context).size.width * 0.5
            : double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.radius10),
          elevation: 2,
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: isDesktop
                ? const EdgeInsets.fromLTRB(100, 40, 100, 40)
                : const EdgeInsets.all(16),
            child: Consumer<BackUpProvider>(
              builder: (context, provider, _) {
                final filesMap = {
                  for (var f in provider.backupFiles) f.id!: f.title ?? AppTexts.unknown
                };

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: provider.isLoading ? 0.5 : 1,
                      child: IgnorePointer(
                        ignoring: provider.isLoading,
                        child: _buildContent(provider, filesMap),
                      ),
                    ),
                    if (provider.isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BackUpProvider provider, Map<String, String> filesMap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.backup),
          label: Text(AppTexts.backUp),
          onPressed: provider.isLoading
              ? null
              : () async {
            try {
              await provider.exportNotes();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('بکاپ با موفقیت انجام شد')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('خطا: $e')),
              );
            }
          },
        ),
        const SizedBox(height: 20),

        if (provider.backupFiles.isNotEmpty)
          CustomDropdownField(
            labelText: AppTexts.selectDriveFile,
            items: filesMap.values.toList(),
            value: selectedFileId != null
                ? filesMap[selectedFileId]
                : null,
            onChanged: (val) {
              final id = filesMap.entries
                  .firstWhere((e) => e.value == val,
                  orElse: () => filesMap.entries.first)
                  .key;
              setState(() => selectedFileId = id);
            },
            onPressed: () {
              setState(() => selectedFileId = null);
            },
          ),

        const SizedBox(height: 10),

        ElevatedButton.icon(
          icon: const Icon(Icons.restore),
          label: Text(AppTexts.restoreBackup),
          onPressed: (selectedFileId == null || provider.isLoading)
              ? null
              : () async {
                  try {
                    await provider.importNotes(selectedFileId!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ریستور با موفقیت انجام شد')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('خطا در ریستور: $e')),
                    );
                  }
                },
        ),

        const SizedBox(height: 30),

        Text(
          provider.backupFiles.isEmpty
              ? AppTexts.noBackups
              : '${AppTexts.latestVersion}: ${provider.backupFiles.last.title ?? ''}',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
