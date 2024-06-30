
import 'package:flutter/material.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:video_player/video_player.dart';


class PlayVideoWidget extends StatefulWidget {
  final String url;

  const PlayVideoWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<PlayVideoWidget> createState() => _PlayVideoWidgetState();
}

class _PlayVideoWidgetState extends State<PlayVideoWidget> {
   VideoPlayerController? _controller;
   late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = _controller!.initialize();
    _controller!.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
   @override
   Widget build(BuildContext context) {
     return Container(height: 170,
       width: MediaQuery.of(context).size.width*.75,
       child: Stack(alignment: Alignment.center,children: [
         ClipRRect(
           borderRadius: BorderRadius.circular(20.0),
           child: Container(
             height: 170,
             width: MediaQuery.of(context).size.width*.75,
             child: FutureBuilder(
               future: _initializeVideoPlayerFuture,
               builder: (context, snapshot) {
                 if (snapshot.connectionState == ConnectionState.done) {
                   // If the VideoPlayerController has finished initialization, use
                   // the data it provides to limit the aspect ratio of the video.
                   return AspectRatio(
                     aspectRatio: _controller!.value.aspectRatio,
                     // Use the VideoPlayer widget to display the video.
                     child: VideoPlayer(_controller!),
                   );
                 } else {
                   // If the VideoPlayerController is still initializing, show a
                   // loading spinner.
                   return const Center(
                     child: CircularProgressIndicator(),
                   );
                 }
               },
             ),
           ),
         ),
         Center(
           child: new IconButton(
               icon: new Icon(_controller!.value.isPlaying?Icons.pause_circle_filled:Icons.play_circle_fill,
                 color: AppColors.white3,size: 30,),
               onPressed: () { setState(() {
                 if (_controller!.value.isPlaying) {
                   _controller!.pause();
                 } else {
                   _controller!.play();
                 }
               });},
               color:Theme.of(context).primaryColor
           )
         ),
         /*InkWell(onTap: (){
           setState(() {
             if (_controller!.value.isPlaying) {
               _controller!.pause();
             } else {
               _controller!.play();
             }
           });
         },
           child: Container(
             width: 30,
             height: 30,
             child: Positioned(
               child:  Icon(
                 _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
               ),
             ),
           ),
         )*/


       ],
       ),
     );
   }

}