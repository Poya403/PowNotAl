import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v2.dart' as drive;
import '../repository/auth_repository.dart';

class DriveAuthService {

  static const _scopes = [
    drive.DriveApi.driveAppdataScope,
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: _scopes,
    serverClientId:
    "716004938098-qtd1b63u03tdojv824cf2h5amspbncc2.apps.googleusercontent.com",
  );

  Future<drive.DriveApi> getDriveApi() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw Exception("Sign in cancelled");
    }

    final authHeaders = await account.authHeaders;
    final client = GoogleAuthClient(authHeaders);

    return drive.DriveApi(client);
  }
}

