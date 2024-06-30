
import 'package:fluttertoast/fluttertoast.dart';

import '../config/app_fonts.dart';
import '../config/colorsFile.dart';

void showFailedSnackBar(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.red,
      textColor: AppColors.white,
      fontSize: AppFontsSizeManager.s16);
}