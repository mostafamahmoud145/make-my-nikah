import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/models/courses.dart';
import 'package:grocery_store/screens/PayCoursesFeature/utils/service/PayCourseCubit/pay_course_cubit.dart';
import 'package:grocery_store/widget/IconButton.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';

class CourseImageWidget extends StatelessWidget {
  final Courses course;

  CourseImageWidget({required this.course});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: AppSize.h386_6.h,
      color: Color.fromRGBO(48, 48, 48, 1),
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p32.w,
      ),
      child: Stack(fit: StackFit.expand, children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: CachedNetworkImage(
            memCacheHeight: 500,
            memCacheWidth: 500,
            imageUrl: course.image,
            fit: BoxFit.fill,
            height: AppSize.h356.h,
            width: AppSize.w454_6.w,
            placeholder: (context, url) => Center(
              child: Container(
                height: 100,
                child: Center(
                  child: Image.asset(
                    'assets/icons/icon/load2.gif',
                    width: 40,
                    height: 40,
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
        Positioned(
          top: AppPadding.p42_6.h,
          right: 0,
          child: IconButton1(
            onPress: () {
              BlocProvider.of<PayCourseCubit>(context).share(context);
            },
            Width: AppSize.w53_3.r,
            Height: AppSize.h53_3.r,
            ButtonBackground: Colors.transparent,
            BoxShape1: BoxShape.circle,
            Icon: AssetsManager.blackShareIconPath.toString(),
            IconWidth: AppSize.w28_4.r,
            IconHeight: AppSize.h28_4.r,
            IconColor: AppColors.white,
            BorderColor: AppColors.white,
          ),
        ),
        Positioned(
          top: AppPadding.p42_6.h,
          left: 0,
          child: IconButton1(
            onPress: () {
              Navigator.pop(context);
            },
            Width: AppSize.w53_3.r,
            Height: AppSize.h53_3.r,
            ButtonBackground: Colors.transparent,
            BoxShape1: BoxShape.circle,
            Icon: AssetsManager.blackIosArrowLeftIconPath.toString(),
            IconWidth: AppSize.w28_4.r,
            IconHeight: AppSize.h28_4.r,
            IconColor: AppColors.white,
            BorderColor: AppColors.white,
          ),
        ),
      ]),
    );
  }
}
