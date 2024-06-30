import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/models/courseVideo.dart';
import 'package:grocery_store/widget/TextButton.dart';
import 'package:grocery_store/widget/dreamDialogsWidget.dart';
import 'package:grocery_store/widget/nikah_dialog.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:video_player/video_player.dart';

import '../config/colorsFile.dart';
import '../localization/localization_methods.dart';
import '../models/courses.dart';

class ChewieDemo extends StatefulWidget {
  final CourseVideo video;

  const ChewieDemo({ Key? key,required this.video, }) : super(key: key);



  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;
  int? bufferDelay;
  bool load=true;
  int selectedIndex=-1;
  late Size size;
  List<CourseVideo> videos=[];
  late CourseVideo selectedVideo;
  int currPlayIndex = -1;
  late int _timer;
  late Timer timer;
  @override
  void initState() {
    super.initState();
    selectedVideo=widget.video;
    startTimer();
    updateViewCount();
    initializePlayer();
  }
  getCourseVideo() async {
    try{
      print("gggggg0000");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('CourseVideo')
          .where( 'courseId',  isEqualTo: widget.video.courseId,)
          .where( 'active',  isEqualTo: true,)
          .get();
      var videoList = List<CourseVideo>.from(
        querySnapshot.docs.map( (snapshot) => CourseVideo.fromMap(snapshot.data() as Map), ), );
      setState(() {
        videos=videoList;
        load=false;
      });
      print("gggggg");
      print(videos.length);
    }catch(e){print("yarabsatric");
    print(e.toString());}
  }
  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController?.dispose();
    timer.cancel();
    super.dispose();
  }

  Future<void> startTimer() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("Courses")
        .doc(widget.video.courseId)
        .get();
    Courses course = Courses.fromMap(documentSnapshot.data() as Map);
    var paid=course.paidUsers;
    _timer = 60;

    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {
        _timer--;
      });
      if (_timer == 45&&course.price!="0") {
        timer.cancel();
        if(FirebaseAuth.instance.currentUser==null||paid!.contains(FirebaseAuth.instance.currentUser!.uid)==false){
          await _videoPlayerController1.pause();
          payDialog();
        }
      }
    });
  }
  payDialog() {
    return showDialog(
      builder: (context) => MakeMyNikahDialogsWidget(
        padBottom: 0,
        padRight: 0,
        padLeft: 0,
        padTop: 0,
        raduis: AppRadius.r21_3.r,
        dialogContent: Container(
              width: AppSize.w508.w,
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.p32.w,
                vertical: AppPadding.p32.h
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                   Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    AssetsManager.black_cancel_iconPath,
                    color: AppColors.lightGrey3,
                    width: AppSize.w42_6.r,
                    height: AppSize.h42_6.r,
                  ),
                )
              ],
            ),
                  Center(
                    child: Text(
                      getTranslated(context, "attention"),
                      style: TextStyle(
                        fontFamily: getTranslated(context, "Montserratsemibold"),
                        fontSize: AppFontsSizeManager.s29_3.sp,
                        color: AppColors.red3,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppSize.h10_6.h,
                  ),
                  Text(
                    getTranslated(context, "coursePay"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: AppSize.h1_8.h,
                      fontFamily: getTranslated(context, "Montserratmedium"),
                      fontSize: AppFontsSizeManager.s21_3.sp,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(
                    height: AppSize.h10_6.h,
                  ),
                  Text(
                    getTranslated(context, "coursePay2"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: getTranslated(context, "Montserratmedium"),
                      fontSize: AppFontsSizeManager.s21_3.sp,
                      color: AppColors.red3,
                    ),
                  ),
                  SizedBox(
                    height: AppSize.h32.h,
                  ),
                  Container(
                    width: size.width,
                    height: AppSize.h56.h,
                    child:Center(
                      child: TextButton1(
                           onPress: () async {
                             Navigator.pop(context);
                              Navigator.pop(context);
                           },
                           Title: getTranslated(context, "Ok"),
                           ButtonRadius: AppRadius.r10_6.r,
                           TextSize: AppFontsSizeManager.s18_6.sp,
                           ButtonBackground: AppColors.white,
                           BorderColor: AppColors.red2,
                           TextFont: getTranslated(context, "Montserratsemibold"),
                           TextColor: AppColors.red2,
                          ),
                    ),
                    
                    /*  Row(
                      children: [
                         Expanded(
                           child: TextButton1(
                           onPress: () async {},
                           Title: getTranslated(context, "pay"),
                           ButtonRadius: AppRadius.r10_6.r,
                           TextSize: AppFontsSizeManager.s18_6.sp,
                           ButtonBackground: AppColors.red2,
                           TextFont:
                               getTranslated(context, "Montserratsemibold"),
                           TextColor: AppColors.white,
                          ),
                         ),
                         SizedBox(width: AppSize.w21_3.w,),
                        Expanded(
                           child: TextButton1(
                           onPress: () async {
                             Navigator.pop(context);
                              Navigator.pop(context);
                           },
                           Title: getTranslated(context, "cancel"),
                           ButtonRadius: AppRadius.r10_6.r,
                           TextSize: AppFontsSizeManager.s18_6.sp,
                           ButtonBackground: AppColors.white,
                           BorderColor: AppColors.red2,
                           TextFont: getTranslated(context, "Montserratsemibold"),
                           TextColor: AppColors.red2,
                          ),
                        ),
                      ],
                    ), */
                  ),
                ],
              )
            
          
      )),
      barrierDismissible: false,
      context: context,
    );
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 =  VideoPlayerController.network(currPlayIndex==-1? widget.video.link:videos[currPlayIndex].link);
    _videoPlayerController2 = VideoPlayerController.network(currPlayIndex==-1? widget.video.link:videos[currPlayIndex].link);
    await Future.wait([
      _videoPlayerController1.initialize(),
      _videoPlayerController2.initialize()
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {


    var  subtitles = [
      Subtitle(
        index: 0,
        start: Duration.zero,
        end: const Duration(seconds: 10),
        text:  TextSpan(
          children: [
            TextSpan(
              text: selectedVideo.name,
              style: TextStyle(color: Colors.red, fontSize: 22),
            ),
           /* TextSpan(
              text: ' from ',
              style: TextStyle(color: Colors.green, fontSize: 20),
            ),
            TextSpan(
              text: 'subtitles',
              style: TextStyle(color: Colors.blue, fontSize: 18),
            )*/
          ],
        ),
      ),
      Subtitle(
        index: 0,
        start: const Duration(seconds: 10),
        end: const Duration(seconds: 20),
        text: 'Whats up? :)',
        // text: const TextSpan(
        //   text: 'Whats up? :)',
        //   style: TextStyle(color: Colors.amber, fontSize: 22, fontStyle: FontStyle.italic),
        // ),
      ),
    ];

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      progressIndicatorDelay:
      bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,

      additionalOptions: (context) {
        return <OptionItem>[
          OptionItem(
            onTap: toggleVideo,
            iconData: Icons.live_tv_sharp,
            title: 'Toggle Video Src',
          ),
        ];
      },
      /*subtitle: Subtitles(subtitles),
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
          text: subtitle,
        )
            : Text(
          subtitle.toString(),
          style: const TextStyle(color: Colors.black),
        ),
      ),*/

      hideControlsTimer: const Duration(seconds: 1),

      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }



  Future<void> toggleVideo() async {
    await _videoPlayerController1.pause();
    currPlayIndex += 1;
    if (currPlayIndex >= videos.length) {//srcs.length
      currPlayIndex = 0;
    }
    await initializePlayer();
  }
  updateViewCount() async {
    await  FirebaseFirestore.instance.collection("CourseVideo").doc(selectedVideo.videoId).update(
      {
        "views":FieldValue.increment(1),
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery .of(context).size;
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(backgroundColor:  Colors.black12,
        title: Text(" "),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: _chewieController != null &&
                  _chewieController!
                      .videoPlayerController.value.isInitialized
                  ? Chewie(
                controller: _chewieController!,
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 10,top: 20),
            child:   Text(
              selectedVideo.name,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 4,
              style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                  color: AppColors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: 20,),
          /*Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getTranslated(context, "playNext"),
                  textAlign: TextAlign.start,
                  style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      color: AppColors.reddark,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  getTranslated(context, "all"),
                  textAlign: TextAlign.start,
                  style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      color: AppColors.grey,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),
          load?Center(child: CircularProgressIndicator()):SizedBox(height: 20,),
          videos.length>0?Container(height:size.height*.5,child: videoListBuilder()):SizedBox(),*/
        ],
      ),
    );
  }
  Widget videoListBuilder(){
    return ListView.builder(
        itemCount: videos.length,
        itemBuilder: (BuildContext context, int index) {
          return  Padding(
            padding: const EdgeInsets.only(left: 20,right: 10,top: 20,bottom: 20),
            child: InkWell(onTap: () async {
              print("selectedIndex"+selectedIndex.toString());
            setState(() {
                currPlayIndex=index;
                selectedVideo=videos[index];
              });
            print("fffff");
            print(currPlayIndex);
              await _videoPlayerController1.pause();
              await initializePlayer();
              updateViewCount();
            },
              child: Row(mainAxisSize: MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 5,),
                  Expanded(
                    child: Column( mainAxisSize: MainAxisSize.max,crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            videos[index].name,
                            textAlign: TextAlign.start,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                fontFamily: getTranslated(context, "fontFamily"),
                                color: (selectedIndex!=null&&selectedIndex==index)?AppColors.reddark:AppColors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                          Icon(Icons.remove_red_eye_outlined,
                            color: Color.fromRGBO(205, 61, 99, 1), size: 15,),
                          SizedBox(width: 3,),
                          Text(
                            videos[index].views.toString() + " " +
                                getTranslated(context, "view"),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: getTranslated(context, "fontFamily"),
                                color: Color.fromRGBO(199 ,198 ,198,1),
                                fontSize: 9.0,
                                fontWeight: FontWeight.w600
                            ),
                          ),

                        ],)
                      ],),
                  ),

                ],
              ),
            ),
          );
        });
  }
}

class DelaySlider extends StatefulWidget {
  const DelaySlider({Key? key, required this.delay, required this.onSave})
      : super(key: key);

  final int? delay;
  final void Function(int?) onSave;
  @override
  State<DelaySlider> createState() => _DelaySliderState();
}

class _DelaySliderState extends State<DelaySlider> {
  int? delay;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    delay = widget.delay;
  }

  @override
  Widget build(BuildContext context) {
    const int max = 1000;
    return ListTile(
      title: Text(
        "Progress indicator delay ${delay != null ? "${delay.toString()} MS" : ""}",
      ),
      subtitle: Slider(
        value: delay != null ? (delay! / max) : 0,
        onChanged: (value) async {
          delay = (value * max).toInt();
          setState(() {
            saved = false;
          });
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.save),
        onPressed: saved
            ? null
            : () {
          widget.onSave(delay);
          setState(() {
            saved = true;
          });
        },
      ),
    );
  }
}

