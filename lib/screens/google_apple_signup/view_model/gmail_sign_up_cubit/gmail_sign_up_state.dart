part of 'gmail_sign_up_cubit.dart';

@immutable
sealed class GmailSignUpState {
  GmailSignUpState();


}

final class InitialGmailSignUpState extends GmailSignUpState {
  InitialGmailSignUpState();
}

final class GmailSignUpLoadingState extends GmailSignUpState {
  GmailSignUpLoadingState();
}

class GmailSignUpSuccessState extends GmailSignUpState {
  final String? email;
  final String? uid;
  GmailSignUpSuccessState({
    this.email,
    this.uid,
  });
}

final class GmailSignUpErrorState extends GmailSignUpState {
  GmailSignUpErrorState();
}

