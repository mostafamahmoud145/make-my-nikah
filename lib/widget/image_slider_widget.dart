import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../config/app_values.dart';
import '../config/colorsFile.dart';
import '../models/banner.dart';
import '../screens/YoutubePlayerDemoScreen.dart';

class ImageSliderWidget extends StatefulWidget {
   List<banner> AcademyBannerList;
   ImageSliderWidget({super.key, required this.AcademyBannerList});

  @override
  State<ImageSliderWidget> createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.AcademyBannerList.length==0?SizedBox( 
      width: AppSize.w506_6.w,
      height: AppSize.h196.h,child: Center(child: CircularProgressIndicator(),),):
    Container(
      width: AppSize.w506_6.w,
      height: AppSize.h180.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r32.r),
      ),
      child: ImageSlideshow(
        initialPage: 0,
        indicatorColor: Colors.transparent,
        indicatorBackgroundColor: Colors.transparent,
        onPageChanged: (value) {},
        autoPlayInterval: 4000,
        isLoop: true,
        children: [
          for (var slideUser in widget.AcademyBannerList)
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        YoutubePlayerDemoScreen(
                          link: slideUser.link.toString(),
                          desc: "",
                        ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: slideUser.image.toString(),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(
                        AppColors.white,
                        BlendMode.colorBurn,
                      ),
                    ),
                  ),
                ),
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/icons/icon/load.gif',
                  width: 80.w,
                  height: 80.h,
                  //fit: BoxFit.fill,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
