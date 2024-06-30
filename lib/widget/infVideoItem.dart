/*

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/config/colorsFile.dart';


import '../config/paths.dart';
import '../localization/localization_methods.dart';
import '../models/InfCourse.dart';
import '../models/Influencer.dart';
import '../models/infCourseVideo.dart';
import '../screens/YoutubePlayerDemoScreen.dart';
import '../screens/infVideoDetailsScreen.dart';

class InfVideoItem extends StatefulWidget {
  final InfCourseVideo video;
  final Influencer influencer;
  final InfCourses course;
  final String? loggedUserId;
  const InfVideoItem({Key? key, required this.video, required this.influencer, required this.course, this.loggedUserId}) : super(key: key);

  @override
  State<InfVideoItem> createState() => _InfVideoItemState();
}

class _InfVideoItemState extends State<InfVideoItem> {
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
      if(widget.course.price!="0.0"&&widget.loggedUserId==null)
        {
          Navigator.pushNamed(context, '/Register_Type');
        }
      else if(widget.course.price=="0.0"||(widget.course.paidUsers.contains(widget.loggedUserId))){
        await  FirebaseFirestore.instance.collection(Paths.infCourseVideosPath).doc(widget.video.videoId).update(
          {
            "views":FieldValue.increment(1),
          }, );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InfVideoDetailsScreen(video:widget.video,influencer: widget.influencer,)),
        );
      }
      else{
        Fluttertoast.showToast(
            msg: getTranslated(context, "paidCourse"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }

    },
        child:  Container(width: size.width,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 12,
                    spreadRadius: 0.0,
                    offset: Offset(0.0, 5.0),
                  ),
                ]
            ),
            child:  Row(mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 5,right: 5),
                     child:
                      Container( padding: EdgeInsets.all(6),
                        decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          color: Color.fromRGBO(0, 0, 0, 0.04),
                      ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(11)),
                          child: FadeInImage.assetNetwork(
                            height: 55,
                            width:55,
                            placeholder: 'assets/icons/icon/load.gif',
                            placeholderScale: 0.5,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                Image.asset('assets/icons/icon/Mask Group 47.png', width: 55,
                                    height: 55,
                                    fit: BoxFit.fill),
                            image: "https://img.youtube.com/vi/" + widget.video.link +
                                "/0.jpg",
                            fit: BoxFit.cover,
                            fadeInDuration:
                            Duration(milliseconds: 255),
                            fadeInCurve: Curves.easeInOut,
                            fadeOutDuration:
                            Duration(milliseconds: 155),
                            fadeOutCurve: Curves.easeInOut,
                          ),
                        ),
                      ),
                   ),
                    Expanded(
                      child: Column( mainAxisSize: MainAxisSize.max,crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                   child: Text(
                                      widget.video.name,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontFamily: getTranslated(context, "fontFamily"),
                                          color: AppColors.black,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                 ),
                              SizedBox(height: 5,),
                              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                Icon(Icons.remove_red_eye_outlined,
                                  color: Color.fromRGBO(205, 61, 99, 1), size: 15,),
                                SizedBox(width: 3,),
                                Text(
                                  widget.video.views.toString() + " " +
                                      getTranslated(context, "view"),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: getTranslated(context, "fontFamily"),
                                      color: Color.fromRGBO(199 ,198 ,198,1),
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),

                              ],)
                            ],),
                    ),
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.lightGrey, width: 1),
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(205, 61, 99, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(255, 0 ,67, 0.15),
                              blurRadius: 14,
                              spreadRadius: 0.0,
                              offset: Offset(0.0, 8.0),
                            ),
                          ]
                      ),
                      child: Center(
                        child: Icon(Icons.play_arrow,
                          color: Colors.white, size: 18,),
                      ),
                    ),
                  ],
                ),
          ),
    );
  }
}*/
