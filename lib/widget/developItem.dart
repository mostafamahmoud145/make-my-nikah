
import 'package:audioplayers/audioplayers.dart';
//import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery_store/models/developMessage.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/widget/AutoDirection.dart';
import 'package:grocery_store/widget/playrecordWidget.dart';
import 'package:intl/intl.dart';
import 'package:linkwell/linkwell.dart';
import 'package:url_launcher/url_launcher.dart';

import '../localization/localization_methods.dart';

class DevelopItem extends StatelessWidget {

  final DevelopMessage message;
  final GroceryUser user;
  const DevelopItem({
    required this.message,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    AudioPlayer player = AudioPlayer();
    return  Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
          child: Align(
            alignment: (message.owner!= "SUPPORT"?Alignment.topLeft:Alignment.topRight),
            child:  message.type=="image"?
            chatImage(context,message.message,message.owner):
            message.type=="voice"?
            PlayRecordWidget(url:message.message, owner: user.uid==message.userUid, ):
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (message.owner!= "SUPPORT"?Colors.grey.shade200:Colors.purple[50]),
              ),
              padding: EdgeInsets.all(16),
              child: Column( mainAxisAlignment:MainAxisAlignment.start,crossAxisAlignment:CrossAxisAlignment.start,children: [
                AutoDirection(
                  text: message.message,
                  child: LinkWell(
                    message.message,
                    linkStyle: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      color: Colors.blue,
                      fontSize: 15.0,
                    ),
                    textAlign:TextAlign.start ,
                    style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      color: Colors.black,
                      fontSize: 15.0,
                    ),),
                ),
                message.ownerName!=null?Text(
                  message.ownerName,
                  textAlign:TextAlign.end ,
                  style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                    fontSize: 11.0,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ):SizedBox(),
                message.messageTimeUtc!=null?Text(
                  //DateTime.parse(message.messageTimeUtc).toLocal().toString(),
                  '${new DateFormat('dd MMM yyyy, hh:mm a').format( DateTime.parse(message.messageTimeUtc).toLocal())}',
                  textAlign:TextAlign.end ,
                  style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                    fontSize: 11.0,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ):SizedBox(),
              ],),
            ),
          ),
        ),
        SizedBox(height: 5,),

      ],
    );
  }
  launchURL(String url) async {
    if (!url.contains('http')) url = 'https://$url';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // showSnakbar('Could not launch $url', false);

      throw 'Could not launch $url';
    }

  }
  static Widget chatImage(BuildContext context, String chatContent,String type) {
    return Container(
        padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
        child: Align(
          alignment: (type!= "SUPPORT"?Alignment.topLeft:Alignment.topRight),
          child: Container(
            child: ElevatedButton(
                child: Material(
                  child: kIsWeb
                      ? widgetShowImages(chatContent, 250)
                      : widgetShowImages(chatContent, 150),//100
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  //clipBehavior: Clip.hardEdge,
                ),
                onPressed: ()  async {
                  // launchURL(chatContent);
                  var url=chatContent;
                  if (!url.contains('http')) {
                    url = 'https://$url';
                  }
                  await launch(url);
                },
                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0.0))),
            margin: type=="SUPPORT"
                ? EdgeInsets.only(
                bottom:  10.0,
                right: 10.0)
                : EdgeInsets.only(left: 10.0),
          ),)
    );
  }

  // Show Images from network
  static Widget widgetShowImages(String imageUrl, double imageSize) {
    return  FadeInImage.assetNetwork(
      placeholder:'assets/icons/icon/load.gif',
      placeholderScale: 0.5,
      imageErrorBuilder: (context, error, stackTrace) => Icon(
        Icons.image_not_supported,
        size: 50.0,
      ),
      height: imageSize,
      width: imageSize,
      image: imageUrl,
      fit: BoxFit.cover,
      fadeInDuration: Duration(milliseconds: 250),
      fadeInCurve: Curves.easeInOut,
      fadeOutDuration: Duration(milliseconds: 150),
      fadeOutCurve: Curves.easeInOut,
    );

  }
}
