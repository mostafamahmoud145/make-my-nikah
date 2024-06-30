import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CallKitService {
  static Future<void> displayIncomingCall(Map<String, dynamic> data) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? langCode = await _prefs.getString('languageCode');

    final params = CallKitParams(
      id: Uuid().v4(),
      nameCaller: data['callerName'],
      appName: 'Dream',
      //avatar: defaultAvatar,
      handle: langCode != null && langCode == 'ar'
          ? "مكالمة واردة"
          : "Incoming Call",
      type: 0,
      duration: 30000,
      textAccept: langCode != null && langCode == 'ar' ? "قبول" : 'Accept',
      textDecline: langCode != null && langCode == 'ar' ? "رفض" : 'Decline',
      missedCallNotification: NotificationParams(
        showNotification: true,
        isShowCallback: false,
        subtitle: langCode != null && langCode == 'ar'
            ? " مكالمة فائتة"
            : 'Missed Calls',
        callbackText: 'Call back',
      ),
      extra: data,
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#FFFFFF',
        incomingCallNotificationChannelName:
            langCode != null && langCode == 'ar'
                ? " مكالمة جديدة"
                : langCode == "en"
                    ? 'Incoming Calls'
                    : langCode == "fr"
                        ? "Nouvel appel"
                        : "Panggilan baharu",
        //backgroundUrl: 'assets/test.png',
        actionColor: '#4CAF50',
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }
}
