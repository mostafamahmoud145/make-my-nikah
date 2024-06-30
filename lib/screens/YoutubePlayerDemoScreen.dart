
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../config/colorsFile.dart';
import '../localization/localization_methods.dart';

class YoutubePlayerDemoScreen extends StatefulWidget {
   final String link;
   final String desc;
   const YoutubePlayerDemoScreen({Key? key, required this.link, required this.desc}) : super(key: key);

   @override
  _YoutubePlayerDemoScreenState createState() => _YoutubePlayerDemoScreenState();

}

class _YoutubePlayerDemoScreenState extends State<YoutubePlayerDemoScreen> {
   late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId:widget.link,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,

        topActions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.fit_screen,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () async {
              await launch(widget.link);
            },
          ),
          const SizedBox(width: 8.0),
          (widget.link!=null&&widget.link!="")?Expanded(
            child: Text( _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ):SizedBox(),
        ],
      ),
      builder: (context, player) =>
          Scaffold(
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
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ],
                        ),
                      ))),
              Center(
                  child: Container( color: AppColors.lightGrey, height: 2, width: size.width * .9)
              ),
               Expanded(child: player),
              SizedBox(height: 5,),
              widget.desc!=null?Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.desc,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),fontSize: 12.0,
                      color:Colors.black.withOpacity(0.5)),
                ),
              ):SizedBox(),

              ],),

          ),
    );
  }

   @override
   void dispose() {
     _controller.dispose();
     SystemChrome.setPreferredOrientations(DeviceOrientation.values);
     super.dispose();
   }
}