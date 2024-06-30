import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/coursePackage.dart';
import 'package:grocery_store/models/courses.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/utils/payment_types.dart';
import 'package:grocery_store/screens/PayCoursesFeature/utils/service/PayCourseCubit/pay_course_cubit.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../../../config/assets_manager.dart';
import '../../../models/promoCode.dart';
import '../../../widget/payment_radio_button.dart';
import '../../CoacheAppoinmentFeature/presention/widget/appointmentDialogwidget/text_dialog.dart';
import '../../walletFeature/utils/custom_widgets_for_payment_sheet.dart';
import '../utils/service/Funcation/check_balance.dart';
import 'widget/payCourseDialogwidget/course_invoice_widget.dart';
import 'widget/payCourseDialogwidget/order_details_widget.dart';

class BuyCouseDialog extends StatefulWidget {
  final GroceryUser loggedUser;
  final Courses course;

  CoursePackage package;
  Function({
    required PaymentTypes paymentType,
    required double totalPrice,
    String? promoCodeId,
  }) getData;
  BuyCouseDialog({
    required this.loggedUser,
    required this.package,
    required this.getData,
    required this.course,
  });

  @override
  _BuyCouseDialogState createState() => _BuyCouseDialogState();
}

class _BuyCouseDialogState extends State<BuyCouseDialog> {
  final TextEditingController controller = TextEditingController();
  String? promoCodeId;
  PromoCode? promo;
  dynamic discount = 0;
  bool valid = false, checkPromo = false, checkValid = true;
  PaymentTypes? paymentType;
  late Size size;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: convertPtToPx(AppSize.w24).w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: convertPtToPx(AppSize.h24).h,
            ),
            orderDetailsWidget(size),
            SizedBox(
              height: convertPtToPx(AppSize.h24).h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      BlocProvider.of<PayCourseCubit>(context).toggilepay();
                    },
                    child: Container(
                      height: convertPtToPx(AppSize.h40).h,
                      width: convertPtToPx(AppSize.h40).h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                            convertPtToPx(AppRadius.r8).r),
                        border: Border.all(
                            color: AppColors.primary2,
                            width: convertPtToPx(AppRadius.r1).r),
                      ),
                      child: Icon(
                        Icons.arrow_back_sharp,
                        size: AppSize.w40.r,
                        color: AppColors.primary2,
                      ),
                    ),
                  ),
                  PrimaryButton(
                    text: getTranslated(context, "payment"),
                    color: AppColors.primary2,
                    width: convertPtToPx(AppSize.w133_3).w,
                    height: convertPtToPx(AppSize.h40).h,
                    buttonRadius: convertPtToPx(AppRadius.r8).r,
                    textSize: AppFontsSizeManager.s21_3.sp,
                    onPress: () async {
                      if (paymentType == null) {
                        customTextDialog(
                            context: context,
                            text: getTranslated(context, 'chosePaymentMethod'),
                            buttonText: getTranslated(context, 'Ok'),
                            okFunction: () {
                              Navigator.pop(context);
                            });
                      } else {
                        widget.getData(
                          paymentType: paymentType!,
                          totalPrice: widget.package.price - ((discount * widget.package.price) / 100),
                          promoCodeId: promoCodeId,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: convertPtToPx(AppSize.h42).h,
            ),
          ],
        ),
      ),
    );
  }

  Widget orderDetailsWidget(Size size) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: convertPtToPx(AppRadius.r16).w,
          vertical: convertPtToPx(AppRadius.r16).h),
      decoration: BoxDecoration(
        color: AppColors.tabBar,
        borderRadius: BorderRadius.circular(convertPtToPx(AppRadius.r12).r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.package.discount == null || widget.package.discount == 0)
            PromoCodeWidget(
              checkValid: checkValid,
              controller: controller,
              discount: discount,
              onChanged: (text) {
                controller.text = text;
               setState(() {
                    promo = null;
                    promoCodeId = "";
                    checkPromo = false;
                    valid = false;
                    discount = 0;
                  }); 
                
              },
              onTap: () {
                calculateDiscount();
              },
            ),
          SizedBox(
            height: convertPtToPx(AppSize.h24).h,
          ),
          CourseInvoiceWidget(
            package: widget.package,
            discount: discount,
          ),
          SizedBox(
            height: convertPtToPx(AppSize.h24).h,
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              getTranslated(context, 'paymentWay'),
              style: TextStyle(
                color: AppColors.pink2,
                fontSize: convertPtToPx(AppFontsSizeManager.s16).sp,
                fontFamily: getTranslated(context, "Ithra"),
                fontWeight: AppFontsWeightManager.semiBold,
              ),
            ),
          ),
          SizedBox(
            height: convertPtToPx(AppSize.h24).h,
          ),
          if (checkBalance(
              package: widget.package,
              price: widget.course.price,
              loggedUser: widget.loggedUser,
              discount: discount))
            PaymentRadioButton(
              icons: [],
              text: getTranslated(context, 'payFromBalance'),
              isSelected: paymentType == PaymentTypes.balance ? true : false,
             endIcon: AssetsManager.walletIcon,
              endIconWidth: AppSize.w32.r,endIconhigh:AppSize.w32.r ,
              endPadding: AppSize.w12.w,paddingstart: AppPadding.p50.w,
              function: () {
                setState(() {
                  paymentType = PaymentTypes.balance;
                });
              },
            ),
            /*    PaymentRadioButton(
              icons: [
                Platform.isAndroid
                    ? AssetsManager.googlePayLogo
                    : AssetsManager.applePayLogo,
                AssetsManager.kareemPaymentLogo,
                AssetsManager.benefitPay,
              ],
              isSelected: paymentType == PaymentTypes.tapCompany ? true : false,
              endIcon: AssetsManager.oTap,
              function: () {
                setState(() {
                  paymentType = PaymentTypes.tapCompany;
                });
              },
            ), */
          PaymentRadioButton(
            icons: [
                Platform.isAndroid
                    ? AssetsManager.googlePayLogo
                    : AssetsManager.applePayLogo,
              AssetsManager.mastercard,
              AssetsManager.visa,
            ],
            withBottomPadding: false,
            isSelected: paymentType == PaymentTypes.stripe ? true : false,
            endIcon: AssetsManager.stripeLogo,
            function: () {
              setState(() {
                paymentType = PaymentTypes.stripe;
              });
            },
          ),
        ],
      ),
    );
  }

  calculateDiscount() async {
    setState(() {
      checkPromo = true;
    });
    if (controller.text != "") {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(Paths.promoPath)
          .where('promoCodeStatus', isEqualTo: true)
          .where('code', isEqualTo: controller.text)
          .limit(1)
          .get();
      var codes = List<PromoCode>.from(
        querySnapshot.docs.map(
          (snapshot) => PromoCode.fromMap(snapshot.data() as Map),
        ),
      );
      if (codes.length > 0) {
        print("promo3");
        print(codes[0].type);
        bool isPrimary = (codes[0].type == "primary" &&
            codes[0].promoCodeStatus &&
            widget.loggedUser.promoList != null &&
            widget.loggedUser.promoList!.contains(codes[0].promoCodeId) ==
                false);
        if ((codes[0].type == "default" && codes[0].promoCodeStatus) ||
            isPrimary) print(isPrimary);
        if ((codes[0].type == "default" && codes[0].promoCodeStatus) ||
            isPrimary)
          setState(() {
            print("valid");
            promo = codes[0];
            promoCodeId = promo!.promoCodeId;
            checkPromo = false;
            valid = true;
            checkValid = true;
            discount = promo!.discount;
            BlocProvider.of<PayCourseCubit>(context).discountt = promo!.discount;
             BlocProvider.of<PayCourseCubit>(context).promoCodeId = promo!.promoCodeId;
          });
        else
          setState(() {
            print("promo4");
            promoCodeId = "";
            checkPromo = false;
            valid = false;
            checkValid = false;
            discount = 0;
            BlocProvider.of<PayCourseCubit>(context).discountt = 0;
             BlocProvider.of<PayCourseCubit>(context).promoCodeId = "";
          });
      } else {
        setState(() {
          print("promo4");
          // promo = null;
          promoCodeId = "";
          checkPromo = false;
          valid = false;
          checkValid = false;
          discount = 0;
           BlocProvider.of<PayCourseCubit>(context).discountt = 0;
             BlocProvider.of<PayCourseCubit>(context).promoCodeId = "";
        });
      }
    }
  }
}
