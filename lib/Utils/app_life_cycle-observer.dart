import 'package:flutter/cupertino.dart';
import 'package:grocery_store/methodes/parse_duration.dart';
import 'package:grocery_store/services/shared%20preferences/shared_preferences.dart';


class AppLifecycleObserver with WidgetsBindingObserver {
  DateTime? appStartTime;
  DateTime? appEndTime;
  void initialize() {
    WidgetsBinding.instance.addObserver(this);
    if(CashHelper.getData(key: 'rate') == null)
      {
        appStartTime = DateTime.now();
      }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(CashHelper.getData(key: 'rate') == null ){
      if (state == AppLifecycleState.paused) {
        appEndTime = DateTime.now();
        Duration total = appEndTime!.difference(appStartTime!);
        print(total);
        if(CashHelper.getData(key: 'time') == null){
          CashHelper.saveData(key: 'time', value: total.toString());
        }
        else{
          Duration lastTime = parseDuration(CashHelper.getData(key: 'time'));
          CashHelper.saveData(key: 'time', value: (lastTime + total).toString());
          print(CashHelper.getData(key: 'time'));
        }
      }
      if(state == AppLifecycleState.resumed){
        appStartTime = DateTime.now();
      }
    }

  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }


}