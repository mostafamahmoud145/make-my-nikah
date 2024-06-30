import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/GirlAppointmentFeature/presention/girl_details_view.dart';
import 'package:grocery_store/widget/IconButton.dart';
import 'package:grocery_store/widget/TextButton.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';

import '../config/app_values.dart';
import '../config/paths.dart';

class ConsultantListItem extends StatefulWidget {
  final GroceryUser? loggedUser;
  final GroceryUser consult;
  final Size size;
  final bool inAppleReview;

  ConsultantListItem(
      {required this.consult,
      required this.loggedUser,
      required this.size,
      required this.inAppleReview});

  @override
  _ConsultantListItemState createState() => _ConsultantListItemState();
}

class _ConsultantListItemState extends State<ConsultantListItem>
    with SingleTickerProviderStateMixin {
  bool fav = false, sharing = false;
  String lang = "";

  @override
  Widget build(BuildContext context) {
    lang = getTranslated(context, "lang");
    return Container(
      padding: EdgeInsets.only(bottom:AppPadding.p21_3.h,top:AppPadding.p21_3.h),
      width: AppSize.w453_3.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r42_6.r),
        border: Border.all(
          color: AppColors.cherry,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyShadowColor,
            blurRadius: 21,
            spreadRadius: 0.0,
            offset: Offset(0.0, 4.0), // shadow direction: bottom right
          )
        ],
      ),
         child: Column(
           mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  lang == "ar"
                      ? SvgPicture.asset(
                          AssetsManager.goldFlower2IconPath,
                          width: AppSize.w32.w,
                          height: AppSize.h17_8.h,
                        )
                      : SvgPicture.asset(
                          AssetsManager.goldFlower1IconPath,
                          width: AppSize.w32.w,
                          height: AppSize.h17_8.h,
                        ),
                  SizedBox(
                    width: AppSize.w10_6,
                  ),
                  Text(
                    StringUtils.capitalize(widget.consult.name!),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily:
                          getTranslated(context, "Montserratsemibold"),
                      fontWeight: FontWeight.normal,
                      color: AppColors.pink2,
                      fontSize: AppFontsSizeManager.s26_6.sp,
                    ),
                  ),
                  SizedBox(
                    width: AppSize.w10_6,
                  ),
                  lang == "ar"
                      ? SvgPicture.asset(
                          AssetsManager.goldFlower1IconPath,
                          width: AppSize.w32.w,
                          height: AppSize.h17_8.h,
                        )
                      : SvgPicture.asset(
                          AssetsManager.goldFlower2IconPath,
                          width: AppSize.w32.w,
                          height: AppSize.h17_8.h,
                        ),
                ],
              ),
              SizedBox(
                height: AppSize.h16.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AssetsManager.goldLocationIconPath,
                      width: AppSize.w21_3.r,
                      height: AppSize.h21_3.r,
                      color: AppColors.pink2),
                  SizedBox(
                    width: AppSize.w10_6.w,
                  ),
                  Flexible(
                    child: Text(
                      widget.consult.country!,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily:
                            getTranslated(context, "Montserratmedium"),
                        color: AppColors.black,
                        fontSize: AppFontsSizeManager.s18_6.sp,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: AppPadding.p10_6.h, bottom: AppPadding.p10_6.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // favWidget(),*/
                    IconButton1(
                        onPress: () async {
                          try {
                            if (widget.loggedUser != null) {
                              setState(() {
                                fav = true;
                              });
                              if (widget.loggedUser!.wishlist!
                                  .contains(widget.consult.uid))
                                setState(() {
                                  widget.loggedUser!.wishlist!.removeWhere(
                                      (element) =>
                                          element == (widget.consult.uid));
                                  widget.consult.wishlist!.removeWhere(
                                      (element) =>
                                          element ==
                                          (widget.loggedUser!.uid));
                                });
                              else
                                setState(() {
                                  widget.loggedUser!.wishlist!
                                      .add(widget.consult.uid!);
                                  widget.consult.wishlist == null
                                      ? widget.consult.wishlist = [
                                          widget.loggedUser!.uid!
                                        ]
                                      : widget.consult.wishlist!
                                          .add(widget.loggedUser!.uid!);
                                });
                              await FirebaseFirestore.instance
                                  .collection(Paths.usersPath)
                                  .doc(widget.loggedUser!.uid)
                                  .update({
                                'wishlist': widget.loggedUser!.wishlist
                              });
                              await FirebaseFirestore.instance
                                  .collection(Paths.usersPath)
                                  .doc(widget.consult.uid)
                                  .update(
                                      {'wishlist': widget.consult.wishlist});
                              setState(() {
                                fav = false;
                              });
                              Fluttertoast.showToast(
                                  msg: getTranslated(
                                      context,
                                      widget.loggedUser!.wishlist!
                                              .contains(widget.consult.uid)
                                          ? "favoritesAdd"
                                          : "favoritesRemoved"),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: widget
                                          .loggedUser!.wishlist!
                                          .contains(widget.consult.uid)
                                      ? AppColors.green
                                      : Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              Navigator.pushNamed(context, '/Register_Type');
                            }
                          } catch (e) {
                            print("ggg12345555" + e.toString());
                            setState(() {
                              fav = false;
                            });
                          }
                        },
                        Width: AppSize.w50_6.w,
                        Height: AppSize.h50_6.h,
                        ButtonBackground: AppColors.white,
                        Icon: AssetsManager.redHeartIconPath.toString(),
                        borderWidth: 0,
                        BorderColor: AppColors.white,
                        IconWidth: AppSize.w23_1.w,
                        IconHeight: AppSize.h20_2.h,
                        IconColor: widget.loggedUser == null
                            ? AppColors.lightGrey6
                            : widget.loggedUser!.wishlist!
                                    .contains(widget.consult.uid)
                                ? AppColors.pink2
                                : AppColors.lightGrey6),
                    SizedBox(
                      width: AppSize.w25_3.w,
                    ),
                    /*shareWidget(),*/
                    IconButton1(
                      onPress: () async {
                        share(context);
                      },
                      Width: AppSize.w50_6.w,
                      Height: AppSize.h50_6.h,
                      ButtonBackground: AppColors.white,
                      Icon: AssetsManager.redShareIconPath.toString(),
                      IconWidth: AppSize.w18_6.w,
                      IconHeight: AppSize.h20_7.h,
                      IconColor: AppColors.pink2,
                      borderWidth: 0,
                      BorderColor: AppColors.white,
                    ),
                  ],
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: AppPadding.p10_6.h),
                      child: Text(
                        getTranslated(context, "specifications"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily:
                              getTranslated(context, "Montserratsemibold"),
                          color: AppColors.black,
                          fontSize: AppFontsSizeManager.s21_3.sp,
                        ),
                      ),
                    ),
                  ]),
              Container(
                color: AppColors.pink2,
                width: AppSize.w85_3.w,
                height: AppSize.h2_6.h,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: AppPadding.p22_6.h,
                    left:AppPadding.p26_6.w,
                    right:AppPadding.p26_6.w,
                    bottom: AppPadding.p21_3.h),
                child: Wrap(
                    alignment: WrapAlignment.start,
                    runSpacing: AppSize.h16.h,
                    spacing: AppSize.w18_6.w,
                    direction: Axis.horizontal,
                    children: [
                      cell(widget.size,
                          getTranslated(context, widget.consult.origin!)),
                      cell(
                          widget.size,
                          getTranslated(
                              context, widget.consult.employment!)),
                      cell(
                          widget.size,
                          widget.consult.age.toString() +
                              getTranslated(context, "years")),
                      cell(widget.size,
                          getTranslated(context, widget.consult.doctrine!)),
                      cell(widget.size,
                          widget.consult.weight.toString() + " Kg"),
                      cell(widget.size,
                          widget.consult.length.toString() + " Cm"),
                      cell(widget.size,
                          getTranslated(context, widget.consult.color!)),
                      cell(
                          widget.size,
                          getTranslated(
                              context, widget.consult.maritalStatus!)),
                      cell(widget.size,
                          getTranslated(context, widget.consult.smooking!)),
                      cell(
                          widget.size,
                          getTranslated(
                                      context, widget.consult.marriage!) ==
                                  null
                              ? widget.consult.marriage
                              : getTranslated(
                                  context, widget.consult.marriage!)),
                      cell(
                          widget.size,
                          getTranslated(
                              context, widget.consult.education!)),
                      cell(
                          widget.size,
                          getTranslated(context,
                                      widget.consult.specialization!) ==
                                  null
                              ? widget.consult.specialization
                              : getTranslated(
                                  context, widget.consult.specialization!)),
                      cell(
                          widget.size,
                          widget.consult.childrenNum! > 0
                              ? widget.consult.childrenNum.toString() +
                                  getTranslated(context, "child")
                              : getTranslated(
                                  context, "don’tHaveChildren")),
                      cell(widget.size,
                          getTranslated(context, widget.consult.hijab!)),
                      cell(widget.size,
                          getTranslated(context, widget.consult.living!)),
                    ]),
              ),
              TextButton1(
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //  ConsultantDetailsScreen
                        builder: (context) => GirlDetailsView(
                          consultant: widget.consult,
                          loggedUser: widget.loggedUser,
                          appleReview: widget.inAppleReview,
                        ),
                      ),
                    );
                  },
                  Width: AppSize.w196_6.w,
                  Height: AppSize.h50_6.h,
                  Title: getTranslated(context, "ViewProfile"),
                  ButtonRadius: AppRadius.r10_6.r,
                  TextSize: AppFontsSizeManager.s18_6.sp,
                  GradientColor: AppColors.GradientColor1,
                  GradientColor2: AppColors.GradientColor2,
                  Begin: Alignment.centerRight,
                  End: Alignment.centerLeft,
                  TextFont: getTranslated(context, "Montserratsemibold"),
                  TextColor: AppColors.white),

            ],
          ),
    );
  }

  share(BuildContext context) async {
    setState(() {
      sharing = true;
    });
    String uid = widget.consult.uid!;
    // Create DynamicLink
    print("share1");
    print("https://makemynikahapp\.page\.link/.*consultant_id=" + uid);
    final dynamicLinkParams = DynamicLinkParameters(
      link:
          Uri.parse("https://makemynikahapp\.page\.link/consultant_id=" + uid),
      uriPrefix: "https://makemynikahapp\.page\.link",
      androidParameters:
          const AndroidParameters(packageName: "com.app.MakeMyNikah"),
      iosParameters: const IOSParameters(
          bundleId: "com.app.MakeMyNikah", appStoreId: "1665532757"),
    );
    ShortDynamicLink dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    File file;

    final bytes = await rootBundle.load('assets/icons/icon/Mask Group 47.png');
    final list = bytes.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    file = await File('${tempDir.path}/image.jpg').create();
    file.writeAsBytesSync(list);
    String text =
        "${widget.consult.name} \n I think that she will be a good wife for you \n ${dynamicLink.shortUrl.toString()}";
    if (widget.inAppleReview)
      text =
          "${widget.consult.name} \n I think that she will be a good wife for you \n ${dynamicLink.shortUrl.toString()}";
    Share.shareFiles(["${file.path}"], text: text);
    setState(() {
      sharing = false;
    });
  }

  Widget cell(Size size, String name) {
    try {
      print("ggggggggggggggg");
      print(name);
      var cellWidth = (size.width) / 10;
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: cellWidth),
        child: Container(
            height: AppSize.h35.h, //AppSize.h38_6.h,

            padding: EdgeInsets.only(
              left: AppPadding.p24.w,
              right: AppPadding.p24.w,
              top: AppPadding.p9_3.h,
              bottom: AppPadding.p8.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(
                  AssetsManager.borderIcon,
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: Text(
              name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 1,
              style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: AppFontsSizeManager.s16.sp,
                  fontFamily: getTranslated(context, "Montserrat")),
            )),
      );
    } catch (e) {
      print("eeeeeeeee" + e.toString());
      print(name);
      return SizedBox();
    }
  }
}
