
import 'dart:io';

import '../../models/appAnalysis.dart';
import '../../models/consultPackage.dart';
import '../../models/consultReview.dart';
import '../../models/user.dart';
import '../../models/user_notification.dart';
import '../../providers/user_data_provider.dart';
import '../../repositories/base_repository.dart';

class UserDataRepository extends BaseRepository {
  UserDataProvider userDataProvider = UserDataProvider();

  Future<GroceryUser> getUser(String uid) => userDataProvider.getUser(uid);

  Future<GroceryUser> getUserByphoneNumber(String phoneNumber) =>
      userDataProvider.getUserByphoneNumber(phoneNumber);

  Future<GroceryUser?> saveUserDetails(
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
  ) =>
      userDataProvider.saveUserDetails(
        email: email,
        phoneNumber: phoneNumber,
        name: name,
        photoUrl: photoUrl,
        tokenId: tokenId,
        uid: uid,
        loggedInVia: loggedInVia,
          userType:userType,
          countryCode:countryCode,
          countryISOCode:countryISOCode
      );
  Stream<AppAnalysis>? getAppAnalysis() =>
      userDataProvider.getAppAnalysis();


  Future<List<consultPackage>?> getConsultPackages(String uid) =>  userDataProvider.getConsultPackages(uid);
  Future<List<ConsultReview>?> getConsultReviewes(String uid) =>  userDataProvider.getConsultReviews(uid);



  Stream<UserNotification>? getNotifications(String uid) =>
      userDataProvider.getNotifications(uid);


  Future<bool> updateAccountDetails(GroceryUser user, File? profileImage) =>
      userDataProvider.updateAccountDetails(user, profileImage);
  Future<GroceryUser?> getAccountDetails(String uid)=>
      userDataProvider.getAccountDetails(uid);
  Future<void> markNotificationRead(String uid)=>
      userDataProvider.markNotificationRead(uid);
  @override
  void dispose() {
    userDataProvider.dispose();
  }
}
