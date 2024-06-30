

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/consultPackage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/models/user.dart';
import 'package:uuid/uuid.dart';

import '../config/colorsFile.dart';
import '../config/paths.dart';

class ReportBottomSheetWidget extends StatefulWidget {
  final GroceryUser consult;
  final GroceryUser loggedUser;
  ReportBottomSheetWidget({required this.consult,required this.loggedUser});

  @override
  _ReportBottomSheetWidgetState createState() => _ReportBottomSheetWidgetState();
}

class _ReportBottomSheetWidgetState extends State<ReportBottomSheetWidget> {
  bool blockUser = false, badUser = false,badContent=false,submit=false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size     size = MediaQuery.of(context).size;
   return IconButton(
     onPressed: () {
       if(widget.loggedUser==null)
       Navigator.pushNamed(context, '/Register_Type');
       else
       _show(context, size);
     },
     icon: Icon(
       Icons.report_gmailerrorred_outlined,color: AppColors.reddark,
     ),
   );
  }
  void _show(BuildContext ctx, size) {
    showModalBottomSheet(
      elevation: 10,
      backgroundColor: Colors.transparent,
      context: ctx,
      builder: (ctx) => Container(
        height: size.height * .5,
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40.0),
              topRight: const Radius.circular(40.0),
            )),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StatefulBuilder(builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                       getTranslated(context, "report"),
                        style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                          color:  AppColors.reddark,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: badUser,
                          onChanged: (value) {
                            setState(() {
                              badUser = !badUser;
                            });
                          },
                        ),
                        Text(
                          getTranslated(context, "badUser"),
                          style: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: badContent,
                          onChanged: (value) {
                            setState(() {
                              badContent = !badContent;
                            });
                          },
                        ),
                        Text(
                          getTranslated(context, "badContent"),
                          style: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: blockUser,
                          onChanged: (value) {
                            setState(() {
                              blockUser = !blockUser;
                            });
                          },
                        ),
                        Text(
                          getTranslated(context, "blockUser"),
                          style: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color:  AppColors.black,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    submit
                        ? Center(child: CircularProgressIndicator())
                        : Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Center(
                        child: SizedBox(
                          height: 35,
                          width: size.width,
                          child: MaterialButton(
                            onPressed: () {
                              submit=true;
                              addReport();
                            },
                            color: AppColors.reddark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Text(
                              getTranslated(context, "submit"),
                              style: TextStyle(
                                fontFamily:
                                getTranslated(context, "fontFamily"),
                                color: AppColors.white,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              );
            })),
      ),
    );
  }
  Future<void> addReport()async {
    setState(() {
      // adding=true;
    });
    String reportId = Uuid().v4();
    await FirebaseFirestore.instance.collection(Paths.complaintsPath).doc(reportId).set({
      'appointmentId': "",
      'complaintTime': Timestamp.now(),
      'complaints': "bad content",
      "other":true,
      'consultName': widget.consult.name,
      'consultPhone': widget.consult.phoneNumber,
      'consultUid': widget.consult.uid,
      'id': reportId,
      'name': widget.loggedUser!=null?widget.loggedUser.name:" ",
      'phone':widget.loggedUser!=null?widget.loggedUser.phoneNumber:" ",
      'status': "new",
      'uid': widget.loggedUser!=null?widget.loggedUser.uid:" ",
    }
    ).then((value)
    {
      setState(() {
        submit=false;
      });
      appointmentDialog(MediaQuery.of(context).size);
    });
  }
  appointmentDialog(Size size) {
    return showDialog(
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        contentPadding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
                child: Container(height: 70,width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // color: Colors.white,
                    ),
                    child: Image.asset('assets/icons/icon/Group2887.png', fit:BoxFit.contain,height: 70,width: 90)

                )
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              getTranslated(context, "reportSend"),
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                fontSize: 11.0,
                fontWeight: FontWeight.w300,
                color: AppColors.black,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),

            Center(
              child: Container(
                width: size.width*.4,height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.greendark2,
                        AppColors.red1
                      ],
                    )
                ),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    getTranslated(context, 'Ok'),
                    style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ), barrierDismissible: false,
      context: context,
    );
  }
}
