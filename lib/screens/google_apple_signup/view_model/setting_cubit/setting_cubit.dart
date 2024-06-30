/* import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/models/setting.dart';
import 'package:grocery_store/screens/google_apple_signup/data/repository/google_apple_signup_repo.dart';


part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit()
      : super(InitialSettingState());
  Future<void> fetchSettings() async {
    emit(SettingLoadingState());
      GoogleAppleSignUpRepo repo =new GoogleAppleSignUpRepo();

    final result = await repo.getSetting();

    result.fold((left) => emit(SettingErrorState()), (right) {
      print('=========> $right');

      emit(SettingSuccessState(setting: right));
    });
  }
  
}
 */
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_store/models/setting.dart';
import 'package:grocery_store/screens/google_apple_signup/data/repository/google_apple_signup_repo.dart';
import 'package:grocery_store/setting_repo.dart';
import 'package:permission_handler/permission_handler.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(InitialSettingState());
  SettingRepo settingRepoRepo = SettingRepo();

  bool microphone = false, camera = false, notification = false, all = false;

  Future<void> getSetting() async {
    try{
      GoogleAppleSignUpRepo repo =new GoogleAppleSignUpRepo();
    emit(SettingLoadingState());
      print('=========>111'); 
    final result = await repo.getSetting();
print('=========>2'); 
    result.fold((left) => emit(SettingErrorState()), (right) {
      print('=========> $right');
      print('=========>'+right.authType);
      emit(SettingSuccessState(setting: right));
    });
    print('=========>3'); 
    }catch(e){
      print("SettingCubitError"+e.toString());
       emit(SettingErrorState());
    }
  }
  Future<void> CheckMicrophonePermission() async {
    emit(CheckMicrophonePermissionLoadingState());
    final result = await settingRepoRepo.checkMicrophonePermission();
    result.fold((left) {
      microphone = false;
      emit(CheckMicrophonePermissionErrorState());
    }, (right) {
      microphone = true;
      emit(CheckMicrophonePermissionSuccessState());
    });
  }

  Future<void> RequestMicrophonePermission() async {
    await Permission.microphone.request();
    CheckMicrophonePermission();
  }

  Future<void> CheckCameraPermission() async {
    emit(CheckCameraPermissionLoadingState());
    final result = await settingRepoRepo.checkCameraPermission();
    result.fold((left) {
      camera = false;
      emit(CheckCameraPermissionErrorState());
    }, (right) {
      camera = true;
      emit(CheckCameraPermissionSuccessState());
    });
  }

  Future<void> RequestCameraPermission() async {
    await Permission.camera.request();
    CheckCameraPermission();
  }

  Future<void> CheckNotificationPermission() async {
    emit(CheckNotificationPermissionLoadingState());
    final result = await settingRepoRepo.checkNotificationPermission();
    result.fold((left) {
      notification = false;
      emit(CheckNotificationPermissionErrorState());
    }, (right) {
      notification = true;
      emit(CheckNotificationPermissionSuccessState());
    });
  }

  Future<void> RequestNotificationPermission() async {
    await Permission.notification.request();
    CheckNotificationPermission();
  }

  //request microphone,camera,notification permissions
  Future<void> RequestAllPermission() async {
    await [
      Permission.microphone,
      Permission.camera,
      Permission.notification,
    ].request();

    CheckAllPermission();
  }

  //check microphone,camera,notification permissions
  Future<void> CheckAllPermission() async {
    CheckMicrophonePermission();

    CheckCameraPermission();

    CheckNotificationPermission();
    print(
        '...........mic $microphone,,,,,,,,,,, not:: $notification,,,,,, cam == $camera');
    all = (microphone == true) && (notification == true) && (camera == true);
  }

}
