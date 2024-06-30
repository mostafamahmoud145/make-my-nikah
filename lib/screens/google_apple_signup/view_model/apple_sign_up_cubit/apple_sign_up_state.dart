part of 'apple_sign_up_cubit.dart';

@immutable
sealed class AppleSignUpState {
  AppleSignUpState();

  
}

final class InitialAppleSignUpState extends AppleSignUpState {
  InitialAppleSignUpState();
}

// Update Question States
final class AppleSignUpLoadingState extends AppleSignUpState {
  AppleSignUpLoadingState();
}

class AppleSignUpSuccessState extends AppleSignUpState {
  final String? email;
  final String? uid;
  AppleSignUpSuccessState({
    this.email,
    this.uid,
  });
}

final class AppleSignUpErrorState extends AppleSignUpState {
  AppleSignUpErrorState();
}


