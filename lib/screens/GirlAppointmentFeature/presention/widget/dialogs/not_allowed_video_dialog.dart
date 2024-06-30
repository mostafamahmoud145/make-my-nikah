import 'package:flutter/material.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';

notAllowedVideoDialog(context) {
  return showDialog(
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      elevation: 5.0,
      contentPadding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              Center(
                child: Text(
                  getTranslated(context, "attention"),
                  style: TextStyle(
                    fontFamily: getTranslated(context, "fontFamily"),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: AppColors.reddark2,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text.rich(
                TextSpan(
                  text: getTranslated(context, "itIs"),
                  style: TextStyle(
                      fontFamily: getTranslated(context, "fontFamily"),
                      color: AppColors.grey3,
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal),
                  children: <TextSpan>[
                    TextSpan(
                      text: getTranslated(context, "notAllowedVideo"),
                      style: TextStyle(
                        fontFamily: getTranslated(context, "fontFamily"),
                        decorationThickness: 1,
                        color: AppColors.reddark,
                        fontSize: 12.0,
                      ),
                    ),
                    TextSpan(
                      text: " ",
                      style: TextStyle(
                        fontFamily: getTranslated(context, "fontFamily"),
                        decorationThickness: 1,
                        color: AppColors.reddark,
                        fontSize: 12.0,
                      ),
                    ),
                    TextSpan(
                      text: getTranslated(context, "typeText"),
                      style: TextStyle(
                        fontFamily: getTranslated(context, "fontFamily"),
                        decorationThickness: 1,
                        color: AppColors.grey3,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                softWrap: true,
                maxLines: 10,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15.0,
              ),
              Center(
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 35,
                    width: 50,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.lightPink,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        getTranslated(context, "Ok"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            color: AppColors.reddark2,
                            fontSize: 11.0,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
    barrierDismissible: false,
    context: context,
  );
}
