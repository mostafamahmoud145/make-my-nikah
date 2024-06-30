
part of 'account_bloc.dart';

@immutable
abstract class AccountState {}

class AccountInitial extends AccountState {}

class GetLoggedUserInProgressState extends AccountState {
  @override
  String toString() => 'GetLoggedUserInProgressState';
}

class GetLoggedUserFailedState extends AccountState {
  @override
  String toString() => 'GetLoggedUserFailedState';
}

class GetLoggedUserCompletedState extends AccountState {
  final GroceryUser user;

  GetLoggedUserCompletedState(this.user);

  @override
  String toString() => 'GetLoggedUserCompletedState';
}
class GetAccountDetailsInProgressState extends AccountState {
  @override
  String toString() => 'GetAccountDetailsInProgressState';
}

class GetAccountDetailsFailedState extends AccountState {
  @override
  String toString() => 'GetAccountDetailsFailedState';
}

class GetAccountDetailsCompletedState extends AccountState {
  final GroceryUser user;

  GetAccountDetailsCompletedState(this.user);

  @override
  String toString() => 'GetAccountDetailsCompletedState';
}
class GetSettingInProgressState extends AccountState {
  @override
  String toString() => 'GetSettingInProgressState';
}

class GetSettingFailedState extends AccountState {
  @override
  String toString() => 'GetSettingFailedState';
}

class GetSettingCompletedState extends AccountState {
  final Setting setting;

  GetSettingCompletedState(this.setting);

  @override
  String toString() => 'GetSettingCompletedState';
}
//----------------------------
class AddAddressInProgressState extends AccountState {
  @override
  String toString() => 'AddAddressInProgressState';
}

class AddAddressFailedState extends AccountState {
  @override
  String toString() => 'AddAddressFailedState';
}

class AddAddressCompletedState extends AccountState {
  @override
  String toString() => 'AddAddressCompletedState';
}

class RemoveAddressInProgressState extends AccountState {
  @override
  String toString() => 'RemoveAddressInProgressState';
}

class RemoveAddressFailedState extends AccountState {
  @override
  String toString() => 'RemoveAddressFailedState';
}

class RemoveAddressCompletedState extends AccountState {
  @override
  String toString() => 'RemoveAddressCompletedState';
}

class EditAddressInProgressState extends AccountState {
  @override
  String toString() => 'EditAddressInProgressState';
}

class EditAddressFailedState extends AccountState {
  @override
  String toString() => 'EditAddressFailedState';
}

class EditAddressCompletedState extends AccountState {
  @override
  String toString() => 'EditAddressCompletedState';
}

class UpdateAccountDetailsInProgressState extends AccountState {
  @override
  String toString() => 'UpdateAccountDetailsInProgressState';
}

class UpdateAccountDetailsFailedState extends AccountState {
  @override
  String toString() => 'UpdateAccountDetailsFailedState';
}

class UpdateAccountDetailsCompletedState extends AccountState {
  @override
  String toString() => 'UpdateAccountDetailsCompletedState';
}
class getAllconsultantsInProgressState extends AccountState {
  @override
  String toString() => 'getAllconsultantsInProgressState';
}

class getAllconsultantsFailedState extends AccountState {
  @override
  String toString() => 'getAllconsultantsFailedState';
}

class getAllconsultantsCompletedState extends AccountState {
  final List<GroceryUser> consultants;

  getAllconsultantsCompletedState(this.consultants);
  @override
  String toString() => 'getAllconsultantsCompletedState';
}

class getConsultPackagesInProgressState extends AccountState {
  @override
  String toString() => 'getConsultPackagesInProgressState';
}

class getConsultPackagesFailedState extends AccountState {
  @override
  String toString() => 'getConsultPackagesFailedState';
}

class getConsultPackagesCompletedState extends AccountState {
  final List<consultPackage> packages;

  getConsultPackagesCompletedState(this.packages);
  @override
  String toString() => 'getConsultPackagesCompletedState';
}

class getConsultReviewsInProgressState extends AccountState {
  @override
  String toString() => 'getConsultReviewsInProgressState';
}

class getConsultReviewsFailedState extends AccountState {
  @override
  String toString() => 'getConsultReviewsFailedState';
}

class getConsultReviewsCompletedState extends AccountState {
  final List<ConsultReview> reviews;

  getConsultReviewsCompletedState(this.reviews);
  @override
  String toString() => 'getConsultPackagesCompletedState';
}
