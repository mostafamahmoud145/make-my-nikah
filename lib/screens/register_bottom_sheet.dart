import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../config/colorsFile.dart';
import '../localization/localization_methods.dart';

class RegisterBottomSheet extends StatefulWidget {
  const RegisterBottomSheet({super.key});

  @override
  State<RegisterBottomSheet> createState() => _RegisterBottomSheetState();
}

class _RegisterBottomSheetState extends State<RegisterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.r60.r)
                  ,topRight: Radius.circular(AppRadius.r60.r)),
              ),
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: AppPadding.p32.h,
                    bottom: AppPadding.p46_6.h
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: AppSize.w117_3.w,
                        height: AppSize.h5_3.h,
                        color:AppColors.darkGrey1

                      ),
                  
                      SizedBox(
                        height: AppSize.h45_3.h,
                      ),
                      Text(
                        getTranslated(context, "wantRegister"),
                        style: TextStyle(
                            fontSize: AppFontsSizeManager.s30.sp,
                          color: AppColors.black,
                          fontFamily: getTranslated(
                            context,
                            "Montserratsemibold",
                          ),
                        ),
                  
                  
                      ),
                      SizedBox(
                        height: AppSize.h53_3.h,
                      ),
                      Expanded(child: RegisterItemListView()),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();                   },
                        child: Container(
                           decoration: BoxDecoration(
                            color: AppColors.pink2,
                        borderRadius: 
                        BorderRadius.circular(AppRadius.r16.r)
                      ),
                      width: AppSize.w454_6.w,
                      height: AppSize.h66_6.h,
                          child: Center(
                            child: Text(
                                getTranslated(context, "continue"),
                              style: TextStyle(
                                fontFamily: getTranslated(
                                  context,
                                  "Montserratsemibold",
                                ),
                                fontSize: AppFontsSizeManager.s24.sp,
                                color: AppColors.white,
                                              
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Text('Open BottomSheet'),
        ),
      ),
    );
  }
}
class RegisterItem extends StatelessWidget {
  String registerText;
  bool isSelected = false;

  RegisterItem({super.key,
  required this.registerText,
  required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.symmetric(horizontal:AppPadding.p56.r ),
      child: Container(
        width: AppSize.w460.w,
        height: AppSize.h64.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
          border: Border.all(
            color: isSelected ?
             AppColors.pink2:
             AppColors.darkGrey,
            width: AppSize.w1_5.w,
          ),
        ),
        child: Center(
          child: Text(
            registerText,
            style: TextStyle(
              fontFamily: getTranslated(
                context,
                "Montserratmedium",
              ),
              fontSize: AppFontsSizeManager.s24.sp,
              color:  isSelected ?
             AppColors.pink2:
             AppColors.darkGrey,
            ),
          ),
        ),
      ),
    );
  }
}
class RegisterItemListView extends StatefulWidget {
  const RegisterItemListView({super.key});

  @override
  State<RegisterItemListView> createState() => _RegisterItemListViewState();
}

class _RegisterItemListViewState extends State<RegisterItemListView> {
  
  int? select ;
  @override
  Widget build(BuildContext context) {
    List<String> registerTextItem  = [
    getTranslated(context, "seekingHusband"),
    getTranslated(context, "seekingWife"),
    getTranslated(context, "normalUser"),
  ];
    return ListView.builder(
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: AppPadding.p32.h),
        child: GestureDetector(
          onTap: () {
            select = index;
            setState(() {});
          },
          child: RegisterItem(
            registerText: registerTextItem[index],
            isSelected: select == index,
          ),
        ),
      ),
      itemCount: registerTextItem.length,
    );
  }
}
