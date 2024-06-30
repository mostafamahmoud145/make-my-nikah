/*
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';
import '../models/Influencer.dart';
import '../models/infCourseVideo.dart';


class InfVideoDetailsScreen extends StatefulWidget {
  final InfCourseVideo video;
  final Influencer influencer;


  const InfVideoDetailsScreen({Key? key, required this.video, required this.influencer}) : super(key: key);
  @override
  _InfVideoDetailsScreenState createState() => _InfVideoDetailsScreenState();
}

class _InfVideoDetailsScreenState extends State<InfVideoDetailsScreen> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  bool load=true;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
   int selectedIndex=-1;
late Size size;
  final List<String> _ids = [];
  List<InfCourseVideo> videos=[];
  @override
  void initState() {
    super.initState();
    getCourseVideo();
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.link,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  getCourseVideo() async {
    try{
    print("gggggg0000");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Paths.infCourseVideosPath)
        .where( 'courseId',  isEqualTo: widget.video.courseId,)
        .where( 'active',  isEqualTo: true,)
        .get();
    var videoList = List<InfCourseVideo>.from(
      querySnapshot.docs.map( (snapshot) => InfCourseVideo.fromMap(snapshot.data() as Map), ), );
    for(int x=0;x<videoList.length;x++)
     { _ids.add(videoList[x].link);}
    setState(() {
      videos=videoList;
       load=false;
     });
print("gggggg");
print(videos.length);
    }catch(e){print("yarabsatric");
    print(e.toString());}
  }
  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     size = MediaQuery .of(context).size;
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
       // SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {
              log('Settings Tapped!');
            },
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          _controller
              .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
          _showSnackBar('Next Video Started!');
        },
      ),
      builder: (context, player) => Scaffold(

        body: ListView(
          children: [
            Container(
                width: size.width,
                child: SafeArea(
                    child: Padding( padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 35,
                            width: 35,

                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Image.asset(
                                  getTranslated(context, "back"),
                                  width: 20,
                                  height: 15,
                                ),
                              ),
                            ),
                          ),
                          Container( width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              //border: Border.all(color: AppColors.black2)
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35.0),
                              child: widget.influencer.image == "" ? Image.asset("assets/icons/icon/im2.jpeg", width: 35,
                                height: 35,) : Image.network(widget.influencer.image),
                            ),
                          )

                        ],
                      ),
                    ))),
            Center( child: Container(  color: AppColors.white3, height: 1, width: size.width )),
            SizedBox(height: 10,),
             Stack(children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: player,
              ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  left: 0.0,
                  top: 0.0,
                  child:  IconButton(
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_circle_outline,color: Colors.white,
                    ),
                    onPressed: _isPlayerReady
                        ? () {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                      setState(() {});
                    }
                        : null,
                  ),
                ),
                Positioned(
                 bottom: 0.0,
                 left: 0.0,
                 top: 0.0,
                 child:  IconButton(
                   icon: const Icon(Icons.skip_previous,color: Colors.white,),
                   onPressed: _isPlayerReady
                       ? () => _controller.load(_ids[
                   (_ids.indexOf(_controller.metadata.videoId) -
                       1) %
                       _ids.length])
                       : null,
                 ),
               ),
                Positioned(
                 bottom: 0.0,
                 right: 0.0,
                 top: 0.0,
                 child:  IconButton(
                   icon: const Icon(Icons.skip_next,color: Colors.white),
                   onPressed: _isPlayerReady
                       ? () => _controller.load(_ids[
                   (_ids.indexOf(_controller.metadata.videoId) +
                       1) %
                       _ids.length])
                       : null,
                 ),
               ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: IconButton(
                    icon: Icon(_muted ? Icons.volume_off : Icons.volume_up,color: Colors.white,),
                    onPressed: _isPlayerReady
                        ? () {
                      _muted
                          ? _controller.unMute()
                          : _controller.mute();
                      setState(() {
                        _muted = !_muted;
                      });
                    }
                        : null,
                  ),
                ),
               Positioned(
                 bottom: 0.0,
                 left: 0.0,
                 child:FullScreenButton(
                   controller: _controller,
                   color: Colors.white,
                 ),
               ),
              ],),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 10,top: 20),
              child:   Text(
                _videoMetaData.title,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 4,
                style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                    color: AppColors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
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
            videos.length>0?Container(height:size.height*.5,child: videoListBuilder()):SizedBox(),

          ],
        ),
      ),
    );
  }
  Widget videoListBuilder(){
    return ListView.builder(
        itemCount: videos.length,
        itemBuilder: (BuildContext context, int index) {
          return  Padding(
            padding: const EdgeInsets.only(left: 20,right: 10,top: 20,bottom: 20),
            child: InkWell(onTap: (){
              selectedIndex=index;
              _controller.load(videos[index].link);
              FocusScope.of(context).requestFocus(FocusNode());
            },
              child: Row(mainAxisSize: MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(11)),
                          child: FadeInImage.assetNetwork(
                            height: 70,
                            width:100,
                            placeholder: 'assets/icons/icon/load.gif',
                            placeholderScale: 0.5,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                Image.asset('assets/icons/icon/Mask Group 47.png', width: 100,
                                    height: 70,
                                    fit: BoxFit.fill),
                            image: "https://img.youtube.com/vi/" + videos[index].link +
                                "/0.jpg",
                            fit: BoxFit.cover,
                            fadeInDuration:
                            Duration(milliseconds: 270),
                            fadeInCurve: Curves.easeInOut,
                            fadeOutDuration:
                            Duration(milliseconds: 170),
                            fadeOutCurve: Curves.easeInOut,
                          ),
                        ),
                        (selectedIndex!=null&&selectedIndex==index)?Positioned(top:0.0,bottom:0.0,left:0.0,right:0.0,
                            child: Icon(Icons.play_circle_outline,
                              color: AppColors.white,size: 30,),):SizedBox()
                      ],),

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
                                    color: (selectedIndex!=null&&selectedIndex==index)?AppColors.reddark:AppColors.black,
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

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700]!;
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900]!;
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);

  Widget _loadCueButton(String action) {
    return Expanded(
      child: MaterialButton(
        color: Colors.blueAccent,
        onPressed: _isPlayerReady
            ? () {
          if (_idController.text.isNotEmpty) {
            var id = YoutubePlayer.convertUrlToId(
              _idController.text,
            ) ??
                '';
            if (action == 'LOAD') _controller.load(id);
            if (action == 'CUE') _controller.cue(id);
            FocusScope.of(context).requestFocus(FocusNode());
          } else {
            _showSnackBar('Source can\'t be empty!');
          }
        }
            : null,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}*/
