import 'dart:io';
import '../../models/user.dart';
import '../../models/user_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseProvider {
  void dispose();
}

abstract class BaseAuthenticationProvider extends BaseProvider {
  Future<String?> isLoggedIn();
  Future<bool?> signInWithphoneNumber(String phoneNumber);
  Future<String?> checkIfBlocked(String phoneNumber);
  Future<User?> signInWithSmsCode(String smsCode);
  Future<bool?> signOutUser();
  Future<User?> getCurrentUser();
}

abstract class BaseUserDataProvider extends BaseProvider {
  Future<GroceryUser?> getUser(String uid);
  Future<GroceryUser?> getUserByphoneNumber(String phoneNumber);
  Future<GroceryUser?> saveUserDetails({
    String? uid,
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    String? tokenId,
    String? loggedInVia,
    String? userType,
    String? countryCode,
    String? countryISOCode,
  });
  Future<GroceryUser?> getAccountDetails(String uid);
  Future<bool?> updateAccountDetails(GroceryUser user, File profileImage);
  Stream<UserNotification>? getNotifications(String uid);
  Future<void> markNotificationRead(String uid);

}

abstract class BaseStorageProvider extends BaseProvider {}
