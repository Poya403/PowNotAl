import 'package:pow_note_ai/features/note/repositories/database_helper.dart';
import 'package:pow_note_ai/features/note/models/note_model.dart';

class NoteRepository{
  final DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<Note>> _getNotesByStatus(
      String status, {
        String? title,
        String? startDate,
        String? endDate,
      }) async {
    final database = await databaseHelper.database;

    String where = '(status = ? OR status IS NULL)';
    List<dynamic> whereArgs = [status];

    if (title != null && title.trim().isNotEmpty) {
      where += ' AND (LOWER(title) LIKE ? OR LOWER(content) LIKE ?)';
      final searchValue = '%${title.toLowerCase()}%';
      whereArgs.add(searchValue);
      whereArgs.add(searchValue);
    }

    if (startDate != null && endDate == null) {
      where += ' AND Date(created_date) >= ?';
      whereArgs.add(startDate);
    }

    if (startDate == null && endDate != null) {
      where += ' AND Date(created_date) <= ?';
      whereArgs.add(endDate);
    }

    if (startDate != null && endDate != null) {
      where += ' AND (Date(created_date) BETWEEN ? AND ?)';
      whereArgs.add(startDate);
      whereArgs.add(endDate);
    }

    final data = await database.query(
      'notes',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'created_date DESC',
    );

    return data.map((e) => Note.fromJson(e)).toList();
  }



  Future<List<Note>> loadNotes() => _getNotesByStatus('untrash');
  Future<List<Note>> loadTrashList() => _getNotesByStatus('trash');

  Future<List<Note>> searchNotes({String? title, String? startDate, String? endDate}) async
      => _getNotesByStatus('untrash', title: title, startDate: startDate, endDate: endDate);

  Future<List<Note>> searchTrashNotes({String? title, String? startDate, String? endDate}) async
      => _getNotesByStatus('trash', title: title, startDate: startDate, endDate: endDate);

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

  Future<void> clearAllNotes() async {
    final database = await databaseHelper.database;
    await database.delete('notes');
  }
}