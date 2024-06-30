import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/config/app_constat.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../../../../../config/colorsFile.dart';

class PromoCodeWidget extends StatelessWidget {
  final discount;
  final Function(String)? onChanged;
   final TextEditingController controller;
  final void Function()? onTap;
  final bool checkValid;
  const PromoCodeWidget({
    super.key,
    required this.discount,
    required this.onChanged,
    required this.onTap,
    required this.checkValid, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    //final TextEditingController controller = TextEditingController();
    final lang = getTranslated(context, "lang");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: convertPtToPx(AppRadius.r8).w,
            vertical: convertPtToPx(AppRadius.r8).h,
          ),
          height: convertPtToPx(AppSize.h52).h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x1cae9cce),
                  offset: Offset(0, 3),
                  blurRadius: 11,
                  spreadRadius: 0)
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                    padding: EdgeInsets.only(top: AppSize.h9_3.h),
                    child: SvgPicture.asset(AssetsManager.promoCodeIcon, color: AppColors.pink2)),
              ),
              SizedBox(
                width: AppSize.w16.w,
              ),
              Expanded(
                child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.start,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    enableInteractiveSelection: true,
                    style: TextStyle(
                      fontFamily: getTranslated(context, "Montserratmedium"),
                      fontSize: convertPtToPx(AppFontsSizeManager.s14).sp,
                      color:  AppColors.pink2,
                      letterSpacing: AppConstants.letterSpacing0_5,
                      fontWeight: AppFontsWeightManager.regular,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: getTranslated(context, "enterPromoCode"),
                      hintStyle: TextStyle(
                        height:lang!="ar"? AppSize.h2_15.h:null,
                        fontFamily: getTranslated(context, "Montserratmedium"),
                        fontStyle: FontStyle.normal,
                        fontSize: lang == "ar"
                            ? convertPtToPx(AppFontsSizeManager.s14).sp
                            : convertPtToPx(AppFontsSizeManager.s12_5).sp,
                        color:  AppColors.pink2,
                      ),
                      counterStyle: TextStyle(
                        fontFamily: getTranslated(context, "Montserratmedium"),
                        fontSize: lang == "ar"
                            ? convertPtToPx(AppFontsSizeManager.s14).sp
                            : convertPtToPx(AppFontsSizeManager.s12).sp,
                        color:  AppColors.pink2,
                        fontWeight: AppFontsWeightManager.regular,
                      ),
                    ),
                    onChanged: onChanged),
              ),
              InkWell(
                onTap: onTap,
                //  () {
                //   calculateDiscount();
                // },
                child: Container(
                  alignment: Alignment.center,
                  width: getTranslated(context, "lang") == "fr"
                      ? convertPtToPx(AppSize.w133_3).w
                      : convertPtToPx(AppSize.w158).w,
                  height: convertPtToPx(AppSize.h32).h,
                  decoration: BoxDecoration(
                      color: discount > 0 ?  Color.fromRGBO(18, 233, 95, 0.08): AppColors.pink2,
                      borderRadius: BorderRadius.circular(AppRadius.r5_3.r)),
                  child: Text(
                    discount > 0
                        ? getTranslated(context, "activated")
                        : getTranslated(context, "activate"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: getTranslated(context, 'Montserratsemibold'),
                      color:
                          discount > 0 ?  AppColors.Accentgreen3 : AppColors.white,
                      fontSize: convertPtToPx(AppFontsSizeManager.s14).sp,
                      fontWeight: AppFontsWeightManager.semiBold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: convertPtToPx(AppSize.h12).h),
          child: Text(
            checkValid == true
                ? getTranslated(context, "proText") +
                    ' ' +
                    '${discount > 0 ? (discount.toString() + "%") : ''}'
                : getTranslated(context, "wrongepromo"),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: TextStyle(
              //fontWeight: AppFontsWeightManager.bold300,
              fontFamily: getTranslated(context, "Montserratmedium"),
              fontStyle: FontStyle.normal,
              fontSize: AppFontsSizeManager.s16.sp,
              color: AppColors.grey6,
            ),
          ),
        ),
      ],
    );
  }
}
