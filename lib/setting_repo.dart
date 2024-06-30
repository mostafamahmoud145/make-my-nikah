import 'package:dartz/dartz.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingRepo {
  Future<Either<bool, bool>> checkMicrophonePermission() async {
    return await _checkPermission(Permission.microphone);
  }

  Future<Either<bool, bool>> checkCameraPermission() async {
    return await _checkPermission(Permission.camera);
  }

  Future<Either<bool, bool>> checkNotificationPermission() async {
    return await _checkPermission(Permission.notification);
  }

// Helper method to check a specific permission.
  ///
  /// [permission] - The [Permission] to be checked.
  /// Returns an [Either] where the left side is `false` if the permission is denied or an error occurs,
  /// and the right side is `true` if the permission is granted.
  Future<Either<bool, bool>> _checkPermission(Permission permission) async {
    try {
      var status = await permission.status;
      print("permission Status= $status");
      if (status.isGranted) {
        return Right(true);
      } else {
        return Left(false);
      }
    } catch (e) {
      print("error ======== >${e.toString()}");
      return Left(false);
    }
  }
}
