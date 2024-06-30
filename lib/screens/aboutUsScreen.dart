import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../widget/IconButton.dart';
import '../widget/app_bar_widget.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  final _key = UniqueKey();
  String? url = "https://makemynikah.com/", lang;
  @override
  void initState() {
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    lang = getTranslated(context, "lang");
    if (lang != "ar") url = "https://makemynikah.com/";
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AppBarWidget2(
              text: getTranslated(context, "aboutUs"),
            ),
            SizedBox(
              height: AppSize.h21_3.h,
            ),
            Center(
                child: Container(
                    color: AppColors.white3, height: 1, width: size.width)),
            Expanded(
              child: Stack(
                children: <Widget>[
                  WebView(
                    key: _key,
                    initialUrl: url,
                    javascriptMode: JavascriptMode.unrestricted,
                    gestureNavigationEnabled: true,
                    initialMediaPlaybackPolicy:
                        AutoMediaPlaybackPolicy.always_allow,
                    onPageFinished: (finish) {
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Stack(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
