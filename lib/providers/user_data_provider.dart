
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../config/paths.dart';
import '../../models/appAnalysis.dart';
import '../../models/consultPackage.dart';
import '../../models/consultReview.dart';
import '../../models/user.dart';
import '../../models/user_notification.dart';
import '../../providers/base_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class UserDataProvider extends BaseUserDataProvider {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  late GroceryUser user;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static FirebaseDatabase database = FirebaseDatabase(
      databaseURL:'https://make-my-nikah-d49f5-default-rtdb.europe-west1.firebasedatabase.app//');
  static final realtimeDbRef = database.reference();

  @override
  void dispose() {}

  @override
  Future<GroceryUser> getUser(String uid) async {
    DocumentReference docRef = db.collection(Paths.usersPath).doc(uid);
    final DocumentSnapshot documentSnapshot = await docRef.get();

    return GroceryUser.fromMap(documentSnapshot.data() as Map);
  }

  @override
  Future<GroceryUser> getUserByphoneNumber(String phoneNumber) async {

    DocumentReference docRef =
    db.collection(Paths.usersPath).doc("3JWofqSKSsTTxWGKiplPT0hAiVr1");
    final DocumentSnapshot documentSnapshot = await docRef.get();

    return GroceryUser.fromMap(documentSnapshot.data() as Map);
  }

  @override
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
  }) async {
    try {
      List<GroceryUser> users = [];
      DocumentReference ref = db.collection(Paths.usersPath).doc(uid);
      QuerySnapshot querySnapshot = await db
          .collection(Paths.usersPath)
          .where( 'phoneNumber',
        isEqualTo: phoneNumber,
      )
          .get();

      for (var doc in querySnapshot.docs) {
        users.add(GroceryUser.fromMap(doc.data() as Map));
      }
      if (users.length == 0) {
        var data = {
          'accountStatus': 'NotActive',
          'userLang': 'ar',
          'profileCompleted': false,
          'isBlocked': false,
          'uid': uid,
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
          'photoUrl': photoUrl != null ? photoUrl : '',
          'tokenId': tokenId,
          'loggedInVia': loggedInVia,
          "userType": userType,
          "languages": [],
          "rating": 0.0,
          "reviewsCount": 0,
          "balance": 0.0,
          "payedBalance": 0.0,
          "ordersNumbers": 0,
          "chat": false,
          "voice": false,
          "price": "0",
          "userConsultIds": null,
          "order": 0,
          "countryCode": countryCode,
          "countryISOCode": countryISOCode,
          "createdDate": Timestamp.now(),
          "createdDateValue": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .millisecondsSinceEpoch,
        };
        ref.set(data, SetOptions(merge: true));
        final DocumentSnapshot currentDoc = await ref.get();
        user = GroceryUser.fromMap(currentDoc.data() as Map);
        return user;
      } else {
        final DocumentSnapshot currentDoc = await ref.get();

        user = GroceryUser.fromMap(currentDoc.data() as Map);
        return user;
      }
    } catch (e) {

      print("saveUserDetailsmm" + e.toString());
      return null;
    }
  }

  @override
  Stream<AppAnalysis>? getAppAnalysis() {
    AppAnalysis appAnalysis;

    try {
      DocumentReference documentReference = db.doc(Paths.appAnalysisDocPath);
      return documentReference.snapshots().transform(StreamTransformer<
          DocumentSnapshot<Map<String, dynamic>>, AppAnalysis>.fromHandlers(
        handleData: (DocumentSnapshot snap, EventSink<AppAnalysis> sink) {
          if (snap.data != null) {
            appAnalysis = AppAnalysis.fromMap(snap.data() as Map);
            sink.add(appAnalysis);
          }
        },
        handleError: (error, stackTrace, sink) {
          sink.addError(error);
        },
      ));
    } catch (e) {
      print("appanalysissssss" + e.toString());
      return null;
    }
  }
  @override
  Future<List<ConsultReview>?> getConsultReviews(String uid) async {
    List<ConsultReview> reviews;
    try {
      print("ConsultReview1");
      QuerySnapshot querySnapshot = await db
          .collection(Paths.consultReviewsPath)
          .where('consultUid', isEqualTo: uid)
          .limit(3)
          .orderBy("reviewTime", descending: true)
          .get();
      print("ConsultReview2");
      reviews = List<ConsultReview>.from(
        querySnapshot.docs.map(
              (snapshot) => ConsultReview.fromMap(snapshot.data() as Map),
        ),
      );
      print("ConsultReview3" + reviews.length.toString());

      return reviews;
    } catch (e) {
      print(e);
      print("ConsultReview4");

      return null;
    }
  }

  @override
  Future<List<consultPackage>?> getConsultPackages(String uid) async {
    List<consultPackage> packages;
    try {
      print("consultPackage11");

      QuerySnapshot querySnapshot = await db
          .collection(Paths.packagesPath)
          .where('consultUid', isEqualTo: uid)
          .where('active', isEqualTo: true)
          .orderBy("callNum", descending: false)
          .get();
      packages = List<consultPackage>.from(
        querySnapshot.docs.map(
              (snapshot) => consultPackage.fromMap(snapshot.data() as Map),
        ),
      );
      print("consultPackage12");
      print(packages.length);
      return packages;
    } catch (e) {
      print(e);
      print("consultPackage13");

      return null;
    }
  }


  @override
  Future<GroceryUser?> getAccountDetails(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =await db.collection(Paths.usersPath).doc(uid).get();

      GroceryUser currentUser = GroceryUser.fromMap(documentSnapshot.data() as Map);

      return currentUser;
    } catch (e) {
      print(e);

      return null;
    }
  }


  @override
  Future<bool> updateAccountDetails(GroceryUser user, File? profileImage) async {
    try {
      print("hhhh3");
      List<Map> intrList = [];
      for (var add in user.workTimes!) {
        Map tempAdd = Map();
        tempAdd.putIfAbsent('from', () => add.from);
        tempAdd.putIfAbsent('to', () => add.to);
        intrList.add(tempAdd);
      }
      print("hhhh4");
      if (profileImage != null) {
        //upload profile image first
        var uuid = Uuid().v4();
        Reference storageReference =
        firebaseStorage.ref().child('profileImages/$uuid');
        await storageReference.putFile(profileImage);

        var url = await storageReference.getDownloadURL();

        await db.collection(Paths.usersPath).doc(user.uid).set({
          'name': user.name,
          'fullName': user.fullName,
          'phoneNumber': user.phoneNumber,
          'countryCode': user.countryCode,
          'countryISOCode': user.countryISOCode,
          'photoUrl': url,
          'bio': user.bio,
          'type':user.type,
          'workDays': user.workDays,
          'workTimes': intrList,
          'age': user.age,
          'education': user.education,
          'userLang': user.userLang,
          'location': user.location,
          'searchIndex': user.searchIndex,
          'profileCompleted': user.profileCompleted,
          'userType':user.userType,
          'fromUtc': user.fromUtc,
          'toUtc': user.toUtc,
          'country': user.country,
          'length': user.length,
          'weight': user.weight,
          'color': user.color,
          'maritalStatus': user.maritalStatus,
          'smooking': user.smooking,
          'origin': user.origin,
          'employment':user.employment,
          'living': user.living,
          'languages':user.languages,
          'price':user.price,
          'doctrine': user.doctrine,
          'specialization': user.specialization,
          'hijab': user.hijab,
          'partnerSpecifications': user.partnerSpecifications,
          'marriage': user.marriage,
          'childrenNum':user.childrenNum,
          "userName":user.userName,
          "spouse":user.spouse,
          "ImageUrl":url,
          'tribal':user.tribal
        }, SetOptions(merge: true));
      } else {
        //just update details
        await db.collection(Paths.usersPath).doc(user.uid).set({
          'name': user.name,
          'fullName': user.fullName,
          'phoneNumber': user.phoneNumber,
          'countryCode': user.countryCode,
          'countryISOCode': user.countryISOCode,
          'photoUrl': user.photoUrl,
          'bio': user.bio,
          'type':user.type,
          'location': user.location,
          'languages':user.languages,
          'price':user.price,
          'workDays': user.workDays,
          'workTimes': intrList,
          'userLang': user.userLang,
          'searchIndex': user.searchIndex,
          'fromUtc': user.fromUtc,
          'toUtc': user.toUtc,
          'age': user.age,
          'education': user.education,
          'profileCompleted': user.profileCompleted,
          'userType':user.userType,
          'country': user.country,
          'length': user.length,
          'weight': user.weight,
          'color': user.color,
          'maritalStatus': user.maritalStatus,
          'smooking': user.smooking,
          'origin': user.origin,
          'employment':user.employment,
          'living': user.living,
          'doctrine': user.doctrine,
          'specialization': user.specialization,
          'hijab': user.hijab,
          'partnerSpecifications': user.partnerSpecifications,
          'marriage': user.marriage,
          'childrenNum':user.childrenNum,
          "userName":user.userName,
          "spouse": user.spouse,
          "ImageUrl": user.ImageUrl,
          'tribal':user.tribal

        }, SetOptions(merge: true));
      }

      return true;
    } catch (e) {
      print("hhhh5");
      print(e);
      return false;
    }
  }


  @override
  Stream<UserNotification>? getNotifications(String uid) {
    try {
      DocumentReference documentReference =
      db.collection(Paths.noticationsPath).doc(uid);
      return documentReference.snapshots().transform(
        StreamTransformer<DocumentSnapshot<Map<String, dynamic>>,
            UserNotification>.fromHandlers(
          handleData:
              (DocumentSnapshot docSnap, EventSink<UserNotification> sink) {
            UserNotification userNotification =
            UserNotification.fromMap(docSnap.data() as Map);
            print('UIDdddddd :: ${userNotification.uid}');
            sink.add(userNotification);
          },
          handleError: (error, stackTrace, sink) {
            print('ERRORdddddd: $error');
            print(stackTrace);
            sink.addError(error);
          },
        ),
      );
    } catch (e) {
      print("error1111" + e.toString());
      return null;
    }
  }

  @override
  Future<void> markNotificationRead(String uid) async {
    try {
      await db.collection(Paths.noticationsPath).doc(uid).set({
        'unread': false,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
      return null;
    }
  }
}
