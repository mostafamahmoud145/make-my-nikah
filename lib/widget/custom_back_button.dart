import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';

class CustomBackButton extends StatefulWidget {
   CustomBackButton({super.key,this.onPress,});
   final Function() ?onPress;

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  String lang = '';
  navigation(){
    Navigator.pop(context);
  }

   @override
  Widget build(BuildContext context) {
    lang = getTranslated(context, "lang");
    return InkWell(
      onTap:widget.onPress??navigation,

      child: Container(
        width: AppSize.w53.r,
        height: AppSize.h53.r,
        decoration: BoxDecoration(
          border: Border.all(
            width: AppSize.w1,
            color: AppColors.lightGray,
          ),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: widget.onPress??navigation,
          icon:lang == "ar"? RotationTransition(
           turns:  new AlwaysStoppedAnimation(
                180 / 360),
            child: SvgPicture.asset(
              AssetsManager.customBackIcon,
              width: AppSize.w32.r,
              height: AppSize.h32.r,
              //fit: BoxFit.cover,
            ),
          ): SvgPicture.asset(
            AssetsManager.customBackIcon,
            width: AppSize.w32.r,
            height: AppSize.h32.r,
            //fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
