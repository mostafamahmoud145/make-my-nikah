import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_constat.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/resopnsive.dart';

class CoachProfileImageWidget extends StatelessWidget {
  final GroceryUser consultant;
  const CoachProfileImageWidget({super.key, required this.consultant});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: convertPtToPx(AppSize.h70).h,
        width: convertPtToPx(AppSize.w70).w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(32, 32, 32, 0.05),
              blurRadius: 17.0,
              spreadRadius: 0.0,
              offset: Offset(0, 5.0), // shadow direction: bottom right
            )
          ],
        ),
        child: consultant.photoUrl!.isEmpty
            ? Image.asset(
                AssetsManager.loadGIF,
                height: convertPtToPx(AppSize.h70).h,
                width: convertPtToPx(AppSize.w70).w,
                fit: BoxFit.cover,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: FadeInImage.assetNetwork(
                  placeholder: AssetsManager.loadGIF,
                  placeholderScale: 0.5,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      Image.asset(
                    AssetsManager.loadGIF,
                    height: convertPtToPx(AppSize.h70).h,
                    width: convertPtToPx(AppSize.w70).w,
                    fit: BoxFit.cover,
                  ),
                  image: consultant.photoUrl!,
                  fit: BoxFit.cover,
                  fadeInDuration:
                      Duration(milliseconds: AppConstants.milliseconds250),
                  fadeInCurve: Curves.easeInOut,
                  fadeOutDuration:
                      Duration(milliseconds: AppConstants.milliseconds150),
                  fadeOutCurve: Curves.easeInOut,
                ),
              ),
      ),
    );
  }
}
