import 'package:pow_note_ai/features/note/repositories/database_helper.dart';
import 'package:pow_note_ai/features/note/models/note_model.dart';

class NoteRepository{
  final DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<Note>> _getNotesByStatus(String status) async {
    final database = await databaseHelper.database;
    final data = await database.query(
        'notes',
        where: 'status = ? OR status IS NULL',
        whereArgs: [status],
        orderBy: 'id DESC'
    );

    return data.map((e) => Note.fromJson(e)).toList();
  }

  Future<List<Note>> loadNotes() => _getNotesByStatus('untrash');
  Future<List<Note>> loadTrashList() => _getNotesByStatus('trash');

  Future<void> saveNote(Note note) async {
    final database = await databaseHelper.database;
    if(note.id == null){
      await database.insert('notes', note.toJson());
    } else{
      await database.update('notes', note.toJson(), where: 'id = ?', whereArgs: [note.id]);
    }
  }

  Future<void> _changeStatus(int id, String status) async {
    final database = await databaseHelper.database;
    await database.update(
        'notes',
        {'status': status},
        where: 'id = ?',
        whereArgs: [id]
    );
  }

  Future<void> trashNote(int id) => _changeStatus(id, 'trash');
  Future<void> unTrashNote(int id) => _changeStatus(id, 'untrash');

  Future<void> deleteNote(int id) async {
    final database = await databaseHelper.database;
    await database.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}