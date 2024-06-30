
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/models/SupportMessage.dart';
import 'package:grocery_store/models/user.dart';
import 'package:voice_message_package/voice_message_package.dart';





class PlayRecordWidget extends  StatefulWidget {
  final String url;
 final bool owner;
  const PlayRecordWidget({Key? key, required this.url, required this.owner}) : super(key: key);
  @override
  State<PlayRecordWidget> createState() => _PlayRecordWidgetState();
}

class _PlayRecordWidgetState extends State<PlayRecordWidget> {

  int maxDuration = 100;
  int currentPos = 0;
  String currentPostLabel = "00:00";
  bool isPlaying = false;
  bool audioPlayed = false;

  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      player.onDurationChanged.listen((Duration d) { //get the duration of audio
        maxDuration = d.inMilliseconds;
      });

      player.onPositionChanged.listen((Duration  p){
        setState(() {
          currentPos = p.inMilliseconds; //get the current position of playing audio
        });


        //generating the duration label
        int shours = Duration(milliseconds:currentPos).inHours;
        int sminutes = Duration(milliseconds:currentPos).inMinutes;
        int sseconds = Duration(milliseconds:currentPos).inSeconds;

        int rhours = shours;
        int rminutes = sminutes - (shours * 60);
        int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

        currentPostLabel = "$rhours:$rminutes:$rseconds";

      });

    });
    super.initState();
  }
  @override
  void dispose(){
    player.stop();
    player.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: (widget.owner?Alignment.topLeft:Alignment.topRight),
      child: Container(  decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(widget.owner?0.0:20.0),
          bottomRight: Radius.circular(widget.owner?20.0:0.0),
        ),
        color: (widget.owner?AppColors.chat:AppColors.otherChat),
      ),
          child:VoiceMessage(
           meBgColor:(widget.owner ? AppColors.chat:AppColors.otherChat ),
            mePlayIconColor:Colors.white,
            meFgColor:Colors.white,
            contactBgColor: (widget.owner ? AppColors.red1.withOpacity(0.8):AppColors.otherChat ),
            contactPlayIconColor:  Colors.white,
            contactFgColor:  widget.owner ? AppColors.greendark2:Colors.black.withOpacity(0.5),
            audioSrc: widget.url,
            played: false, // To show played badge or not.
            me: false, // Set message side.
            onPlay: () {}, // Do something when voice played.
          ),
      ),
    );
  }
  /*Widget build2(BuildContext context) {
    String url1=" https://firebasestorage.googleapis.com/v0/b/app-jeras.appspot.com/o/audio%2F6314773e-ace0-4ae7-b792-53611a948f4d?alt=media&token=adadc91d-194d-4541-b212-34ad7bdc0f4d";
    String url2="https://firebasestorage.googleapis.com/v0/b/app-jeras.appspot.com/o/audio%2F7737e731-f121-4b73-8f3f-8994dff0cc74?alt=media&token=f78a80a9-b905-4358-9d90-4f1d0408f74e";
    String url3="https://firebasestorage.googleapis.com/v0/b/app-jeras.appspot.com/o/audio%2F79b1c151-79e5-43a2-ab1d-3d473fde208e?alt=media&token=d10a0a28-6219-4f20-9178-76b77d638c2e";

    return Scaffold(
      appBar: AppBar(
          title: Text("Play Audio in Flutter App"),
          backgroundColor: Colors.redAccent
      ),
      body:playWidget(url1),
    );
  }*/

  /*Widget playWidget(String url){
    return  Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        height: 50, //width: size.width*.40,
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.amber[100],
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset:
              Offset(0.0, 1.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Center(
          child: Row(
            children: [
              Container(
                child: Wrap(
                  spacing: 10,
                  children: [
                    IconButton(
                      onPressed: () async {
                        if(!isPlaying && !audioPlayed){
                          int result = await player.play(url);
                          if(result == 1){ //play success
                            setState(() {
                              isPlaying = true;
                              audioPlayed = true;
                            });
                          }else{
                            print("Error while playing audio.");
                          }
                        }else if(audioPlayed && !isPlaying){
                          int result = await player.resume();
                          if(result == 1){ //resume success
                            setState(() {
                              isPlaying = true;
                              audioPlayed = true;
                            });
                          }else{
                            print("Error on resume audio.");
                          }
                        }else{
                          int result = await player.pause();
                          if(result == 1){ //pause success
                            setState(() {
                              isPlaying = false;
                            });
                          }else{
                            print("Error on pause audio.");
                          }
                        }
                      },
                      icon: Icon(isPlaying?Icons.pause:Icons.play_arrow),
                    ),
                    IconButton(
                      onPressed: () async {
                        int result = await player.stop();
                        if(result == 1){ //stop success
                          setState(() {
                            isPlaying = false;
                            audioPlayed = false;
                            currentPos = 0;
                          });
                        }else{
                          print("Error on stop audio.");
                        }
                      },
                      icon: Icon(Icons.stop),
                    ),

                  ],
                ),
              ),
              Container(
                child: Text(currentPostLabel, style: TextStyle(fontSize: 10),),
              ),

              Container(
                  child: Slider(
                    value: double.parse(currentPos.toString()),
                    min: 0,
                    max: double.parse(maxDuration.toString()),
                    divisions: maxDuration,
                    label: currentPostLabel,
                    onChanged: (double value) async {
                      int seekval = value.round();
                      int result = await player.seek(Duration(milliseconds: seekval));
                      if(result == 1){ //seek successful
                        currentPos = seekval;
                      }else{
                        print("Seek unsuccessful.");
                      }
                    },
                  )
              ),



            ],
          ),
        )

    );
  }*/
}