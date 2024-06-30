
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/blocs/notification_bloc/notification_bloc.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user_notification.dart';
import 'package:grocery_store/widget/app_bar_widget.dart';
import 'package:grocery_store/widget/nikah_dialog.dart';
import 'package:grocery_store/widget/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../config/app_fonts.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../models/user_notification.dart' as prefix;
import '../widget/IconButton.dart';

class NotificationScreen extends StatefulWidget {
  final UserNotification? userNotification;

  const NotificationScreen({Key? key, this.userNotification}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late NotificationBloc notificationBloc;
  bool isLoading = true, deleting = false;
  String lang = "";

  @override
  void initState() {
    super.initState();
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    lang = getTranslated(context, "lang");

    List<prefix.Notification> notificationList =
        widget.userNotification?.notifications?.reversed.toList() ?? [];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
                width: size.width,
                child: Padding(
                    padding:  EdgeInsets.only(
                  bottom: AppPadding.p21_3.h, 
                 ),
                  ///--App Bar Widget--///
                  child: AppBarWidget2(
                text: getTranslated(context, "notification"),
                                ),
                              )
            ),
            Center(
                child: Container(
                    color: AppColors.white3,
                    height: AppSize.h1.h,
                    width: size.width)),
            SizedBox(
              height: AppSize.h33_3.h,
            ),
            notificationList.length == 0
                ? 
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getTranslated(context, "noNotification"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.grey2,
                            fontFamily:
                            getTranslated(context, "Montserratmedium"),
                            fontSize: AppFontsSizeManager.s32.sp),
                      ),
                      SizedBox(
                        height: AppSize.h32.h,
                      ),
                      SvgPicture.asset(
                        AssetsManager.notificationIcon,
                        width: AppSize.w58_6.w,
                        height: AppSize.h68.h,
                      ),
                    ],
                  ),
                )
                :
            Expanded(
              child: Column(children: [  Padding(
                padding:  EdgeInsets. symmetric(horizontal:AppPadding.p32.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        getTranslated(context, "removeAll"),
                        // '${notificationList[index].notificationTitle}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: getTranslated(context, "Montserratsemibold"),
                          fontSize: AppFontsSizeManager.s21_3.sp,
                          color: AppColors.black1,
                          fontWeight: FontWeight.w600,),
                      ),
                    ),
                      
                    InkWell(
                      onTap: (){
                        showDeleteConfimationDialog(size);
                        setState(() {
                        });
                      },
                      child: SvgPicture.asset(
                          AssetsManager.outlineDeleteIconPath,
                          width: AppSize.w32.r,
                          height: AppSize.h32.r),
                    ),
                  ],
                ),
              ),
                Expanded(
                  child: ListView.separated(
                    padding:  EdgeInsets.symmetric(
                      vertical: AppSize.h42_6.h,
                    ),
                    itemBuilder: (context, index) {
                      //   final item = notificationList[index].notificationId;
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          setState(() {
                            widget.userNotification!.notifications!
                                .removeAt(index);
                          });
                        },
                        background: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                  AssetsManager.outlineDeleteIconPath,
                                  width: AppSize.w32.w,
                                  height: AppSize.h32.h),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding:  EdgeInsets. symmetric(horizontal:AppPadding.p32.w),
                          child: NotificationItem(
                            size: size,
                            userNotification: widget.userNotification!,
                            notificationList: notificationList,
                            index: index,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox( height: AppSize.h32.h);
                    },
                    itemCount: notificationList.length,
                  ),
                ),],),
            ),
          ],
        ),
      ),
    );
  }

  showDeleteConfimationDialog(Size size) {
    return showDialog(
      builder: (context) => NikahDialogWidget(
        padButtom: AppPadding.p48.h,
        padLeft: AppPadding.p26_6.w,
        padReight: AppPadding.p26_6.w,
        padTop:AppPadding.p26_6.h,
        radius: AppRadius.r21_3.r,
        dialogContent: Container(
          width: AppSize.w400.w,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      AssetsManager.redCancelIconPath
                      ),
                  ),
                ],
              ),
              SizedBox(
                height: AppSize.h32.h,
              ),
              Text(
                getTranslated(context, "deleteNotificationMessage"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  height:lang=="ar"? AppSize.h2.h:null,
                    fontFamily: getTranslated(context, "Montserratmedium"),
                    fontSize:AppFontsSizeManager.s24.sp,
                    color: Colors.black87,
                    fontWeight: lang=="ar"?
                    AppFontsWeightManager.semiBold
                    :null),
              ),
              SizedBox(
                height:AppSize.h42_6.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.p13_3.w
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    deleting
                        ? CircularProgressIndicator()
                        : Container(
                      width: AppSize.w160.w,
                      height:AppSize.h52.h ,
                      decoration: BoxDecoration(
                        color: AppColors.pink2,
                        borderRadius:
                         BorderRadius.circular(AppRadius.r5_3.r),
                      ),
                      child: InkWell(
                       
                        onTap: () async {
                          setState(() {
                            deleting = true;
                          });
                          String userUid =
                              FirebaseAuth.instance.currentUser!.uid;
                          FirebaseFirestore.instance
                              .collection('UserNotifications')
                              .doc(userUid)
                              .delete();
                          notificationBloc
                              .add(GetAllNotificationsEvent(userUid));
                
                          //FirebaseAuth.instance.signOut();
                          setState(() {
                            deleting = false;
                          });
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            getTranslated(context, 'delete'),
                            style: TextStyle(
                              fontFamily: getTranslated(context, "Montserratmedium"),
                              fontSize: AppFontsSizeManager.s21_3.sp,
                              color: AppColors.white,
                              fontWeight:lang=="ar"?
                               AppFontsWeightManager.semiBold
                               :null
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: AppSize.w53_3.w,
                    ),
                    Container(
                      width: AppSize.w160.w,
                      height:AppSize.h52.h ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
                        border: Border.all(
                            color: AppColors.reddark2
                        ),
                      ),
                      child: MaterialButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          getTranslated(context, 'cancel'),
                          style: TextStyle(
                            fontFamily: getTranslated(context, "Montserratmedium"),
                            fontSize: AppFontsSizeManager.s21_3.sp,
                            color: AppColors.reddark2,
                            fontWeight: lang=="ar"?
                             AppFontsWeightManager.semiBold
                             :null
                            
                          ),
                        ),
                      ),
                    ),
                
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }
}
