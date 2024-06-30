
import 'package:flutter/material.dart';
import '../../localization/set_localization.dart';

 getTranslated(BuildContext context, String key) {
  return SetLocalization.of(context)?.getTranslateValue(key).toString();
}
