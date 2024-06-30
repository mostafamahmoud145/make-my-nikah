import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/config/app_constat.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/add_promo_code.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/coache_profile_view.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/utils/service/CoachAppointmentCubit/coach_appointment_cubit.dart';
import 'package:grocery_store/screens/coachDetailScreen.dart';
import 'package:grocery_store/widget/TextButton.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import '../screens/consultantDetailsScreen.dart';

class CoachListItem extends StatefulWidget {
  final GroceryUser? loggedUser;
  final GroceryUser consult;

  CoachListItem({required this.consult, this.loggedUser});

  @override
  _CoachListItemState createState() => _CoachListItemState();
}

class _CoachListItemState extends State<CoachListItem>
    with SingleTickerProviderStateMixin {
  bool sharing = false;
  String orderNum = "0";
  String  lang  = "";

  @override
  void initState() {
    if (widget.consult.ordersNumbers! < 100)
      orderNum = widget.consult.ordersNumbers.toString();
    else
      for (int x = 2; x < 1000000; x++) {
        if (widget.consult.ordersNumbers! < x * 100) {
          orderNum = ((x - 1) * 100).toString() + "+";
          break;
        }
      }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    lang  = getTranslated(context, "lang");
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r21_3.r),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(48, 48, 48, 0.08),
            blurRadius: 18.0,
            spreadRadius: 0.0,
            offset: Offset(0, 6.0), // shadow direction: bottom right
          )
        ],
      ),
      padding: EdgeInsets.only(
          top: AppPadding.p21_3.r,
          left: AppPadding.p21_3.r,
          right: AppPadding.p21_3.r),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.consult.price.toString() + "\$",
                style: TextStyle(
                  fontFamily: getTranslated(context, "Montserratsemibold"),
                  fontWeight: FontWeight.bold,
                  color: AppColors.pink2,
                  fontSize: AppFontsSizeManager.s18_6.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: AppPadding.p25.h),
                child: Container(
                  height: AppSize.h70.r,
                  width: AppSize.w70.r,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromRGBO(32, 32, 32, 1), width: .8),
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                  child: widget.consult.photoUrl!.isEmpty
                      ? Image.asset(
                          'assets/icons/icon/load.gif',
                          height: AppSize.h70.r,
                          width: AppSize.w70.r,
                          fit: BoxFit.cover,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/icons/icon/load.gif',
                            placeholderScale: 0.5,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                Image.asset('assets/icons/icon/load.gif',
                                    height: AppSize.h70.r,
                                    width: AppSize.w70.r,
                                    fit: BoxFit.cover),
                            image: widget.consult.photoUrl!,
                            fit: BoxFit.cover,
                            fadeInDuration: Duration(milliseconds: 250),
                            fadeInCurve: Curves.easeInOut,
                            fadeOutDuration: Duration(milliseconds: 150),
                            fadeOutCurve: Curves.easeInOut,
                          ),
                        ),
                ),
              ),
              InkWell(
                onTap: () async {
                  share(context);
                },
                child: sharing
                    ? Center(child: CircularProgressIndicator())
                    : SvgPicture.asset(
                        AssetsManager.redShareIconPath,
                        width: AppSize.w17.w,
                        height: AppSize.h19_3.h,
                        //fit: BoxFit.fill,
                      ),
                /* Icon(
                  Icons.share_outlined,
                  color: Color.fromRGBO(224, 87 ,123,1),
                  size: 13.0,
                ),*/
              ),
            ],
          ),
          SizedBox(
            height: AppSize.h5_3.h,
          ),
          Text(
            widget.consult.name!,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                fontFamily: getTranslated(context, "Montserratsemibold"),
                color: AppColors.black,
                fontSize: AppFontsSizeManager.s18_6.sp,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: AppSize.h32_6.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Color.fromRGBO(255, 213, 8, 1),
                    size: AppSize.w16.r,
                  ),
                  SizedBox(
                    width: AppSize.w5_3.w,
                  ),
                  Text(
                    widget.consult.rating.toString(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: AppFontsSizeManager.s16.sp,
                      fontFamily: getTranslated(context, "Montserratmedium"),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: AppSize.w42_6.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AssetsManager.redCall3IconPath,
                    width: AppSize.w16.w,
                    height: AppSize.h16.h,
                    //fit: BoxFit.fill,
                  ),
                  SizedBox(
                    width: AppSize.w5_3.w,
                  ),
                  Text(
                    orderNum,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: AppFontsSizeManager.s16.sp,
                      fontFamily: getTranslated(context, "Montserratmedium"),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: AppSize.h21_3.h,
          ),
          /* SizedBox(height: 3,),*/
          /*Icon(
            Icons.mic,
            color: Color.fromRGBO(32, 32, 32,.8),
            size: 12.0,
          ),*/
          /*SizedBox(height: 1,),*/
          /* widget.consult.languages!.length > 1
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              langWidget(widget.consult.languages![0]),
              SizedBox(
                width:10,
              ),
              langWidget(widget.consult.languages![1])
            ],
          )
              : langWidget(widget.consult.languages![0]),*/

          TextButton1(
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // CoachDetailScreen
                  builder: (context) => 
                  // AddPromoCodeScreen()
                   CoachProfileView(
                       consultant: widget.consult,
                       loggedUser: widget.loggedUser),
                ),
              );
            },
            Title: getTranslated(context, "viewProfTxt"),
            ButtonRadius: AppRadius.r5_3.r,
            Width:lang == "ar"?AppSize.w166_1.w :AppSize.w146_6.w,
            Height: AppSize.h37_3.h,
            TextSize: AppFontsSizeManager.s16.sp,
            TextFont: getTranslated(context, "Montserratsemibold"),
            TextColor: AppColors.white,
            ButtonBackground: AppColors.black,
          ),
          /*Container(
            padding: EdgeInsets.only(top: 5,bottom: 5,right: 30,left: 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
               color: Color.fromRGBO(32, 32,32,1),),
            child:  Text(
                getTranslated(context, "callNow"),
                style: TextStyle(
                  fontFamily: getTranslated(context, "fontFamily"),
                  color:Colors.white,
                  fontSize: 9.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ),*/
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
    print("https://makemynikahapp\.page\.link/.*coach_id=" + uid);
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://makemynikahapp\.page\.link/coach_id=" + uid),
      uriPrefix: "https://makemynikahapp\.page\.link",
      androidParameters:
          const AndroidParameters(packageName: "com.app.MakeMyNikah"),
      iosParameters: const IOSParameters(
          bundleId: "com.app.MakeMyNikahApp", appStoreId: "1668556326"),
    );
    ShortDynamicLink dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    File file;
    if (widget.consult.photoUrl!.isEmpty) {
      print("share5");
      final bytes =
          await rootBundle.load('assets/icons/icon/Mask Group 47.png');
      final list = bytes.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      file = await File('${tempDir.path}/image.jpg').create();
      file.writeAsBytesSync(list);
      print("share6");
    } else {
      final directory = await getTemporaryDirectory();
      final path = directory.path;
      final response = await http.get(Uri.parse(widget.consult.photoUrl!));
      file =
          await File('$path/image_${DateTime.now().millisecondsSinceEpoch}.png')
              .writeAsBytes(response.bodyBytes);
    }
    String text =
        "${widget.consult.name} \n I think that he is a good coach \n ${dynamicLink.shortUrl.toString()}";
    Share.shareFiles(["${file.path}"], text: text);
    setState(() {
      sharing = false;
    });
  }

  Widget langWidget(String langText) {
    return Text(
      getTranslated(context, langText),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: getTranslated(context, "fontFamily"),
        color: Color.fromRGBO(158, 158, 158, 1),
        fontSize: 10.0,
      ),
    );
  }
}
