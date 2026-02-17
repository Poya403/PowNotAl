import 'dart:convert';
import 'package:pow_note_ai/features/note/repositories/note_repository.dart';
import 'package:pow_note_ai/features/note/models/note_model.dart';
import 'package:googleapis/drive/v2.dart' as drive;
import '../../../core/google_auth/service/drive_auth_service.dart';

class BackUpRepository {
  final NoteRepository noteRepository = NoteRepository();
  final DriveAuthService driveAuthService = DriveAuthService();

  Future<void> exportNotesToDrive() async {
    final driveApi = await driveAuthService.getDriveApi();

    final notes = await noteRepository.loadNotes();
    final jsonData = jsonEncode(notes.map((e) => e.toJson()).toList());

    final driveFile = drive.File()
      ..title = 'backup_notes_${DateTime.now().microsecondsSinceEpoch}.json'
      ..parents = [drive.ParentReference()..id = 'appDataFolder'];

    final media = drive.Media(
      Stream.value(utf8.encode(jsonData)),
      jsonData.length
    );

    await driveApi.files.insert(driveFile, uploadMedia: media);
  }

  Future<void> importNotesFromDrive(String fileId) async {
    final driveApi = await driveAuthService.getDriveApi();

    final response = await driveApi.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final bytes = await response.stream.fold<List<int>>(
      [], (previous, element) => previous..addAll(element),
    );

    final jsonContent = utf8.decode(bytes);

    final List decoded = jsonDecode(jsonContent);

    await noteRepository.clearAllNotes();

    for (var item in decoded) {
      final note = Note.fromJson(item);
      await noteRepository.saveNote(note);
    }
  }

  Future<List<drive.File>> listBackupFiles() async {
    final driveApi = await driveAuthService.getDriveApi();

    final fileList = await driveApi.files.list(
      q: "'appDataFolder' in parents",
      spaces: 'appDataFolder',
      $fields: 'items(id, title, createdDate)',
    );

    return fileList.items ?? [];
  }
}