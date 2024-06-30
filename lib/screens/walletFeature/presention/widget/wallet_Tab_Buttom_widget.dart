import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/tab_bar_widget.dart';
import 'package:grocery_store/widget/tab_button.dart';

walletTabButtom(context,
    {required bool selected,
    double?width,
    required void Function() onPressd,
    required String title}) {
  return TabButton(
    onPress: onPressd,
    Height: AppSize.h53_3.h,
    Width:width?? AppSize.w186_6.w,
    ButtonRadius: AppRadius.r10_6.r,
    ButtonColor: selected ? AppColors.pink2 : Colors.transparent,
    Title: title,
    TextFont: getTranslated(context, "Montserratsemibold"),
    TextSize: AppFontsSizeManager.s21_3.sp,
    TextColor: selected ? AppColors.white : AppColors.darkGrey,
  );
}

class WalletTabBar extends StatelessWidget {
  const WalletTabBar({
    super.key,
    required this.showBalance,
    required this.showHistory,
    required this.onpressedAddBalance,
    required this.onpressedPaymentHistory,
  });

 final bool showBalance;
  final void Function() onpressedAddBalance;
  final void Function() onpressedPaymentHistory;
  final bool showHistory;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: AppSize.h72.h,
        width: AppSize.w506_6.w,
        child: TabBarWidget(
            width: size.width * AppSize.w0_6,
            height: AppSize.w58,
            radius: AppRadius.r16.r,
            buttons: [
              //button x
              walletTabButtom(
                context,
                title: getTranslated(context, "addBalance"),
                selected: showBalance,
                onPressd: onpressedAddBalance
              ),
              Spacer(),
              //button y
              walletTabButtom(
                width: AppSize.w210.w,
                context,
                title: getTranslated(context, "paymentHistory"),
                selected: showHistory,
                onPressd:onpressedPaymentHistory
              ),
            ],
            padding: EdgeInsets.all(AppPadding.p7)),
      ),
    );
  }
}
