import 'package:flutter/cupertino.dart';
import '../repositories/backup_repository.dart';
import '../../../features/note/repositories/note_repository.dart';
import 'package:googleapis/drive/v2.dart' as drive;

class BackUpProvider extends ChangeNotifier {
  final NoteRepository _noteRepository = NoteRepository();
  final BackUpRepository _backUpRepository = BackUpRepository();

  List<drive.File> _backupFiles = [];
  List<drive.File> get backupFiles => _backupFiles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadBackupFiles() async {
    _setLoading(true);
    try {
      final files = await _backUpRepository.listBackupFiles();
      _backupFiles = files ?? [];
    } catch (e) {
      _backupFiles = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> exportNotes() async {
    _setLoading(true);
    try {
      await _backUpRepository.exportNotesToDrive();
    } on Exception catch (e) {
      _setLoading(false);
      rethrow;
    }
    await loadBackupFiles();
    _setLoading(false);
  }


  Future<void> importNotes(String fileId) async {
    _setLoading(true);
    try {
      await _backUpRepository.importNotesFromDrive(fileId);
      await _noteRepository.loadNotes();
    } catch (e) {
    } finally {
      _setLoading(false);
    }
  }
}

