
part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class SignupWithphoneNumber extends SignupEvent {
  final String name;
  final String phoneNumber;
  final String email;

  SignupWithphoneNumber({
    required this.name,
    required this.phoneNumber,
    required this.email,
  });

  @override
  String toString() => 'SignupWithMobileEvent';
}

class SignupWithGoogle extends SignupEvent {
  @override
  String toString() => 'SignupWithGoogleEvent';
}

class VerifyphoneNumber extends SignupEvent {
  final String otp;

  VerifyphoneNumber(this.otp);

  @override
  String toString() => 'VerifyphoneNumberEvent';
}

class SaveUserDetails extends SignupEvent {
  final String name;
  final String phoneNumber;
  final String countryISOCode;
  final String countryCode;
  final User firebaseUser;
  final String loggedInVia;
  final String userType;
  SaveUserDetails({
    required this.name,
    required this.phoneNumber,
    required this.countryISOCode,
    required this.countryCode,
    required this.firebaseUser,
    required this.loggedInVia,
    required this.userType,
  });

  @override
  String toString() => 'SaveUserDetailsEvent';
}

class ResendCode extends SignupEvent {
  final String phoneNumber;
  final String name;
  final String countryISOCode;
  final String countryCode;
  final String userType;
  ResendCode({
    required this.name,
    required this.phoneNumber,
    required this.countryCode,
    required this.countryISOCode,
    required this.userType,

  });

  @override
  String toString() => 'ResendCodeEvent';
}
