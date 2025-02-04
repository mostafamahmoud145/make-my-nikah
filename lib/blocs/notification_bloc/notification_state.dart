
part of 'notification_bloc.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class GetAllNotificationsInProgressState extends NotificationState {
  @override
  String toString() => 'GetAllNotificationsInProgressState';
}

class GetAllNotificationsFailedState extends NotificationState {
  @override
  String toString() => 'GetAllNotificationsFailedState';
}

class GetAllNotificationsCompletedState extends NotificationState {
  @override
  String toString() => 'GetAllNotificationsCompletedState';
}

class GetNotificationsUpdateState extends NotificationState {
  final UserNotification userNotification;

  GetNotificationsUpdateState(this.userNotification);
  @override
  String toString() => 'GetNotificationsUpdateState';
}

class EmptyNotificationsUpdateState extends NotificationState {

  @override
  String toString() => 'EmptyNotificationsUpdateState';
}

class NotificationMarkReadInProgressState extends NotificationState {
  @override
  String toString() => 'NotificationMarkReadInProgressState';
}

class NotificationMarkReadFailedState extends NotificationState {
  @override
  String toString() => 'NotificationMarkReadFailedState';
}

class NotificationMarkReadCompletedState extends NotificationState {
  @override
  String toString() => 'NotificationMarkReadCompletedState';
}
