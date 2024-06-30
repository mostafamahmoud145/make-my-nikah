import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

part 'apple_sign_up_state.dart';

class AppleSignUpCubit extends Cubit<AppleSignUpState> {
  AppleSignUpCubit() : super(InitialAppleSignUpState());

  Future<void> signInWithApple({
    List<Scope> scopes = const [Scope.email, Scope.fullName],
  }) async {
    // load = true;
    emit(AppleSignUpLoadingState());

    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(AppleIdCredential.identityToken!));

        // Once signed in, return the UserCredential
        final serCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (serCredential.user != null) {
          emit(AppleSignUpSuccessState(
              email: serCredential.user!.email, uid: serCredential.user!.uid));
        } else {
          //load = false;
          emit(AppleSignUpErrorState());
        }
      case AuthorizationStatus.cancelled || AuthorizationStatus.error:
        emit(AppleSignUpErrorState());
        break;

      default:
        emit(AppleSignUpErrorState());
    }
  }
}
