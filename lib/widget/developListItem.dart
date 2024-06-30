import 'package:another_flushbar/flushbar.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/DevelopTechSupport.dart';
import 'package:grocery_store/models/SupportList.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/screens/DevelopTechSupport/developMessageScreen.dart';
import 'package:grocery_store/screens/supportMessagesScreen.dart';
import 'package:intl/intl.dart';

class DevelopListItem extends StatelessWidget {
  final Size size;
  final DevelopTechSupport item;
  final GroceryUser user;
  final String? theme;

  const DevelopListItem({
    required this.size,
    required this.item,
    required this.user,
    this.theme,
  });

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

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd/MM/yy');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DevelopMessageScreen(
              develop: item,
              user: user,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: size.width,
            padding: const EdgeInsets.only(
                left: 5.0, right: 5.0, bottom: 10.0, top: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border:
                  Border.all(color: Color.fromRGBO(48, 48, 48, 1), width: .5),
              color: AppColors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 40.0,
                  color: theme == "light" ? Colors.black : Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: size.width * .5,
                            child: Text(
                              item.userName,
                              /*style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                fontSize: 14.5,
                                color: theme == "light"
                                    ? Colors.black
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),*/
                              style: TextStyle(
                                fontFamily: getTranslated(context, "fontFamily"),
                                color: Color.fromRGBO(48, 48, 48, 1),
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            // date,
                            item.sendTime != null
                                ? '${dateFormat.format(item.sendTime.toDate())}'
                                : '..',
                            style: TextStyle(
                              fontFamily: getTranslated(context, "fontFamily"),
                              fontSize: 12.0,
                              color: theme == "light"
                                  ? Colors.black
                                  : Colors.black,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * .6,
                            child: item.title == null
                                ? SizedBox()
                                : (item.title != "imageFile" &&
                                        item.title != "voiceFile")
                                    ? Text(
                                        item.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          fontSize: 12.0,
                                          color: theme == "light"
                                              ? Colors.black
                                              : Colors.black,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 0.3,
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          Icon(
                                            Icons.file_copy_outlined,
                                            size: 15,
                                            color: theme == "light"
                                                ? Colors.white.withOpacity(0.6)
                                                : Colors.black.withOpacity(0.6),
                                          ),
                                          Text(
                                            getTranslated(
                                                context, "attatchment"),
                                            style: TextStyle(
                                              fontFamily: getTranslated(
                                                  context, "fontFamily"),
                                              fontSize: 13.0,
                                              color: theme == "light"
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
