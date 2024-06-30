import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/widget/playVideo.dart';

import 'package:video_player/video_player.dart';

class FirebaseVideoPlayerWidget extends StatefulWidget {
  String? link;
  final bool isSecondary;
  FirebaseVideoPlayerWidget(this.link, this.isSecondary);
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<FirebaseVideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;
  // late ChewieController _chewieController;
  double videoDuration = 0;
  double currentDuration = 0;

  @override
  void initState() {
    super.initState();
    print("Vid Link from widget : ${widget.link}");
    videoPlayerController = VideoPlayerController.network(
      widget.link!,
    );
    videoPlayerController.initialize().then((_) {
      setState(() {
        videoDuration =
            videoPlayerController.value.duration.inMilliseconds.toDouble();
      });
    });

    videoPlayerController.addListener(() {
      setState(() {
        currentDuration =
            videoPlayerController.value.position.inMilliseconds.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return videoPlayerController.value.isInitialized
        ? Container(
            height: AppSize.h594_6.h,
            width: AppSize.h402.w,
            padding: widget.isSecondary
                ? EdgeInsets.symmetric(vertical: 69.h)
                : null,
            child:
            // PlayVideoWidget(
            //   url: widget.link!,
            //   height: AppSize.h594_6.h,
            //   width: AppSize.h402.w,
            // )
             Stack(
              // alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40.r),
                  child: VideoPlayer(videoPlayerController),
                ),
                videoPlayerController.value.isPlaying
                    ? const SizedBox()
                    : Center(
                    child: new IconButton(
                        icon: new Icon(
                          videoPlayerController.value.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle,
                          color: Colors.white.withOpacity(.5),
                          size: 50,
                        ),
                        onPressed: () {
                          setState(() {
                            if (videoPlayerController.value.isPlaying) {
                              videoPlayerController.pause();
                            } else {
                              videoPlayerController.play();
                            }
                          });
                        },
                        color: Theme.of(context).primaryColor)),
              ],
            )
            )
        : Container(
            height: 200,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }
}
