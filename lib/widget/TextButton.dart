// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/localization/localization_methods.dart';

class TextButton1 extends StatelessWidget {
  const TextButton1(
      {super.key,
        required this.onPress,
        required this.Title,
         this.Width,
         this.Height,
        required this.ButtonRadius,
        required this.TextSize, this.ButtonBackground,required this.TextFont,required this.TextColor, this.Icon, this.GradientColor, this.GradientColor2, this.Padding, this.IconSpace, this.IconColor, this.Direction, this.Padding2, this.BoxShadow1, this.IconWidth, this.IconHeight, this.GradientColor3, this.BorderColor, this.Icon2, this.Icon3, this.Begin, this.End});

  final Function() onPress;

  final double? ButtonRadius;
  final Color? ButtonBackground;
  final double? Width;
  final double? Height;
  final String Title;
  final String? TextFont;
  final double? TextSize;
  final Color? TextColor,BorderColor;
  final String? Icon,Icon2,Icon3;

  ////

  final Color? GradientColor,GradientColor2,GradientColor3;
  final TextDirection? Direction;
  final double? Padding,Padding2;
  final double? IconSpace;
  final double? IconWidth;
  final double? IconHeight;
  final Color? IconColor;
  final List<BoxShadow>? BoxShadow1;
  final Alignment? Begin,End;

   LinearGradient get Gradiant => LinearGradient(
     begin: Begin??Alignment.bottomCenter,
     end: End??Alignment.topCenter,


    colors:
    (GradientColor3 != null)?[
      GradientColor!,
      GradientColor2!,
      GradientColor3!


    ]:[
      GradientColor!,
      GradientColor2!,


    ],
  );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return (ButtonBackground!=null)?InkWell(
      onTap: onPress,
      child: (Icon2!=null)?Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (Icon2!.substring(Icon2!.length-3,Icon2!.length)=='png')?
          Image.asset(Icon2!,width: IconWidth,height: IconHeight,color: IconColor,):SvgPicture.asset(
              Icon2!,
              color: IconColor,
              width: IconWidth,
              height: IconHeight
          ),

          SizedBox(width: IconSpace),

          Container(
              width: Width,
              height: Height,
              padding: EdgeInsets.symmetric(vertical: Padding??0, horizontal: Padding2??0),
              decoration:BoxShadow1!=null? BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(ButtonRadius??0)),
                boxShadow: BoxShadow1,
                color: ButtonBackground,
              ):(BorderColor!=null)?
              BoxDecoration(
                border: Border.all(color:BorderColor!,),
                borderRadius: BorderRadius.all(Radius.circular(ButtonRadius??0)),
                color: ButtonBackground,
              ):
              BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(ButtonRadius??0)),
                color: ButtonBackground,
              ),
              child: Icon==null?Center(
                child: Text(
                  Title
                  ,textAlign: TextAlign.center,
                  style:  TextStyle(
                    color: TextColor!,
                    fontWeight: FontWeight.w600,
                    fontFamily: TextFont,
                    fontStyle: FontStyle.normal,
                    fontSize: TextSize??0,
                  ),
                ),
              ):
              Directionality(
                textDirection: Direction!,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Title,
                      style: TextStyle(
                        fontFamily: TextFont,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        color: TextColor!,                    fontSize: TextSize??15,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: IconSpace),
                    (Icon!.substring(Icon!.length-3,Icon!.length)=='png')?
                    Image.asset(Icon!,width: IconWidth,height: IconHeight,color: IconColor,):SvgPicture.asset(
                        Icon!,
                        color: IconColor,
                        width: IconWidth,
                        height: IconHeight
                    ),

                  ],
                ),
              )),
          SizedBox(width: IconSpace),

          (Icon2!.substring(Icon2!.length-3,Icon2!.length)=='png')?
          Image.asset(Icon2!,width: IconWidth,height: IconHeight,color: IconColor,):SvgPicture.asset(
              Icon2!,
              color: IconColor,
              width: IconWidth,
              height: IconHeight
          ),



        ],
      ):Container(
          width: Width,
          height: Height,
          padding: EdgeInsets.symmetric(vertical: Padding??0, horizontal: Padding2??0),
          decoration:BoxShadow1!=null? BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(ButtonRadius??0)),
            boxShadow: BoxShadow1,
            color: ButtonBackground,
          ):(BorderColor!=null)?
          BoxDecoration(
            border: Border.all(color:BorderColor!,),
            borderRadius: BorderRadius.all(Radius.circular(ButtonRadius??0)),
            color: ButtonBackground,
          ):
          BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(ButtonRadius??0)),
            color: ButtonBackground,
          ),
          child: Icon==null?Center(
            child: Text(
              Title
              ,textAlign: TextAlign.center,
              style:  TextStyle(
                color: TextColor!,
                fontWeight: FontWeight.w600,
                fontFamily: TextFont,
                fontStyle: FontStyle.normal,
                fontSize: TextSize??0,
              ),
            ),
          ):
          Directionality(
            textDirection: Direction!,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Title,
                  style: TextStyle(
                    fontFamily: TextFont,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.normal,
                    color: TextColor!,                    fontSize: TextSize??15,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(width: IconSpace),
                (Icon!.substring(Icon!.length-3,Icon!.length)=='png')?
                Image.asset(Icon!,width: IconWidth,height: IconHeight,color: IconColor,):SvgPicture.asset(
                  Icon!,
                  color: IconColor,
                  width: IconWidth,
                  height: IconHeight
                ),

              ],
            ),
          )),
    ):
    InkWell(
      onTap: onPress,
      child: Container(
          width: Width,
          height: Height,
          padding: EdgeInsets.symmetric(vertical: Padding??0, horizontal: Padding2??0),
          decoration: BoxShadow1!=null?BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(ButtonRadius??0)),
            boxShadow: BoxShadow1,
            gradient: Gradiant,
          ):(BorderColor!=null)?BoxDecoration(
            border: Border.all(color:BorderColor!,),
            borderRadius: BorderRadius.all(Radius.circular(ButtonRadius??0)),
            color: ButtonBackground,
          )
              :BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(ButtonRadius??0)),
            gradient: Gradiant,
          ),
          child: Icon==null?Center(
            child: Text(
              Title
              ,textAlign: TextAlign.center,
              style:  TextStyle(
                color: TextColor,
                fontWeight: FontWeight.w600,
                fontFamily: TextFont,
                fontStyle: FontStyle.normal,
                fontSize: TextSize??0,
              ),
            ),
          ):Directionality(
            textDirection: Direction!,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Title,
                  style: TextStyle(
                    fontFamily: getTranslated(context, "Ithra"),
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.normal,
                    color: TextColor!,                    fontSize: TextSize??15,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(width: IconSpace),

                (Icon!.substring(Icon!.length-3,Icon!.length)=='png')?
                Image.asset(Icon!,width: IconWidth,height: IconHeight,color: IconColor,):SvgPicture.asset(
                    Icon!,
                    color: IconColor,
                    width: IconWidth,
                    height: IconHeight
                ),

              ],
            ),
          )),
    );
  }
}