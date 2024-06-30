import 'package:flutter/material.dart';

import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';

class AppReviewDialog extends StatefulWidget {

  String description;
  String title;
  String image;
  String name;

  AppReviewDialog({ required this.description, required this.title,required this.name,required this.image});

  @override
  _ReviewDialogState createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<AppReviewDialog> {
  @override
  Widget build(BuildContext context) {
    String star=getTranslated(context, "stars");
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      elevation: 5.0,
      contentPadding: EdgeInsets.all(0),
      content: Container(
        height: size.height * 0.4,
        width: double.maxFinite,
        constraints: BoxConstraints.loose(size),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Container(
                width: size.width,
                child: SafeArea(
                    child: Padding( padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 0.0, bottom: 6.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 35,
                            width: 35,

                            child: Center(
                              child: IconButton(
                                  onPressed: () {

                                    Navigator.pop(context);
                                  },
                                  icon: Image.asset("assets/icons/icon/Group2891.png",width: 13,height: 13,)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.image==null?SizedBox():  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          border: Border.all(color: AppColors.black2)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35.0),
                        child: widget.image == "" ? Image.asset("assets/icons/icon/im2.jpeg", width: 35,
                          height: 35,) : Image.network(widget.image),
                      ),
                    ),
                  SizedBox(height: 5,),
                  widget.name==null?SizedBox():Text(widget.name,style: TextStyle(
                      color: AppColors.reddark2,
                      fontSize: 9,
                      fontFamily: getTranslated(context, "fontFamily")
                  ),),
                  SizedBox(height: 10,),
                  Center(
                    child: widget.title == null ? SizedBox() : Text(
                      widget.title.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                          fontSize: 12.0,
                          color:AppColors.balck2,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text("description",style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      fontSize: 15.0,
                      color:AppColors.red1,
                      fontWeight: FontWeight.w300
                  ),),
                  SizedBox(height: 5,),
                  Center(
                    child: Text(
                      widget.description.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                          fontSize: 12.0,
                          color:AppColors.balck2,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                ],
            ),

          ]),
        ),
      ),
    );
  }
}

