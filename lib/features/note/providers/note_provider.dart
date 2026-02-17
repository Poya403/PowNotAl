import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../repositories/note_repository.dart';

class NoteProvider with ChangeNotifier {
  final NoteRepository _repository = NoteRepository();

  List<Note> _notes = [];
  bool _isLoading = false;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadNotes() async {
    _setLoading(true);
    _notes = await _repository.loadNotes();
    _setLoading(false);
  }

  Future<void> loadTrashList() async {
    _setLoading(true);
    _notes = await _repository.loadTrashList();
    _setLoading(false);
  }
  
  Future<void> saveNote(Note note) async {
    _setLoading(true);
    await _repository.saveNote(note);
    await loadNotes();
    _setLoading(false);
  }

  Future<void> trashNote(int id) async {
    _setLoading(true);
    await _repository.trashNote(id);
    await loadNotes();
    _setLoading(false);
  }

  Future<void> unTrashNote(int id) async {
    _setLoading(true);
    await _repository.unTrashNote(id);
    await loadTrashList();
    _setLoading(false);
  }
  
  Future<void> deleteNote(int id) async {
    _setLoading(true);
    await _repository.deleteNote(id);
    await loadTrashList();
    _setLoading(false);
  }
}
