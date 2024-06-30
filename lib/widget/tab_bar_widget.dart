import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({
    Key? key,
    this.height,
    this.width = double.infinity,
    this.margin,
    required this.buttons,
    this.padding,
    this.radius,
  }) : super(key: key);
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? AppSize.h0,
      width: width ?? AppSize.w0,
      alignment: Alignment.center,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 0)),
        color:AppColors.tabBar,
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: buttons),
    );
  }
}
