
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/custom_back_button.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';




class YouTubeVideoRow extends StatefulWidget {
  final String  link;
  final String desc;

  const YouTubeVideoRow({
     Key? key,
      required this.desc,
    required this.link
  }) : super(key: key);

  @override
  _YouTubeVideoRowState createState() => _YouTubeVideoRowState();
}

class _YouTubeVideoRowState extends State<YouTubeVideoRow> {
  late YoutubePlayerController _controller;
 

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
    initialVideoId: widget.link.replaceAll("https://www.youtube.com/watch?v=", "").trim()
          .replaceAll("https://www.youtube.com/shorts/", "").trim(),
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
    return 
    YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
         // aspectRatio:16/3,
         
          showVideoProgressIndicator: true,

        ),

        builder: (context, player) {
          return Scaffold(
            body: Column(children: [
              Container(
                  width: size.width,
                  child: SafeArea(
                      child: Padding( padding: EdgeInsets.only(
                          left: AppPadding.p32.w,
                           right: AppPadding.p32.w,
                            top: 0.0,
                             bottom: AppPadding.p21_3.h),
                        child: Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomBackButton(),
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
                  style: TextStyle(fontFamily:
                   getTranslated(context, "Montserratsemibold"),
                  fontSize: AppFontsSizeManager.s16.sp,
                      color:AppColors.blackColor),
                ),
              ):SizedBox(),

              ],),

          );

        }
    );
  }
}