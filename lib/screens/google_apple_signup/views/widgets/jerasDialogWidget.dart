import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';

class DialogWidget extends StatefulWidget {
  Widget dialogContent;
  double? radius;
  double? padTop;
  double? padReight;
  double? padLeft;
  double? padButtom;

  DialogWidget({
    required this.dialogContent,
    this.radius,
    this.padTop,
    this.padReight,
    this.padLeft,
    this.padButtom,
  });

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  String lang = 'ar';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      /*contentTextStyle: TextStyle(
        fontFamily: lang == "ar"
            ? getTranslated(context, 'Ithra')
            : getTranslated(context, 'Montserrat'),
      ),*/
      contentPadding: EdgeInsets.only(
        right:
            widget.padReight != null ? widget.padReight! : AppPadding.p21_3.w,
        left: widget.padLeft != null ? widget.padLeft! : AppPadding.p38_6.w,
        top: widget.padTop != null ? widget.padTop! : AppPadding.p38_6.w,
        bottom:
            widget.padButtom != null ? widget.padButtom! : AppPadding.p21_3.h,
      ),
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.all(
                Radius.circular(AppRadius.r21_3.r),
              ),
      ),
      scrollable: true,
      elevation: 0.0,
      content: (kIsWeb) ? widget.dialogContent : widget.dialogContent,
    );
  }
}
