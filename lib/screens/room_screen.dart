import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';

import '../models/order.dart';
import '../models/room.dart';
import '../widget/rounded_button.dart';
import '../widget/user_profile.dart';


class RoomScreen extends StatefulWidget {
  final Room room;
  final ClientRole role;

  const RoomScreen({Key? key, required this.room, required this.role}) : super(key: key);

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final List _users = [];
  String appId="680d9b31416c46b3850f1709f2a54d9e",uidCloud="",sid="",resourceId='';

  bool muted = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  /// Create Agora SDK instance and initialize
  Future<void> initialize() async {
     await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
   // await _engine.joinChannel("", widget.room.roomId, null, 0);
     await _engine.joinChannel(null, widget.room.roomId, null, 0);
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appId);
    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }

  /// Add Agora event handlers

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          print('onError: $code');
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        print('onJoinChannel: $channel, uid: $uid');
      },
      leaveChannel: (stats) {
        setState(() {
          print('onLeaveChannel');
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        print('userJoined: $uid');
        setState(() {
          _users.add(uid);
        });
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: () => Navigator.pop(context),
            ),
            Text(
              'All rooms',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            Spacer(),
            Container(width: 100,height: 100,color: Colors.red,)
          ],
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80, top: 20),
            child: Column(
              children: [
                title(widget.room.title),
                SizedBox(height: 30),
                speakers(
                  widget.room.users!.sublist(0, widget.room.speakerCount),
                ),
                others(
                  widget.room.users!.sublist(widget.room.speakerCount!),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: bottom(context),
          ),
        ],
      ),
    );
  }

  Widget title(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          child: IconButton(
            onPressed: () {},
            iconSize: 30,
            icon: Icon(Icons.more_horiz),
          ),
        ),
      ],
    );
  }

  Widget speakers(List<UserDetails> users) {
    return GridView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: users.length,
      itemBuilder: (gc, index) {
        return UserProfile(
          user: users[index],
          isModerator: index == 0,
          isMute: false,
          size: 80,
        );
      },
    );
  }

  Widget others(List<UserDetails> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Others in the room',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.grey.withOpacity(0.6),
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: users.length,
          itemBuilder: (gc, index) {
            return UserProfile(user: users[index], size: 60);
          },
        ),
      ],
    );
  }

  Widget bottom(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          RoundedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.red,
            disabledColor: Colors.green,
            child: Text(
              '✌️ Leave quietly',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Spacer(),
          RoundedButton(
            onPressed: () {
              Navigator.of(context).pop();
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return RoomScreen(
                    room: widget.room,
                    role: ClientRole.Broadcaster,
                  );
                },
              );
            },
            color: Colors.red,
            isCircle: true,
            disabledColor: Colors.green,
            child: Icon(Icons.hail, size: 15, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
