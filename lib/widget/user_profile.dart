
import 'package:flutter/material.dart';
import 'package:grocery_store/widget/rounded_image.dart';

import '../models/order.dart';

/// Shows the user's account icon in the room

class UserProfile extends StatelessWidget {
  final UserDetails user;
  final double? size;
  final bool? isMute;
  final bool? isModerator;

  const UserProfile(
      {Key? key,
      required this.user,
      this.size,
      this.isMute = true,
      this.isModerator = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                '/profile',
                arguments: user,
              ),
              child: Image.asset('assets/icons/icon/Group2843.png',
                width: 22,
                height: 22,
              ),
             /* RoundedImage(
                path: "https://firebasestorage.googleapis.com/v0/b/beaut-e383d.appspot.com/o/profileImages%2Fdd815081-8aa4-4941-9551-cfb1e1882e04?alt=media&token=c41ac0a2-7369-4d5c-8c5e-fe6bd17e8c6f",//user.image,
                width: 100,//size,
                height: 100,//size,
              ),*/
            ),
            mute(isMute!),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            moderator(isModerator!),
            Text(
              user.name.split(' ')[0],
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  ///Return if user is moderator

  Widget moderator(bool isModerator) {
    return isModerator
        ? Container(
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(Icons.star, color: Colors.white, size: 12),
          )
        : Container();
  }

  ///Return if user is mute

  Widget mute(bool isMute) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: isMute
          ? Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: Offset(0, 1),
                  )
                ],
              ),
              child: Icon(Icons.mic_off),
            )
          : Container(),
    );
  }
}
