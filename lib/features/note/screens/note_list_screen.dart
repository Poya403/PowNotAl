import 'package:flutter/material.dart';
import 'package:pow_note_ai/utils/app_spacing.dart';
import '../models/note_model.dart';
import 'package:pow_note_ai/utils/app_radius.dart';
import 'package:pow_note_ai/utils/app_texts.dart';
import 'package:pow_note_ai/widgets/no_data_widget.dart';
import '../extentions/note_extentions.dart';
import '../extentions/navigation_extentions.dart';
import 'package:provider/provider.dart';
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
    Future.microtask(() => NoteSaveExtension.load(context)());
  }

  void _navigateToEdit({Note? note, bool isReadOnly = false}) async {
    final result = await context.openNoteEditor(
        note: note,
        isReadOnly: isReadOnly
    );

    if (result != null && mounted){
      await context.read<NoteProvider>().loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppTexts.notes),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _navigateToEdit();
            await context.read<NoteProvider>().loadNotes();
          },
          tooltip: AppTexts.addNote,
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.radius30,
          ),
          child: const Icon(Icons.add_circle, color: Colors.white),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10.0, 15.0, 0, 0),
                      child: ElevatedButton(
                        onPressed: () => context.read<NoteProvider>().loadNotes(),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            backgroundColor: Theme.of(context).primaryColor
                        ),
                        child: Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.height10,
                Expanded(
                  child: Consumer<NoteProvider>(
                    builder: (context, provider,_) {
                      final notes = provider.notes;

                      if(notes.isEmpty){
                        return NoDataWidget();
                      }
                      return ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];

                          return Dismissible(
                            key: ValueKey(note.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.red,
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) => note.delete(context)(),
                            child: Container(
                              margin: isDesktop ? EdgeInsets.fromLTRB(10.0, 15.0, 0, 0) : null,
                              padding: isDesktop
                                  ? EdgeInsets.fromLTRB(15.0, 0, 15.0, 0)
                                  : EdgeInsets.fromLTRB(5.0, 0, 5.0, 0) ,
                              child: Card(
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
                                  leading: isDesktop ? SizedBox(
                                    width: 50.0,
                                    child: CircleAvatar(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      child: Icon(Icons.note, color: Colors.white),
                                    ),
                                  ) : SizedBox.shrink(),
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
                                        note.createdDate.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),

                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.grey[700],
                                    ),
                                    onPressed: () async {
                                      _navigateToEdit(note: note);
                                    },
                                  ),

                                  onTap: () {
                                    _navigateToEdit(note: note, isReadOnly: true);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

