import 'package:pow_note_ai/features/note/repositories/database_helper.dart';
import 'package:pow_note_ai/features/note/models/note_model.dart';

class NoteRepository{
  final DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<Note>> loadNotes() async {
    final database = await databaseHelper.database;
    final data = await database.query('notes', orderBy: 'id DESC');

    return data.map((e) => Note.fromJson(e)).toList();
  }

  Future<void> saveNote(Note note) async {
    final database = await databaseHelper.database;
    if(note.id == null){
      await database.insert('notes', note.toJson());
    } else{
      await database.update('notes', note.toJson(), where: 'id = ?', whereArgs: [note.id]);
    }
  }

  Future<void> deleteNote(int id) async {
    final database = await databaseHelper.database;
    await database.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}