import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_store/widget/setting_widget/setting_activation_button.dart';
import 'permission_title_widget.dart';
import 'setting_active_widget.dart';

class PermissionWidget extends StatelessWidget {
  const PermissionWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.condition,
    required this.function,
  });

  final String title;
  final String icon;
  final bool condition;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: AppPadding.p21_3.h, horizontal: AppPadding.p21_3.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PermissionTitleWidget(icon: icon, title: title),
          ConditionalBuilder(
            condition: condition,
            builder: (context) => SettingActiveWidget(),
            fallback: (context) => SettingActivationButton(
              function: function,
            ),
          ),
        ],
      ),
    );
  }
}
