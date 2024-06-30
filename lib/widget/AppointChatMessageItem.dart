
import 'package:another_flushbar/flushbar.dart';
import 'package:grocery_store/widget/AutoDirection.dart';
import '../FireStorePagnation/paginate_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/SupportMessage.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/widget/playVideoWidget.dart';
import 'package:grocery_store/widget/playrecordWidget.dart';
import 'package:intl/intl.dart';
import 'package:linkwell/linkwell.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/colorsFile.dart';

class AppointChatMessageItem extends StatefulWidget {
  final SupportMessage message;
  final GroceryUser user;

  const AppointChatMessageItem({
    required this.message,
    required this.user,
  });

  @override
  State<AppointChatMessageItem> createState() => _AppointChatMessageItemState();

  static Widget chatImage(
      BuildContext context, String chatContent, String type) {
    return Container(
        padding: EdgeInsets.only(left:type != "USER"? 210:14, right: 14, top: 10, bottom: 10),
        child: Align(
          alignment: (type != "USER" ? Alignment.topLeft : Alignment.topRight),
          child: Container(
            child: ElevatedButton(
                child: Material(
                  child: kIsWeb
                      ? widgetShowImages(chatContent, 250)
                      : widgetShowImages(chatContent, 150), //100
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  //clipBehavior: Clip.hardEdge,
                ),
                onPressed: () async {
                  // launchURL(chatContent);
                  var url = chatContent;
                  if (!url.contains('http')) {
                    url = 'https://$url';
                  }
                  await launch(url);
                },
                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0.0))),
            margin: type == "USER"
                ? EdgeInsets.only(bottom: 10.0, right: 10.0)
                : EdgeInsets.only(left: 10.0),
          ),
        ));
  }

  // Show Images from network
  static Widget widgetShowImages(String imageUrl, double imageSize) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/icons/icon/load.gif',
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

class _AppointChatMessageItemState extends State<AppointChatMessageItem> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 14, right: 14, top: 5, bottom: 5),
          child: Align(
            alignment: (widget.message.userUid != widget.user.uid
                ? Alignment.topLeft
                : Alignment.topRight),
            child:
            widget.message.type == "image"
                ? AppointChatMessageItem.chatImage(
                    context, widget.message.message, widget.message.owner)
                : widget.message.type == "voice"
                    ? PlayRecordWidget(
                        url: widget.message.message,
                        owner: widget.message.userUid != widget.user.uid)
                    : widget.message.type == "video"
                        ? PlayVideoWidget(url: widget.message.message)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(25.0),
                                      topRight: const Radius.circular(25.0),
                                      bottomLeft: Radius.circular(
                                          widget.message.userUid !=
                                                  widget.user.uid
                                              ? 0.0
                                              : 25.0),
                                      bottomRight: Radius.circular(
                                          widget.message.userUid !=
                                                  widget.user.uid
                                              ? 25.0
                                              : 0.0),
                                    ),
                                    gradient: widget.message.userUid !=
                                            widget.user.uid
                                        ? const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.topRight,
                                            colors: [
                                              AppColors.reddark2,
                                              AppColors.reddark2,
                                            ],
                                          )
                                        : const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.topRight,
                                            colors: [
                                              Color.fromRGBO(123, 108, 150, 0.11),
                                              Color.fromRGBO(123, 108, 150, 0.11),
                                            ],
                                          ),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: _createTextMessage(context, size),
                              ),
                              widget.message.messageTimeUtc != null
                                  ? Text(
                                      // DateTime.parse(message.messageTimeUtc).toLocal().toString(),
                                      '${new DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(widget.message.messageTimeUtc).toLocal())}',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontFamily: getTranslated(
                                            context, "fontFamily"),
                                        fontSize: 10.0,
                                        color: AppColors.chatTime,
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  void showSnack(String text, BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: BorderRadius.circular(7),
      backgroundColor: Colors.green.shade500,
      animationDuration: Duration(milliseconds: 300),
      isDismissible: true,
      boxShadows: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 1.0,
          blurRadius: 5.0,
          offset: Offset(0.0, 2.0),
        )
      ],
      shouldIconPulse: false,
      duration: Duration(milliseconds: 2000),
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      messageText: Text(
        '$text',
        style: GoogleFonts.poppins(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          color: Colors.white,
        ),
      ),
    )..show(context);
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

  Widget _createTextMessage(context, Size size) {
    return (widget.message.message != null &&
            widget.message.message.contains('https://'))
        ? InkWell(
            splashColor: Colors.white.withOpacity(0.5),
            onTap: () {
              Clipboard.setData(ClipboardData(text: widget.message.message));
              showSnack(getTranslated(context, "textCopy"), context);
            },
            child: widget.message.message != null
                ? AutoDirection(

                    text: widget.message.message != null
                        ? widget.message.message
                        : "...",
                    child: LinkWell(
                      widget.message.message != null
                          ? widget.message.message
                          : "...",
                      linkStyle: TextStyle(
                        fontFamily: getTranslated(context, "fontFamily"),
                        color: Colors.blue,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: getTranslated(context, "fontFamily"),
                        color: widget.message.userUid == widget.user.uid
                            ? Colors.black
                            : AppColors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  )
                : SizedBox(),
          )
        : InkWell(
            splashColor: Colors.white.withOpacity(0.5),
            onTap: () {
              if (widget.message.type == "closing" &&
                  widget.user.userType != "SUPPORT") {
                // rateDialog(size);
              } else {
                Clipboard.setData(ClipboardData(text: widget.message.message));
                showSnack(getTranslated(context, "textCopy"), context);
              }
            },
            child: widget.message.message != null
                ? AutoDirection(
                    text: widget.message.message != null
                        ? widget.message.message
                        : "...",
                    child: Text.rich(
                      TextSpan(
                        text: widget.message.message != null
                            ? widget.message.message
                            : "...",
                        style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          color: widget.message.userUid == widget.user.uid
                              ? Colors.black
                              : AppColors.white,
                          fontSize: 15.0,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: " ",
                          ),
                          widget.message.type == "closing"
                              ? TextSpan(
                                  text: getTranslated(context, "pressHere"),
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 3,
                                      fontFamily: getTranslated(context, "fontFamily"),
                                      color: Colors.lightBlueAccent,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                )
                              : TextSpan(
                                  text: ' ',
                                ),
                        ],
                      ),
                      softWrap: true,
                      maxLines: 10,
                      textAlign: TextAlign.center,
                    ),
                  )
                : SizedBox(),
          );
  }
}
