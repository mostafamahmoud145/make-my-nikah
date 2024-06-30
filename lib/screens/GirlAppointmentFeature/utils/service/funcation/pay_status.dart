
  import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

import '../../../../../config/paths.dart';
import '../../../../CoacheAppoinmentFeature/utils/service/Funcation/errorLog.dart';

payStatus(String chargeId,loggedUser) async {
    try {
      final uri = Uri.parse('https://api.tap.company/v2/charges/' + chargeId);
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer sk_live_C7V9cpBMFWbt2ukjd3fRxIeD",
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br'
      };
      var response = await get(
        uri,
        headers: headers,
      );
      String responseBody = response.body;
      var res = json.decode(responseBody);

      if (res['status'] == "CAPTURED") {
        String? customerId = res['customer']['id'];
        customerId = customerId != null ? customerId : "";
      } else {
        await FirebaseAnalytics.instance.logEvent(name: "payInfo", parameters: {
          "success": "false",
          "reason": res['status'],
          "userUid": loggedUser!.uid
        });
        String id = Uuid().v4();
        await FirebaseFirestore.instance
            .collection(Paths.errorLogPath)
            .doc(id)
            .set({
          'timestamp': Timestamp.now(),
          'id': id,
          'seen': false,
          'desc': res['status'],
          'phone':
              loggedUser == null ? " " : loggedUser!.phoneNumber,
          'screen': "ConsultantDetailsScreen",
          'function': "payStatus",
        });
        // Helper.ShowToastMessage(getTranslated(context, "failed"), true);
      }
    } catch (e) {
      errorLog("payStatus", e.toString(), loggedUser,"CourseVideosView");
      await FirebaseAnalytics.instance.logEvent(name: "payInfo", parameters: {
        "success": "false",
        "reason": e.toString(),
        "userUid": loggedUser!.uid
      });
      // Helper.ShowToastMessage(getTranslated(context, "failed"), true);
    }
  }
