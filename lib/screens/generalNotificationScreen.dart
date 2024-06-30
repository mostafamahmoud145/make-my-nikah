import 'dart:ui';

import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/localization/localization_methods.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/widget/app_bar_widget.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:linkwell/linkwell.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../config/colorsFile.dart';

class GeneralNotificationScreen extends StatefulWidget {
  final String title;
  final String body;
  final String? image;
  final String? link;

  const GeneralNotificationScreen(
      {Key? key,
      required this.title,
      required this.body,
      this.image,
      this.link})
      : super(key: key);

  @override
  _GeneralNotificationScreenState createState() =>
      _GeneralNotificationScreenState();
}

class _GeneralNotificationScreenState extends State<GeneralNotificationScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  final _key = UniqueKey();

  @override
  void initState() {
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
                width: size.width,
                child: Padding(
                                padding:  EdgeInsets.only(
                     bottom: AppPadding.p21_3.h),
                                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppBarWidget2(text: "notification"),
                  SizedBox(),
                ],
                                ),
                              )),
            Center(
                child: Container(
                    color: AppColors.white3, height: 1, width: size.width)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                (widget.image != null &&
                        widget.image != "noImage" &&
                        widget.image!.isEmpty == false)
                    ? Center(
                        child: Container(
                          height: size.height * .25,
                          width: size.width * .9,
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey[200],width: 1),
                            shape: BoxShape.rectangle,
                            // color: Colors.white,
                          ),
                          child: widget.image!.isEmpty
                              ? Center(
                                  child: Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                  size: 50.0,
                                ))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/icons/icon/load.gif',
                                    placeholderScale: 0.5,
                                    imageErrorBuilder:
                                        (context, error, stackTrace) => Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                      size: 50.0,
                                    ),
                                    image: widget.image!,
                                    fit: BoxFit.cover,
                                    fadeInDuration: Duration(milliseconds: 250),
                                    fadeInCurve: Curves.easeInOut,
                                    fadeOutDuration: Duration(milliseconds: 150),
                                    fadeOutCurve: Curves.easeInOut,
                                  ),
                                ),
                        ),
                      )
                    : SizedBox(),
                (widget.image != null &&
                        widget.image != "noImage" &&
                        widget.image!.isEmpty == false)
                    ? SizedBox(
                        height: 20,
                      )
                    : SizedBox(),
                Center(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 3,
                    style: TextStyle(
                      fontFamily: getTranslated(context, "fontFamily"),
                      color: AppColors.grey2,
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: LinkWell(
                    widget.body,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 5,
                    style: TextStyle(
                      fontFamily: getTranslated(context, "fontFamily"),
                      color: AppColors.grey2,
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0.3,
                    ),
                    linkStyle: TextStyle(
                      fontFamily: getTranslated(context, "fontFamily"),
                      color: Colors.blue,
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
