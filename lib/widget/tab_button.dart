import 'package:flutter/material.dart';

import '../config/app_fonts.dart';


class TabButton extends StatelessWidget {
  const TabButton(
      {super.key,
        required this.onPress,
        required this.Width,
        this.Height,
        required this.ButtonRadius,
        required this.ButtonColor, required this.Title, required this.TextFont, required this.TextSize,required this.TextColor, this.Padding});

  final Function() onPress;

  final double? ButtonRadius;
  final double? Width;
  final double? Height;
  final double? Padding;
  final Color? ButtonColor;
  final String Title;
  final String? TextFont;
  final double? TextSize;
  final Color? TextColor;
  @override
  Widget build(BuildContext context) {

    return InkWell(
      splashColor: Colors.green.withOpacity(0.6),
      onTap: onPress,
      child: Container(
        height: Height,
        width: Width,
        padding:  EdgeInsets.all(Padding??0),
        decoration: BoxDecoration(
          color: ButtonColor,
          borderRadius: BorderRadius.circular(ButtonRadius!),
        ),
        child: Center(
          child: Text(Title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TextColor,
              fontWeight:AppFontsWeightManager.bold300,
              fontFamily: TextFont,fontStyle: FontStyle.normal,
              //pb in font  21 to 17.3
              fontSize: TextSize,
            ),
          ),
        ),
      ),
    );
  }
}