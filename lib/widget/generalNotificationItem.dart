
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/generalNotifications.dart';
import 'package:intl/intl.dart';
import 'package:linkwell/linkwell.dart';

class GeneralNotificationItem extends StatelessWidget {
  final GeneralNotifications item;

  const GeneralNotificationItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    return Column(
      children: [
        Container(
          width: size.width,
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    getTranslated(context, "title")+" : ",
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.title,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
                  Text(
                    getTranslated(context, "description")+" : ",
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: LinkWell(
                        item.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.3,
                        ),
                        linkStyle: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.blue,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              /* Text(
                item.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),*/
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
                  Text(
                    getTranslated(context, "sendTo") + " : ",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    item.notificationType,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
                  Text(
                    getTranslated(context, "selectLanguage") + " : ",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    item.notificationLang!,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
                  Text(
                    getTranslated(context, "selectCountry") + " : " ,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    item.notificationCountry!,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                '${dateFormat.format(item.notificationTimestamp.toDate())}',
                style: GoogleFonts.poppins(
                  fontSize: 13.0,
                  color: Colors.black.withOpacity(0.4),
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }
}
