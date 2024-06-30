
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import '../models/userReview.dart';
import 'appReviewDialog.dart';



class UserReviewItem extends StatelessWidget {

  final UserReviews userReviews;

  UserReviewItem(this.userReviews);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  InkWell(
      onTap: ()
      {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              AppReviewDialog(name:userReviews.name!,image:userReviews.image!,title:"",description: userReviews.description!                                                     ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
            width: size.width * 0.65,
            //height: size.height * 0.2,
            decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      /*color: AppColors.grey2,
                      blurRadius: 3,*/
                      color: AppColors.grey4,
                      blurRadius: 3,
                      spreadRadius: 0.0,
                      offset: Offset(0.0, 0.0),
                    ),
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                  width: 17,
                                  height: 17,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17.0),
                                      border: Border.all(color: AppColors.reddark2)
                                  ),
                                  child: userReviews.image == "" ? Icon(Icons.perm_identity,color: AppColors.reddark2,size: 10,)
                                  :ClipRRect(
                                    borderRadius: BorderRadius.circular(35.0),
                                    child:  Image.network(userReviews.image!, width: 35,
                                      height: 35,)
                                  )
                                  //Image.asset("assets/icons/icon/Path6865.png",width: 15,height: 15, fit: BoxFit.cover,)
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              // Expanded(
                              //   child:
                              Text(
                                userReviews.name!,
                                style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                                  color: AppColors.black2,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  // letterSpacing: 0.5,
                                ),
                              ),
                              // ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              // Expanded(
                              //   child:
                              Text(
                                userReviews.rate!,
                                style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                                  color: AppColors.black2,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  // letterSpacing: 0.5,
                                ),
                              ),
                              // ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Icon(Icons.star,color: Colors.amber,size: 10,)
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Text(
                        userReviews.description!,
                        textAlign: TextAlign.center,
                        softWrap: true,overflow:TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            color: AppColors.grey,
                            fontSize: 11
                        ),),

                    ],
                  ),
              ),

          ),
      ),
    );
  }


}
