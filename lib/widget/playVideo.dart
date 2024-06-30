// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:video_player/video_player.dart';

class PlayVideoWidget extends StatefulWidget {
  final String url;
  final double? height;
  final double? width;
  const PlayVideoWidget({Key? key, required this.url, this.height, this.width})
      : super(key: key);

  @override
  State<PlayVideoWidget> createState() => _PlayVideoWidgetState();
}

class _PlayVideoWidgetState extends State<PlayVideoWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(widget.url);

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? AppSize.h245_3,
      width: widget.width ?? 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: widget.height ?? AppSize.h245_3,
            width: widget.width ?? 220,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppRadius.r21_3.r),
                        ),
                        child: VideoPlayer(_controller)),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Center(
              child: new IconButton(
                  icon: new Icon(
                    _controller.value.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle,
                    color: Colors.white.withOpacity(.5),
                    size: 50,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                  color: Theme.of(context).primaryColor)),
          /*InkWell(onTap: (){
           setState(() {
             if (_controller.value.isPlaying) {
               _controller.pause();
             } else {
               _controller.play();
             }
           });
         },
           child: Container(
             width: 30,
             height: 30,
             child: Positioned(
               child:  Icon(
                 _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
               ),
             ),
           ),
         )*/
        ],
      ),
    );
  }
}

class PlayLocalVideoWidget extends StatefulWidget {
  final String path;
  bool setsize;

  PlayLocalVideoWidget({Key? key, required this.path, this.setsize = true})
      : super(key: key);

  @override
  State<PlayLocalVideoWidget> createState() => _PlayLocalVideoWidgetState();
}

class _PlayLocalVideoWidgetState extends State<PlayLocalVideoWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(File((widget.path)));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.setsize ? AppSize.h245_3 : null,
      width: widget.setsize ? 220 : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: widget.setsize ? AppSize.h245_3 : null,
            width: widget.setsize ? 220 : null,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: VideoPlayer(_controller),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Center(
              child: new IconButton(
                  icon: new Icon(
                    _controller.value.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle,
                    color: Colors.white.withOpacity(.5),
                    size: 50,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                  color: Theme.of(context).primaryColor)),
        ],
      ),
    );
  }
}
