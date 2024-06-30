

import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/consultPackage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/models/user.dart';

class ConfirmDialog extends StatefulWidget {
  final GroceryUser consult;
  final GroceryUser loggedUser;
  final consultPackage package;
  ConfirmDialog({required this.consult,required this.loggedUser,required this.package});

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  final TextEditingController controller = TextEditingController();
  late double rating;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      elevation: 5.0,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                getTranslated(context,'proCode'),
                style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                  color: Colors.black87,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),

            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
               enableInteractiveSelection: true,
               // maxLines: 5,
               // maxLength: 250,
                style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                  fontSize: 14.0,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                  border: InputBorder.none,
                  hintText: getTranslated(context,"enterPromoCode"),
                  hintStyle: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                    fontSize: 14.0,
                    color: Colors.black54,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                  ),
                  counterStyle: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                    fontSize: 12.5,
                    color: Colors.black54,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Center(
              child: SizedBox(
                width: size.width * 0.5,
                child: MaterialButton(
                  onPressed: () {
                    

                  },
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                  getTranslated(context,'pay'),
                    style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: size.width * 0.5,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    getTranslated(context,'cancel'),
                    style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      color: Colors.red,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
