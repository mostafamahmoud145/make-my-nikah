
part of 'signup_bloc.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {
  @override
  String toString() => 'SignupInitialState';
}

class SignUpInProgress extends SignupState {
  @override
  String toString() => 'SignUpInProgressState';
}

class SignupWithGoogleInitialCompleted extends SignupState {
  final User firebaseUser;

  SignupWithGoogleInitialCompleted(this.firebaseUser);

  @override
  String toString() => 'SignupWithGoogleInitialCompletedState';
}

class SignupWithGoogleInitialFailed extends SignupState {
  @override
  String toString() => 'SignupWithGoogleInitialFailedState';
}

class SignupWithMobileCompleted extends SignupState {
  final String phoneNumber;

  SignupWithMobileCompleted({required this.phoneNumber});

  @override
  String toString() => 'SignupWithMobileCompletedState';
}

class VerificationInProgress extends SignupState {
  @override
  String toString() => 'VerificationInProgressState';
}

class VerificationFailed extends SignupState {
  @override
  String toString() => 'VerificationInFailedState';
}

class VerificationCompleted extends SignupState {
  @override
  String toString() => 'VerificationCompletedState';
}

class VerifyphoneNumberInProgress extends SignupState {
  @override
  String toString() => 'VerifyphoneNumberInProgressState';
}

class VerifyphoneNumberFailed extends SignupState {
  @override
  String toString() => 'VerifyphoneNumberInFailedState';
}

class VerifyphoneNumberCompleted extends SignupState {
  final User user;

  VerifyphoneNumberCompleted(this.user);

  @override
  String toString() => 'VerifyphoneNumberCompletedState';
}

class SavingUserDetails extends SignupState {
  @override
  String toString() => 'SavingUserDetailsState';
}

class FailedSavingUserDetails extends SignupState {
  @override
  String toString() => 'FailedSavingUserDetailsState';
}

class CompletedSavingUserDetails extends SignupState {
  final GroceryUser user;
  CompletedSavingUserDetails(this.user);

  @override
  String toString() => 'CompletedSavingUserDetailsState';
}
