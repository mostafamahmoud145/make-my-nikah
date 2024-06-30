
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../config/colorsFile.dart';
import '../screens/YoutubePlayerDemoScreen.dart';

class VideoWidget extends StatefulWidget {
  final String link;
  VideoWidget({required this.link});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget>with SingleTickerProviderStateMixin {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId:widget.link!.replaceAll("https://www.youtube.com/watch?v=", "").trim()
          .replaceAll("https://www.youtube.com/shorts/", "").trim(),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    );
  }
  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  YoutubePlayerBuilder(
        onExitFullScreen: () {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    },
          player: YoutubePlayer(
          controller: _controller!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: AppColors.pink,
          bottomActions: [

          CurrentPosition(),
          ProgressBar(isExpanded: true),
          RemainingDuration(),
          // FullScreenButton(),
          ],
          topActions: <Widget>[

          IconButton(
          icon: const Icon(
          Icons.fit_screen,
          color: Colors.white,
          size: 25.0,
          ),
          onPressed: () async {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => YoutubePlayerDemoScreen(link:widget.link!,desc:" ")),
          );
          },
          ),
          (widget.link!=null&&widget.link!="")?Expanded(
          child: Text( _controller!.metadata.title,
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
          builder: (context, player) =>Column(
            children: [
              Center(
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),child: player),
              ),
              SizedBox(height: 20,)
            ],
          ));

  }

}
