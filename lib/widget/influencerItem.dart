/*

import 'package:flutter/material.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/Influencer.dart';
import 'package:grocery_store/models/user.dart';
import '../screens/infCoursesScreen.dart';



class InfluencerItem extends StatelessWidget {
  final Influencer influencer;
  final String? loggedUserId;
  InfluencerItem({required this.influencer, this.loggedUserId});


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return   InkWell(onTap: (){

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => infCoursesScreen(
            influencer: influencer,
            loggedUserId:loggedUserId
          ),
        ),
      );
    },
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
              width: size.width * 0.45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.white3,
                      blurRadius: 2,
                      spreadRadius: 0.0,
                      offset: Offset(1.0, 4.0),
                    ),
                  ]
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: AppColors.black2)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: influencer.image == "" ? Image.asset("assets/icons/icon/im2.jpeg", width: 50,
                        height: 50,) : Image.network(influencer.image,fit:BoxFit.cover),
                    ),
                  ),
                  Text(influencer.name,style: TextStyle(
                      color: AppColors.reddark2,
                      fontSize: 11,
                      fontFamily: getTranslated(context, "fontFamily")
                  ),),
                  SizedBox(height: 5,),
                  Container(
                    width: size.width * 0.3,
                    child: Text(influencer.desc,
                      maxLines: 4,
                      textAlign:TextAlign.center,
                      style: TextStyle(
                          color: AppColors.black2,
                          fontFamily: getTranslated(context, "fontFamily"),
                          fontSize: 9
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.only(left: 20,right: 20,top: 7,bottom: 7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.black,
                    ),
                    child: Text(getTranslated(context, "view"),
                      textAlign:TextAlign.center,
                      style: TextStyle(
                          color: AppColors.white,
                          fontFamily: getTranslated(context, "fontFamily"),
                          fontSize: 11
                      ),
                    ),
                  ),

                ],
              ),
          ),
        ),
    );
  }


}
*/
