
import 'dart:async';

import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/widget/playVideoWidget.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../localization/localization_methods.dart';
import '../models/courseVideo.dart';
import '../models/courses.dart';
import '../screens/courseVideoDetailsScreen.dart';
import '../screens/testScreen.dart';


class VideoItem extends StatefulWidget {
  final CourseVideo video;
  final Courses course;
  final String? loggedUserId;
  const VideoItem({Key? key, required this.video, required this.course, this.loggedUserId}) : super(key: key);

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  bool play=false;

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  InkWell(onTap: () async {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>ChewieDemo(video: widget.video,)),
        // BumbleBeeRemoteVideo(video: widget.video,)),
        //CourseVideoDetailScreen(video:widget.video)),
      );
    },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.h13_2.r),
          ),
          child: Stack(fit:StackFit.expand,children: [
            Positioned(left: 0,right: 0,top: 0,bottom: 0,
              child: 
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: CachedNetworkImage(
                    memCacheHeight: 500,
                    memCacheWidth: 500,
                    imageUrl:
                     widget.video.image??
                    widget.course.image,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Center(
                      child: Container(height: 100,
                        child: Center(
                          child: Image.asset(
                              'assets/icons/icon/load2.gif',
                              width: 40,
                              height: 40,
                              fit: BoxFit.fill
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Image.asset(
                        'assets/icons/icon/Mask Group 47.png',
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
              ),

            ),
           Positioned(left: 0,
           right: 0,
           top: 0,
           bottom: 0,
            child: Container(
  width: AppSize.w242_6.w,
  height:AppSize.h245_3.h,
  decoration: BoxDecoration(
    // color: Colors.transparent,
    gradient: LinearGradient(
      stops: [.3, 5],
      colors: [
        Color.fromRGBO(255, 255, 255, 0.0),
        Color.fromRGBO(56, 56, 56, 1.0),
      ],
      end:Alignment.bottomCenter ,
      begin: Alignment.topCenter,
    ),
    borderRadius: BorderRadius.circular(10.0),
  ),
)
,),
            Positioned(left: 0,right: 0,top: 0,bottom: 0,
              child: Container(padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                    Padding(
                      padding: EdgeInsets.only(right: AppPadding.p17.w,
                      top:AppPadding.p23_5.h,
                       ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(widget.video.views==null?""
                          :widget.video.views.toString(), 
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              color: Color.fromRGBO(32 ,32 ,32,1),
                              fontSize: AppFontsSizeManager.s13_3.sp,
                            ),
                          ),
                        Icon(Icons.remove_red_eye_outlined,
                            color: Color.fromRGBO(32 ,32 ,32,1),size: 15,),
                      
                      
                        ],
                      ),
                    ),
                    // SizedBox(height: AppSize.h52.h,),
                    Icon(Icons.play_circle_fill,
                      color: AppColors.white,size: AppSize.h50_5.r,),
                    Padding(
                      padding:EdgeInsets.only(left: AppPadding.p17.w,
                      bottom:AppPadding.p17.r, ),
                      child: Text(
                       widget.video.name==null? ""
                        :
                        StringUtils.capitalize( widget.video.name.toString()),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow:TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: getTranslated(context, "academyFontFamily"),
                            color:Color.fromRGBO(255 ,255 ,255,1),
                            fontSize: AppFontsSizeManager.s18_6.sp,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ],)),
            ),


          ])
      ),
    );
  }
  // Widget buildww(BuildContext context) {
  //   Size size = MediaQuery.of(context).size;
  //   return InkWell(onTap: () async {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) =>ChewieDemo(video: widget.video,)),
  //          // BumbleBeeRemoteVideo(video: widget.video,)),
  //       //CourseVideoDetailScreen(video:widget.video)),
  //     );
  //   /* Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => _BumbleBeeRemoteVideo()),
  //           //CourseVideoDetailScreen(video:widget.video)),
  //     );*/
  //    /* if(widget.course.price!="0.0"&&widget.loggedUserId==null)
  //     {
  //       Navigator.pushNamed(context, '/Register_Type');
  //     }
  //     else if(widget.course.price=="0.0"||(widget.course.paidUsers!.contains(widget.loggedUserId))){
  //       await  FirebaseFirestore.instance.collection('CourseVideo').doc(widget.video.videoId).update(
  //         {
  //           "views":FieldValue.increment(1),
  //         }, );
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => VideoPlayScreen(video:widget.video,influencer: widget.influencer,)),
  //       );
  //     }
  //     else{
  //       Fluttertoast.showToast(
  //           msg: getTranslated(context, "paidCourse"),
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           backgroundColor: Colors.red,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     }*/

  //   },
  //     child:  Container(width: size.width,
  //       padding: EdgeInsets.all(15),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(20),
  //          image: DecorationImage(
  //          image: NetworkImage(widget.video.image??AssetsManager.logoLoveIcon,)),
  //           color: AppColors.white,
  //           boxShadow: [
  //             BoxShadow(
  //               color: Color.fromRGBO(0, 0, 0, 0.05),
  //               blurRadius: 12,
  //               spreadRadius: 0.0,
  //               offset: Offset(0.0, 5.0),
  //             ),
  //           ]
  //       ),
  //       child:    Row(mainAxisSize: MainAxisSize.max,
  //         children: [
  //           Padding(padding: EdgeInsets.only(left: 5,right: 5),
  //             child:
  //             Container( padding: EdgeInsets.all(6),
  //               decoration:BoxDecoration(
  //                 borderRadius: BorderRadius.circular(11),
  //                 color: Color.fromRGBO(0, 0, 0, 0.04),
  //               ),
  //               child: ClipRRect(
  //                 borderRadius: const BorderRadius.all(Radius.circular(11)),
  //                 child: CachedNetworkImage(width: 55,height: 55,
  //                   memCacheHeight: 500,memCacheWidth: 500,
  //                   imageUrl: widget.course.image??AssetsManager.logoLoveIcon,
  //                   fit: BoxFit.fill,
  //                   placeholder: (context, url) => Center(
  //                       child:CircularProgressIndicator(color: AppColors.reddark2,)
  //                   ),
  //                   errorWidget: (context, url, error) => Center(
  //                     child: Image.asset(
  //                       'assets/icons/icon/Mask Group 47.png',
  //                       width: 55,
  //                       height: 55,
  //                     ),
  //                   ),
  //                 ),

  //               ),
  //             ),
  //           ),
  //           Expanded(
  //             child: Column( mainAxisSize: MainAxisSize.max,crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Container(
  //                   child: Text(

  //                     widget.video.name.toString()??"",
  //                     textAlign: TextAlign.start,
  //                     overflow: TextOverflow.ellipsis,
  //                     maxLines: 1,
  //                     style: TextStyle(
  //                         fontFamily: getTranslated(context, "fontFamily"),
  //                         color: AppColors.black,
  //                         fontSize: 13.0,
  //                         fontWeight: FontWeight.w500
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 5,),
  //                 Row(mainAxisAlignment: MainAxisAlignment.start, children: [
  //                   Icon(Icons.remove_red_eye_outlined,
  //                     color: Color.fromRGBO(205, 61, 99, 1), size: 15,),
  //                   SizedBox(width: 3,),
  //                   Text(widget.video.views==null?"":
  //                     widget.video.views.toString() + " " +
  //                         getTranslated(context, "view"),
  //                     textAlign: TextAlign.start,
  //                     overflow: TextOverflow.ellipsis,
  //                     maxLines: 1,
  //                     style: TextStyle(
  //                         fontFamily: getTranslated(context, "fontFamily"),
  //                         color: Color.fromRGBO(199 ,198 ,198,1),
  //                         fontSize: 9.0,
  //                         fontWeight: FontWeight.w600
  //                     ),
  //                   ),

  //                 ],)
  //               ],),
  //           ),
  //           Container(
  //             height: 35,
  //             width: 35,
  //             decoration: BoxDecoration(
  //                 border: Border.all(color: AppColors.lightGrey, width: 1),
  //                 shape: BoxShape.circle,
  //                 color: Color.fromRGBO(205, 61, 99, 1),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Color.fromRGBO(255, 0 ,67, 0.15),
  //                     blurRadius: 14,
  //                     spreadRadius: 0.0,
  //                     offset: Offset(0.0, 8.0),
  //                   ),
  //                 ]
  //             ),
  //             child: Center(
  //               child: Icon(play?Icons.stop:Icons.play_arrow,
  //                 color: Colors.white, size: 18,),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}