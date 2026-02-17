import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v2.dart' as drive;
import '../repository/auth_repository.dart';

class DriveAuthService {
  Future<drive.DriveApi> getDriveApi() async {
    final GoogleSignInAccount? account = await GoogleSignIn().signIn();
    if(account == null) throw Exception("Sign in cancelled");

    final authHeaders = await account.authHeaders;
    final client = GoogleAuthClient(authHeaders);

    return drive.DriveApi(client);
  }
}
