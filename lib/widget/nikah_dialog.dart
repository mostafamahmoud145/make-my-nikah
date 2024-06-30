import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/widget/resopnsive.dart';

// ignore: must_be_immutable
class NikahDialogWidget extends StatefulWidget {
  Widget dialogContent;
  double? radius;
  double? padTop;
  double? padReight;
  double? padLeft;
  double? padButtom;

  NikahDialogWidget({
    required this.dialogContent,
    this.radius,
    this.padTop,
    this.padReight,
    this.padLeft,
    this.padButtom,
  });

  @override
  State<NikahDialogWidget> createState() => _NikahDialogWidgetState();
}

class _NikahDialogWidgetState extends State<NikahDialogWidget> {
  String lang = 'ar';

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    return AlertDialog(

      insetPadding: EdgeInsets.only(left: AppPadding.p32.w,right:AppPadding.p32.w ),
      contentPadding: EdgeInsets.only(
        right:
            widget.padReight != null ? widget.padReight! : AppPadding.p21_3.w,
        left: widget.padLeft != null ? widget.padLeft! : AppPadding.p38_6.w,
        top: widget.padTop != null ? widget.padTop! : AppPadding.p38_6.w,
        bottom:
            widget.padButtom != null ? widget.padButtom! : AppPadding.p21_3.h,
      ),

      backgroundColor: AppColors.white1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
                Radius.circular(AppRadius.r21_3.r),
              ),
      ),
      scrollable: true,
      elevation: 0.0,
      content:widget.dialogContent,
    );
  }
}