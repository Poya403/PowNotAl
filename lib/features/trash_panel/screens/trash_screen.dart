import 'package:flutter/material.dart';
import 'package:pow_note_ai/utils/app_radius.dart';
import 'package:pow_note_ai/utils/app_texts.dart';
import 'package:pow_note_ai/widgets/no_data_widget.dart';
import 'package:provider/provider.dart';
import '../../../utils/date_converter.dart';
import 'package:pow_note_ai/features/note/providers/note_provider.dart';
import 'search_box.dart';

class TrashScreen extends StatefulWidget {
  const TrashScreen({super.key});

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteProvider>().loadTrashList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery
        .of(context)
        .size
        .width > 800;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchBox(),
            Consumer<NoteProvider>(
              builder: (context, provider, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10.0, 15.0, 0, 0),
                      child: ElevatedButton(
                        onPressed: () async => await provider.loadTrashList(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          backgroundColor: Theme
                              .of(context)
                              .primaryColor,
                        ),
                        child: Icon(Icons.refresh, color: Theme.of(context).colorScheme.surface),
                      ),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 10),
            Expanded(
              child: Consumer<NoteProvider>(
                builder: (context, provider, _) {
                  final notes = provider.notes;

                  if (notes.isEmpty) return NoDataWidget();

                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];

                      Widget noteCard = Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.radius16,
                        ),
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          leading: isDesktop
                              ? SizedBox(
                            width: 50,
                            child: CircleAvatar(
                              backgroundColor: Theme
                                  .of(
                                context,
                              )
                                  .colorScheme
                                  .primary,
                              child: Icon(
                                Icons.note,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          )
                              : null,
                          title: Text(
                            note.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                note.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),
                              Text(
                                '${getPersianDate(note.createdDate)} - '
                                    '${getPersianTime(note.createdDate)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: isDesktop
                              ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () async {
                                  final confirmed = await showDialog(
                                    context: context,
                                    builder: (_) =>
                                        AlertDialog(
                                          title: Text(AppTexts.areYouSure),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: Text('خیر'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: Text('بله'),
                                            ),
                                          ],
                                        ),
                                  );
                                  if (note.id != null && confirmed) {
                                    await provider.deleteNote(note.id!);
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.restore,
                                  color: Colors.blueGrey,
                                ),
                                onPressed: () async {
                                  if (note.id != null) {
                                    await provider.unTrashNote(note.id!);
                                  }
                                },
                              ),
                            ],
                          )
                              : null,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/note_view',
                              arguments: {'noteId': note.id},
                            );
                          },
                        ),
                      );

                      if (isDesktop) {
                        return Container(
                          margin: EdgeInsets.fromLTRB(10, 15, 0, 0),
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: noteCard,
                        );
                      }

                      return Dismissible(
                        key: ValueKey(note.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Theme.of(context).colorScheme.surface),
                        ),
                        secondaryBackground: Container(
                          color: Colors.blueGrey,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.restore, color: Theme.of(context).colorScheme.surface),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            final confirmed = await showDialog(
                              context: context,
                              builder: (_) =>
                                  AlertDialog(
                                    title: Text(AppTexts.areYouSure),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text('خیر'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text('بله'),
                                      ),
                                    ],
                                  ),
                            );
                            if (confirmed == true && note.id != null) {
                              await provider.deleteNote(note.id!);
                            }
                              return confirmed;
                            } else {
                              await provider.unTrashNote(note.id!);
                              return false;
                            }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: noteCard,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
