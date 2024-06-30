

import 'dart:developer';

import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';

Future<bool> stopForegroundService() async {
  log('stopground');
  await FlutterBackground.initialize();
  await FlutterBackground.disableBackgroundExecution();
  await FlutterForegroundPlugin.stopForegroundService();

  return true;
}
