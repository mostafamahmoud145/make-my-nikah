
import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../models/user.dart';
import '../../repositories/authentication_repository.dart';
import '../../repositories/user_data_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthenticationRepository authenticationRepository;
  final UserDataRepository userDataRepository;

  SignupBloc({  required this.authenticationRepository,  required this.userDataRepository,}) : super( SignupInitial());

  SignupState get initialState => SignupInitial();

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    print(event);

    if (event is SignupWithphoneNumber) {
      yield* mapSignupWithphoneNumberEventToState(
        phoneNumber: event.phoneNumber,
      );
    }  else if (event is VerifyphoneNumber) {
      yield* mapVerifyphoneNumberToState(event.otp);
    } else if (event is ResendCode) {
      yield* mapSignupWithphoneNumberEventToState(
        phoneNumber: event.phoneNumber,
      );
    } else if (event is SaveUserDetails) {
      yield* mapSaveUserDetailsToState(
        name: event.name,
        countryCode: event.countryCode,
        countryISOCode: event.countryISOCode,
        phoneNumber: event.phoneNumber,
        firebaseUser: event.firebaseUser,
        loggedInVia: event.loggedInVia,
        userType: event.userType, email: '',
      );
    }
  }

  Stream<SignupState> mapSignupWithphoneNumberEventToState({
    String? phoneNumber,
  }) async* {
    yield VerificationInProgress();

    try {
      bool? isSent = await authenticationRepository.signInWithphoneNumber(phoneNumber!);
      if (isSent!) {
        yield VerificationCompleted();
      } else {
        yield VerificationFailed();
      }
    } catch (e) {
      print('ERROR');
      print(e);
    }
  }

  Stream<SignupState> mapVerifyphoneNumberToState(String otp) async* {
    yield VerifyphoneNumberInProgress();

    try {
      User? firebaseUser = await authenticationRepository.signInWithSmsCode(otp);
      if (firebaseUser != null) {
        yield VerifyphoneNumberCompleted(firebaseUser);
      } else {
        yield VerifyphoneNumberFailed();
      }
    } catch (e) {
      yield VerifyphoneNumberFailed();
      print(e);
    }
  }

  Stream<SignupState> mapResendCodeToState(String phoneNumber) async* {
    yield VerificationInProgress();

    try {
      bool? isSent = await authenticationRepository.signInWithphoneNumber(phoneNumber);
      if (isSent!) {
        yield VerificationCompleted();
      } else {
        yield VerificationFailed();
      }
    } catch (e) {
      print('ERROR');
      print(e);
    }
  }



  Stream<SignupState> mapSaveUserDetailsToState({
    required String name,
    required String countryCode,
    required String countryISOCode,
    required String phoneNumber,
    required String email,
    required User firebaseUser,
    required String loggedInVia,
    required String userType,
  }) async* {
    yield SavingUserDetails();
    try {
      GroceryUser? user = await userDataRepository.saveUserDetails(
        firebaseUser.uid,
        name,
        email,
        phoneNumber,
        '',
        '',
        loggedInVia,
        userType,
        countryCode,
        countryISOCode
      );

      if (user != null) {
        yield CompletedSavingUserDetails(user);
      } else {
        yield FailedSavingUserDetails();
      }
    } catch (e) {
      print(e);
      yield FailedSavingUserDetails();
    }
  }
}
