import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/google_apple_signup/view_model/setting_cubit/setting_cubit.dart';
import 'package:grocery_store/widget/app_bar_widget.dart';
import 'package:grocery_store/widget/seeting_header_widget.dart';
import 'package:grocery_store/widget/setting_widget/permission_widget.dart';
import 'package:grocery_store/widget/setting_widget/request_all_permission_widget.dart';


class SettingPage extends StatefulWidget {
  const SettingPage( {Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late SettingCubit settingCubit;
  bool googleProvider = false, appleProvider = false;
  late List<UserInfo> providers;

  @override
  void initState() {
    super.initState();
    settingCubit = BlocProvider.of<SettingCubit>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      providers = await FirebaseAuth.instance.currentUser!.providerData;
      googleProvider =
          providers.any((provider) => provider.providerId == "google.com");
      appleProvider =
          providers.any((provider) => provider.providerId == "apple.com");
      setState(() {});
    });
    settingCubit.CheckAllPermission();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          body: SafeArea(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppBarWidget2(text: getTranslated(context, "settings"),),
                    Padding(
                      padding: EdgeInsets.only(
                          right: AppPadding.p21_3.w,
                          left: AppPadding.p21_3.w,
                          top: AppPadding.p21_3.h,
                          bottom: AppPadding.p32.h),
                      child: Divider(
                        color: AppColors.lightGrey,
                        thickness: AppSize.h1_5.h,
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: AppPadding.p32.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RequestAllPermissionWidget(),
                          Padding(
                            padding: EdgeInsets.only(top: AppPadding.p32.h),
                            child: Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: AppColors.otherChat,
                                  borderRadius:
                                  BorderRadius.circular(AppRadius.r16.r)),
                              child: Column(
                                children: [
                                  PermissionWidget(
                                    icon: AssetsManager.micIcon,
                                    title: "microphone",
                                    condition: settingCubit.microphone,
                                    function: () => settingCubit
                                        .RequestMicrophonePermission(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppPadding.p21_3.w),
                                    child: Divider(
                                      thickness: AppSize.h1_3.h,
                                      color: AppColors.lightGrey,
                                    ),
                                  ),
                                  PermissionWidget(
                                    icon: AssetsManager.videoIcon,
                                    title: "from_camera",
                                    condition: settingCubit.camera,
                                    function: () =>
                                        settingCubit.RequestCameraPermission(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppPadding.p21_3.w),
                                    child: Divider(
                                      thickness: AppSize.h1_3.h,
                                      color: AppColors.lightGrey,
                                    ),
                                  ),
                                  PermissionWidget(
                                    icon: AssetsManager.notification,
                                    title: "notification",
                                    condition: settingCubit.notification,
                                    function: () => settingCubit
                                        .RequestNotificationPermission(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: AppSize.h42_6.h,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        );
      },
    );
  }
}
