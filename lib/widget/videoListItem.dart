
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import '../models/videos.dart';
import '../screens/YoutubePlayerDemoScreen.dart';



class VideoListItem extends StatelessWidget {
  final Video video;
  final String type;
  VideoListItem({required this.video, required this.type});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return   ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(height: 150,width: size.width-60,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.balck2.withOpacity(0.0),
                  AppColors.balck2
                ],
              )
          ),
        child: Stack(children: <Widget>[
          Container(height: 150,width: size.width-60,
              child:ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: FadeInImage.assetNetwork(
                  placeholder:'assets/icons/icon/load.gif',
                  height: 150,width: size.width-60,
                  placeholderScale: 0.3,
                  imageErrorBuilder:(context, error, stackTrace) => Image.asset('assets/icons/icon/Mask Group 47.png',width: 70,height: 70,fit:BoxFit.fill),
                  image: "https://img.youtube.com/vi/"+video.link.replaceAll("https://www.youtube.com/watch?v=", "").trim()
                      .replaceAll("https://www.youtube.com/shorts/", "").trim()+"/hqdefault.jpg",
                  fit: BoxFit.cover,
                  fadeInDuration:
                  Duration(milliseconds: 250),
                  fadeInCurve: Curves.easeInOut,
                  fadeOutDuration:
                  Duration(milliseconds: 150),
                  fadeOutCurve: Curves.easeInOut,
                ),
              )

          ),
          type=="list"?Column(mainAxisSize:MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
            SizedBox(),
            Container(height:30,width: size.width-60,
              padding: EdgeInsets.only(left: 5,right: 5),
              decoration: BoxDecoration(
               // color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize:MainAxisSize.min,
                  children: [
                  Text(
                    "Trending",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      color: AppColors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 17.0,
                    ),
                  ),
                  Row(
                   // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon( Icons.remove_red_eye_outlined,color:AppColors.white,size: 10.0, ),
                      SizedBox(width: 2,),
                      Text(
                        "500K",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                          color: AppColors.white,
                          fontSize: 9.0,
                        ),
                      ),
                    ],
                  ),
                ],),
              ),
            )
          ],):SizedBox(),
          InkWell(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => YoutubePlayerDemoScreen(link:video.link, desc: '',)),
              );
            },
            child: Container(
              height: 150,width: size.width-60,
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
              ),child: Center(child: Icon( Icons.play_circle_outline,color:AppColors.white,size: 35.0, )),

            ),
          ),
        ]),
      ),
    );
  }


}
