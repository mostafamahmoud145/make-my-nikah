
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../config/colorsFile.dart';
import '../localization/localization_methods.dart';
import '../widget/playVideoWidget.dart';

class VideoPlayScreen extends StatefulWidget {
  final String link;
  final String name;
  const VideoPlayScreen({Key? key, required this.link, required this.name}) : super(key: key);

  @override
  _VideoPlayScreenState createState() => _VideoPlayScreenState();

}

class _VideoPlayScreenState extends State<VideoPlayScreen> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(children: [
        Container(
            width: size.width,
            child: SafeArea(
                child: Padding( padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 0.0, bottom: 6.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Image.asset(
                          getTranslated(context, "back"),
                          width: 20,
                          height: 15,
                        ),
                      ),],
                  ),
                ))),
        Center(
            child: Container( color: AppColors.lightGrey, height: 2, width: size.width * .9)
        ),
        Expanded(child: PlayVideoWidget(url:'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')),//(url: widget.link)),
        SizedBox(height: 5,),
        widget.name!=null?Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            widget.name,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),fontSize: 12.0,
                color:Colors.black.withOpacity(0.5)),
          ),
        ):SizedBox(),

      ],),

    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}