import '../../providers/base_provider.dart';
import '../../repositories/base_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/authentication_provider.dart';
class AuthenticationRepository extends BaseRepository {
  BaseAuthenticationProvider authenticationProvider = AuthenticationProvider();

  @override
  void dispose() {
    authenticationProvider.dispose();
  }


  Future<bool?> signInWithphoneNumber(String phoneNumber) =>
      authenticationProvider.signInWithphoneNumber(phoneNumber);

  Future<String?> checkIfBlocked(String phoneNumber) =>
      authenticationProvider.checkIfBlocked(phoneNumber);

  Future<User?> signInWithSmsCode(String smsCode) =>
      authenticationProvider.signInWithSmsCode(smsCode);

  Future<bool?> signOutUser() => authenticationProvider.signOutUser();

  Future<String?> isLoggedIn() => authenticationProvider.isLoggedIn();

  Future<User?> getCurrentUser() => authenticationProvider.getCurrentUser();
}
