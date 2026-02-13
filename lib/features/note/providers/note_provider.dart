import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../repositories/note_repository.dart';

class NoteProvider with ChangeNotifier {
  final NoteRepository _repository = NoteRepository();
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> loadNotes() async {
    _notes = await _repository.loadNotes();
    notifyListeners();
  }

  Future<void> saveNote(Note note) async {
    await _repository.saveNote(note);
    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await _repository.deleteNote(id);
    await loadNotes();
  }
}
