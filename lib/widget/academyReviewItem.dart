
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/appReview.dart';
import 'appReviewDialog.dart';

class AcademyReviewItem extends StatelessWidget {
  final AppReviews appReview;

  AcademyReviewItem({required this.appReview});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AppReviewDialog(
              description: appReview.description!,
              title: appReview.title!,
              name: appReview.name!,
              image: appReview.image!),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
            width: size.width * 0.35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    /* color: AppColors.grey2,
                blurRadius: 1,*/
                    color: AppColors.grey4,
                    blurRadius: 3,
                    spreadRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "’’",
                    style: TextStyle(
                        color: AppColors.reddark2,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: size.width * 0.3,
                    height: size.height * 0.08,
                    child: Text(
                      appReview.description!,
                      maxLines: 4,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.black2,
                          fontFamily: getTranslated(context, "fontFamily"),
                          fontSize: 10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          border: Border.all(color: AppColors.black2)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35.0),
                        child: appReview.image == ""
                            ? Image.asset(
                                "assets/icons/icon/im2.jpeg",
                                width: 35,
                                height: 35,
                              )
                            : Image.network(appReview.image!),
                      ),
                    ),
                  ),
                  Text(
                    appReview.name!,
                    style: TextStyle(
                        color: AppColors.reddark2,
                        fontSize: 9,
                        fontFamily: getTranslated(context, "fontFamily")),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    appReview.title!,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.black2,
                        fontSize: 9,
                        fontFamily: getTranslated(context, "fontFamily")),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
