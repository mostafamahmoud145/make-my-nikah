
import 'package:flutter/material.dart';
import 'package:grocery_store/localization/localization_methods.dart';

String convertTime(String value, BuildContext context) {
  String minues = "00";
  String? finalTime;

  if (DateTime.parse(value).toLocal().minute != 0)
    minues = DateTime.parse(value).toLocal().minute.toString();
  if (DateTime.parse(value).toLocal().hour > 12)
    finalTime = ((DateTime.parse(value).toLocal().hour) - 12).toString() +
        ":" +
        minues +
        '' +
        getTranslated(context, 'Pm');
  else if (DateTime.parse(value).toLocal().hour == 12)
    finalTime = ((DateTime.parse(value).toLocal().hour)).toString() +
        ":" +
        minues +
        ''+
        getTranslated(context, 'Pm');
  else
    finalTime = DateTime.parse(value).toLocal().hour.toString() +
        ":" +
        minues +
        '' +
        getTranslated(context, 'Am');

  return finalTime;
}
