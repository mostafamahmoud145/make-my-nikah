
part of 'setting_cubit.dart';

@immutable
sealed class SettingState {
  SettingState();


}

final class InitialSettingState extends SettingState {
  InitialSettingState();
}

final class SettingLoadingState extends SettingState {
  SettingLoadingState();
}

class SettingSuccessState extends SettingState {
  final Setting setting;
  SettingSuccessState({
  required  this.setting,
  });
}

final class SettingErrorState extends SettingState {
  SettingErrorState();
}
class CheckMicrophonePermissionLoadingState extends SettingState {}

class CheckMicrophonePermissionSuccessState extends SettingState {}

class CheckMicrophonePermissionErrorState extends SettingState {}

/// check Camera permission states .
class CheckCameraPermissionLoadingState extends SettingState {}

class CheckCameraPermissionSuccessState extends SettingState {}

class CheckCameraPermissionErrorState extends SettingState {}

/// check Notification permission states .
class CheckNotificationPermissionLoadingState extends SettingState {}

class CheckNotificationPermissionSuccessState extends SettingState {}

class CheckNotificationPermissionErrorState extends SettingState {}


