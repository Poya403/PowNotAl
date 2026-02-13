import 'package:flutter/material.dart';
import 'package:pow_note_ai/utils/app_radius.dart';
import 'package:pow_note_ai/utils/app_texts.dart';
import 'package:pow_note_ai/widgets/no_data_widget.dart';
import 'package:provider/provider.dart';
import '../../../utils/date_converter.dart';
import '../providers/note_provider.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadNotes(context);
    });
  }

  void loadNotes(BuildContext context) async {
    final noteProvider = context.read<NoteProvider>();
    await noteProvider.loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.read<NoteProvider>();
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10.0, 15.0, 0, 0),
                  child: ElevatedButton(
                    onPressed: () async => await noteProvider.loadNotes(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Icon(Icons.refresh, color: Colors.white),
                  ),
                ),
              ],
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
                        color: Colors.white,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          leading: isDesktop
                              ? SizedBox(
                                  width: 50,
                                  child: CircleAvatar(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    child: Icon(
                                      Icons.note,
                                      color: Colors.white,
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
                                        if (note.id != null) {
                                          await noteProvider.deleteNote(
                                            note.id!,
                                          );
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/note_edit',
                                          arguments: {'note': note},
                                        );
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
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.blue,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.edit, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            final confirmed = await showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
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
                              await noteProvider.deleteNote(note.id!);
                            }
                            return confirmed;
                          } else {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pushNamed(
                                context,
                                '/note_edit',
                                arguments: {'note': note},
                              );
                            });
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
