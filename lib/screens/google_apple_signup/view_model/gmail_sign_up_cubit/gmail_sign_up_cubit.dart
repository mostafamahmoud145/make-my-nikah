import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'gmail_sign_up_state.dart';

class GmailSignUpCubit extends Cubit<GmailSignUpState> {
  GmailSignUpCubit()
      : super(InitialGmailSignUpState());

  Future<void> signInWithGoogle() async {
    try {
      emit(GmailSignUpLoadingState());
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("-----------xxxx1");
      if (userCredential.user != null) {
        print("-----------xxxx2");
        emit(GmailSignUpSuccessState(
            email: userCredential.user!.email,
            uid: userCredential.user!.uid));
        print("-----------xxxx3");
      } else {
        print("-----------xxxx4");
        emit(GmailSignUpErrorState());
      }
    } catch (e) {
      print("-----------xxxx5");
      print(e.toString());
      emit(GmailSignUpErrorState());
    }
  }

 
}
