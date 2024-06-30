/*


import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import '../models/InfCourse.dart';
import '../models/Influencer.dart';
import '../screens/infCourseVideoScreen.dart';

class InfCourseItem extends StatefulWidget {
  final Influencer influencer;
  final InfCourses course;
  final String? loggedUserId;

  const InfCourseItem({Key? key, required this.influencer,required this.course, this.loggedUserId}) : super(key: key);

  @override
  State<InfCourseItem> createState() => _InfCourseItemState();
}

class _InfCourseItemState extends State<InfCourseItem> {
bool sharing=false,buy=false;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(onTap: () async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InfCourseVideosScreen(
            influencer: widget.influencer,
            course: widget.course,
            loggedUserId: widget.loggedUserId,
          ),
        ),
      );
    },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0 ,0, 0.04),
                blurRadius: 12,
                spreadRadius: 0.0,
                offset: Offset(0.0, 5.0),
              ),
            ]
        ),
        child: Column(
          children: [
            Stack(alignment: Alignment.center,children: [
              Container(width: size.width,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: FadeInImage.assetNetwork(
                    height: 150, //width:size.width*0.60,
                    placeholder:'assets/icons/icon/load.gif',
                    placeholderScale: 0.5,
                    imageErrorBuilder:(context, error, stackTrace) => Image.asset('assets/icons/icon/Mask Group 47.png',width: 70,height: 70,fit:BoxFit.fill),
                    image: widget.course.image,
                    fit: BoxFit.cover,
                    fadeInDuration:
                    Duration(milliseconds: 250),
                    fadeInCurve: Curves.easeInOut,
                    fadeOutDuration:
                    Duration(milliseconds: 150),
                    fadeOutCurve: Curves.easeInOut,
                  ),
                ),
              ),
              Center(
                  child: Icon(Icons.play_circle_outline,
                    color: AppColors.white,size: 30,),
              ),



            ],
            ),
            SizedBox(height: 5,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize:MainAxisSize.max,children: [
              Expanded(
                child: Text(
                  widget.course.name,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      color: Color.fromRGBO(32, 32 ,32,1),
                      fontSize: 19.0,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
              sharing?CircularProgressIndicator():IconButton(
                icon: new Icon(Icons.share_outlined,
                  color: Color.fromRGBO(205, 61 ,99,1),size: 15,),
                onPressed: () {
                  share(context);
                },
              ),

            ],),
            SizedBox(height: 5,),
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.course.desc,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 14,
                  style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      color: Color.fromRGBO(175, 175, 175,1),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize:MainAxisSize.max,
              crossAxisAlignment:CrossAxisAlignment.center,children: [
              Column(mainAxisAlignment:MainAxisAlignment.center,crossAxisAlignment:CrossAxisAlignment.start,children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start,children: [
                    Icon(Icons.videocam_outlined,
                      color: Color.fromRGBO(205, 61 ,99,1),size: 15,),
                    SizedBox(width: 3,),
                    Text(
                      widget.course.videoCount.toString()+" "+getTranslated(context, "video"),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: "montserrat",//getTranslated(context,"fontFamily"),
                          color: Color.fromRGBO(32, 32, 32,1),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400
                      ),
                    ),

                  ],),
                  Row(mainAxisAlignment: MainAxisAlignment.start,children: [
                    Icon(Icons.remove_red_eye_outlined,
                      color: Color.fromRGBO(205, 61 ,99,1),size: 15,),
                    SizedBox(width: 3,),
                    Text(
                      widget.course.views.toString()+" "+getTranslated(context, "view"),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontFamily: "montserrat",//getTranslated(context,"fontFamily"),
                          color: Color.fromRGBO(32, 32, 32,1),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400
                      ),
                    ),

                  ],),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(255, 0, 67, 0.15),
                        blurRadius: 1,
                        spreadRadius: 0.0,
                        offset: Offset(0.0, 2.0),
                      ),
                    ]
                ),
                child: Text(
                  widget.course.price=="0.0"?getTranslated(context, "free"):widget.course.price+"\$",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      color: AppColors.reddark,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),

            ],),
          ],
        ),
      ),
    );
  }
  share(BuildContext context) async {
    setState(() {
      sharing = true;
    });
    String uid=widget.course.courseId;
    // Create DynamicLink
    print("share1");
    print("https://beautapplication\.page\.link/.*course_id="+uid);
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://beautapplication\.page\.link/course_id="+uid),
      uriPrefix:"https://beautapplication\.page\.link",
      androidParameters: const AndroidParameters(packageName: "com.app.MakeMyNikah"),
      iosParameters: const IOSParameters(bundleId: "com.app.MakeMyNikahApp",appStoreId:"1668556326"),
    );
    ShortDynamicLink dynamicLink =
    await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    File file;
    final directory = await getTemporaryDirectory();
    final path = directory.path;
    final response = await http.get(Uri.parse(widget.course.image));
    file = await File('$path/image_${DateTime.now().millisecondsSinceEpoch}.png').writeAsBytes(response.bodyBytes);
    String text="${widget.course.name} \n I think that it will be a good course for you \n ${dynamicLink.shortUrl.toString()}";
       Share.shareFiles(["${file.path}"],
        text:text);
    setState(() {
      sharing = false;
    });
  }

}*/
