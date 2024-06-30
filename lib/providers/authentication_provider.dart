
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/paths.dart';
import '../../providers/base_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AuthenticationProvider extends BaseAuthenticationProvider {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String _verificationCode = '';


  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void dispose() {}

  @override
  Future<User?> getCurrentUser() async {
    return firebaseAuth.currentUser;
  }


  @override
  Future<bool> signOutUser() async {
    try {
      Future.wait([
        firebaseAuth.signOut(),
      ]);

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> isLoggedIn() async {
    final user = firebaseAuth.currentUser;
    print("signinBloc11");

    if (user != null) {
      //check if blocked
      print("signinBloc12");

      DocumentSnapshot snapshot = await db.collection(Paths.usersPath).doc(user.uid).get();
      Map data =snapshot.data() as Map;
      //snapshot.data();

      if (snapshot.exists) {
        print("signinBloc13");

        if (data['isBlocked']) {
          await firebaseAuth.signOut();
          return 'Your account has been blocked';
        } else {
          print("dddd" + data['userType']);
          return 'userType is' + data['userType'];
        }
      } else {
        await firebaseAuth.signOut();
        return 'Account does not exist';
      }
    } else {
      print("signinBloc14");

      return null;
    }
  }

  @override
  Future<bool> signInWithphoneNumber(String phoneNumber) async {
    try {
      int? forceResendToken;
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (authCredential) =>   phoneVerificationCompleted(authCredential),
        verificationFailed: (authException) => phoneVerificationFailed(authException, phoneNumber),
        codeSent: (verificationId, [code]) =>   phoneCodeSent(verificationId, [code!]),
        codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout,
        forceResendingToken: forceResendToken,
      );
      print("dreamphonesendotpSuccess");
      return true;
    } catch (e) {
      print("dreamphonesendotpfailed");
      print(e);
      return false;
    }
  }

  phoneVerificationCompleted(PhoneAuthCredential authCredential) {
    print("verification completed ${authCredential.smsCode}");
    print('verified');
  }

  phoneVerificationCompleted2(AuthCredential authCredential) {
    print('verified');
  }

  phoneVerificationFailed(FirebaseException authException, String phone) async {
    print('failedssssssss');
    String id = Uuid().v4();
    await FirebaseFirestore.instance
        .collection(Paths.errorLogPath)
        .doc(id)
        .set({
      'timestamp': Timestamp.now(),
      'id': id,
      'seen': false,
      'desc': authException.message.toString(),
      'phone': phone,
      'screen': "otp",
      'function': authException.code.toString(),
    });
    print('Message: ${authException.message}');
    print('Code: ${authException.code}');
  }

  phoneCodeAutoRetrievalTimeout(String verificationCode) {
    print("ggggggkkkkkkkk");
    print(verificationCode);
    this._verificationCode = verificationCode;
  }

  phoneCodeSent(String verificationCode, List<int> code) {
    print("ggggggkkkkkkkk2222");
    print(verificationCode);
    print("ggggggkkkkkkkk2222333");
    print(code.toString());
    this._verificationCode = verificationCode;
  }

  @override
  Future<User?> signInWithSmsCode(String smsCode) async {
    try {
      AuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: _verificationCode, smsCode: smsCode);
      UserCredential authResult =
      await firebaseAuth.signInWithCredential(authCredential);
      if (authResult.user != null) {
        print('');
        print('PHONE AUTH UID :: ' + authResult.user!.uid);
        print('PHONE AUTH CREDENTIALS :: ' + authCredential.toString());
        print('');
        return authResult.user;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      print("phonenumber11error " + e.toString());
      return null;
    }
  }

  @override
  Future<String?> checkIfBlocked(String phoneNumber) async {
    try {
      //check if blocked
      QuerySnapshot snapshot = await db
          .collection(Paths.usersPath)
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      if (snapshot.size > 0) {
        for (var item in snapshot.docs) {
          Map<String, dynamic> data = item.data() as Map<String, dynamic> ;
          if (data['isBlocked']) {
            return 'Your account has been blocked';
          }
        }
      } else {
        return 'Account does not exist';
      }
      return '';
    } catch (e) {
      print(e);
      return null;
    }
  }
}
