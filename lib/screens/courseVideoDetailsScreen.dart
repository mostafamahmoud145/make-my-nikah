// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:grocery_store/models/courseVideo.dart';
// import 'package:video_player/video_player.dart';

// import '../config/colorsFile.dart';
// import '../localization/localization_methods.dart';
// import '../widget/playVideoWidget.dart';



// class CourseVideoDetailScreen extends StatefulWidget {
//   final CourseVideo video;


//   const CourseVideoDetailScreen({Key? key, required this.video, }) : super(key: key);
//   @override
//   _CourseVideoDetailScreenState createState() => _CourseVideoDetailScreenState();
// }

// class _CourseVideoDetailScreenState extends State<CourseVideoDetailScreen> {
//   VideoPlayerController? _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//   bool load=true;
//    int selectedIndex=-1;
//    late Size size;
//   List<CourseVideo> videos=[];
//   late CourseVideo selectedVideo;
//   @override
//   void initState() {
//     super.initState();
//     selectedVideo=widget.video;
//     getCourseVideo();
//     _controller = VideoPlayerController.network(widget.video.link);
//     _initializeVideoPlayerFuture = _controller!.initialize();
//     _controller!.setLooping(true);

//   }
//   getCourseVideo() async {
//     try{
//     print("gggggg0000");
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('CourseVideo')
//         .where( 'courseId',  isEqualTo: widget.video.courseId,)
//         .where( 'active',  isEqualTo: true,)
//         .get();
//     var videoList = List<CourseVideo>.from(
//       querySnapshot.docs.map( (snapshot) => CourseVideo.fromMap(snapshot.data() as Map), ), );
//     setState(() {
//       videos=videoList;
//        load=false;
//      });
// print("gggggg");
// print(videos.length);
//     }catch(e){print("yarabsatric");
//     print(e.toString());}
//   }




//   @override
//   void dispose() {
//      super.dispose();
//      _controller!.dispose();
//   }
//   updateViewCount() async {
//     await  FirebaseFirestore.instance.collection("CourseVideo").doc(widget.video.videoId).update(
//       {
//         "views":FieldValue.increment(1),
//       },
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//      size = MediaQuery .of(context).size;
//     return Scaffold(

//         body: ListView(
//           children: [
//             Container(
//                 width: size.width,
//                 child: SafeArea(
//                     child: Padding( padding: const EdgeInsets.only(
//                         left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
//                       child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             height: 35,
//                             width: 35,

//                             child: Center(
//                               child: IconButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 icon: Image.asset(
//                                   getTranslated(context, "back"),
//                                   width: 20,
//                                   height: 15,
//                                 ),
//                               ),
//                             ),
//                           ),


//                         ],
//                       ),
//                     ))),
//             Center( child: Container(  color: AppColors.white3, height: 1, width: size.width )),
//             SizedBox(height: 10,),
//             Stack(alignment: Alignment.center,children: [
//               Center(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20.0),
//                   child: Container(
//                     height: 150,
//                     width: MediaQuery.of(context).size.width*.85,
//                     child: FutureBuilder(
//                       future: _initializeVideoPlayerFuture,
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.done) {
//                           // If the VideoPlayerController has finished initialization, use
//                           // the data it provides to limit the aspect ratio of the video.
//                           return AspectRatio(
//                             aspectRatio: _controller!.value.aspectRatio,
//                             // Use the VideoPlayer widget to display the video.
//                             child: VideoPlayer(_controller!),
//                           );
//                         } else {
//                           // If the VideoPlayerController is still initializing, show a
//                           // loading spinner.
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               Center(
//                   child: new IconButton(
//                       icon: new Icon(_controller!.value.isPlaying?Icons.pause_circle_filled:Icons.play_circle_fill,
//                         color: Colors.black.withOpacity(0.5),size: 25,),
//                       onPressed: () { setState(() {
//                         if (_controller!.value.isPlaying) {
//                           _controller!.pause();
//                         } else {
//                           _controller!.play();
//                         }
//                       });},
//                       color:Theme.of(context).primaryColor
//                   )
//               ),
//               /*InkWell(onTap: (){
//                setState(() {
//                  if (_controller!.value.isPlaying) {
//                    _controller!.pause();
//                  } else {
//                    _controller!.play();
//                  }
//                });
//              },
//                child: Container(
//                  width: 30,
//                  height: 30,
//                  child: Positioned(
//                    child:  Icon(
//                      _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                    ),
//                  ),
//                ),
//              )*/


//       ]),
//             Padding(
//               padding: const EdgeInsets.only(left: 20,right: 10,top: 20),
//               child:   Text(
//                 selectedVideo.name,
//                 textAlign: TextAlign.start,
//                 overflow: TextOverflow.ellipsis,
//                 softWrap: true,
//                 maxLines: 4,
//                 style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
//                     color: AppColors.black,
//                     fontSize: 14.0,
//                     fontWeight: FontWeight.bold
//                 ),
//               ),
//             ),
//             SizedBox(height: 20,),
//             Padding(
//               padding: const EdgeInsets.only(left: 20,right: 20),
//               child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     getTranslated(context, "playNext"),
//                     textAlign: TextAlign.start,
//                     style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
//                         color: AppColors.reddark,
//                         fontSize: 15.0,
//                         fontWeight: FontWeight.w500
//                     ),
//                   ),
//                   Text(
//                     getTranslated(context, "all"),
//                     textAlign: TextAlign.start,
//                     style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
//                         color: AppColors.grey,
//                         fontSize: 11.0,
//                         fontWeight: FontWeight.w500
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             load?Center(child: CircularProgressIndicator()):SizedBox(height: 20,),
//             videos.length>0?Container(height:size.height*.5,child: videoListBuilder()):SizedBox(),

//           ],
//         ),

//     );
//   }
//   Future<void> _initializePlay(String videoPath) async {
//     _controller = VideoPlayerController.network(videoPath);
//     _controller!.addListener(() {

//     });
//     _initializeVideoPlayerFuture = _controller!.initialize().then((_) {
//       //_controller!.seekTo(newCurrentPosition);
//       _controller!.play();
//     });
//   }
//   Widget videoListBuilder(){
//     return ListView.builder(
//         itemCount: videos.length,
//         itemBuilder: (BuildContext context, int index) {
//           return  Padding(
//             padding: const EdgeInsets.only(left: 20,right: 10,top: 20,bottom: 20),
//             child: InkWell(onTap: (){
//               print("selectedIndex"+selectedIndex.toString());
//               setState(() {
//                 selectedIndex=index;
//                 selectedVideo=videos[index];
//               });
//               _initializePlay(selectedVideo.link);
//             },
//               child: Row(mainAxisSize: MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       SizedBox(width: 5,),
//                       Expanded(
//                         child: Column( mainAxisSize: MainAxisSize.max,crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               child: Text(
//                                 videos[index].name,
//                                 textAlign: TextAlign.start,
//                                 softWrap: true,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 3,
//                                 style: TextStyle(
//                                     fontFamily: getTranslated(context, "fontFamily"),
//                                     color: (selectedIndex!=null&&selectedIndex==index)?AppColors.reddark:AppColors.black,
//                                     fontSize: 13.0,
//                                     fontWeight: FontWeight.w500
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 5,),
//                             Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//                               Icon(Icons.remove_red_eye_outlined,
//                                 color: Color.fromRGBO(205, 61, 99, 1), size: 15,),
//                               SizedBox(width: 3,),
//                               Text(
//                                 videos[index].views.toString() + " " +
//                                     getTranslated(context, "view"),
//                                 textAlign: TextAlign.start,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     fontFamily: getTranslated(context, "fontFamily"),
//                                     color: Color.fromRGBO(199 ,198 ,198,1),
//                                     fontSize: 9.0,
//                                     fontWeight: FontWeight.w600
//                                 ),
//                               ),

//                             ],)
//                           ],),
//                       ),

//                     ],
//                   ),
//             ),
//           );
//         });
//   }

// }
