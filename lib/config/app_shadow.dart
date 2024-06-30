import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_store/config/colorsFile.dart';

class AppShadow {
  static final primaryShadow = BoxShadow(
    color: Color.fromRGBO(156, 57, 129, 0.12),
    blurRadius: 9.5.r,
    spreadRadius: 0.0,
    offset: Offset(0.0, 1.0), // shadow direction: bottom right
  );
  static final primaryShadow2 = BoxShadow(
      color: AppColors.warmPurple,
      blurRadius: 9.5.r,
      spreadRadius: 0.0,
      offset: Offset(0.0, 1.0)// shadow direction: bottom right
  );
}