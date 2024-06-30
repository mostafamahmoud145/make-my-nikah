
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Future<String> getDeviceType() async {
  String deviceType = 'Unknown';
  try {
    if (Platform.isAndroid) {
      deviceType = 'Android';
    } else if (Platform.isIOS) {
      deviceType = 'iOS';
    } else if (kIsWeb) {
      deviceType = 'web';
    } else {
      deviceType = 'Unknown';
    }
  } on PlatformException {
    deviceType = 'Unknown';
  }
  return deviceType;
}