
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../localization/localization_methods.dart';

class ProcessingDialog extends StatelessWidget {
  final String message;
  ProcessingDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      elevation: 0.0,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30.0,
                height: 30.0,
                child: CircularProgressIndicator(),
              ),
              SizedBox(
                width: 15.0,
              ),
              Text(
                message,
                style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}
