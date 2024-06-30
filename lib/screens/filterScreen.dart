
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/models/userSearch.dart';
import 'package:grocery_store/screens/enterFilterScreen.dart';
import 'package:grocery_store/screens/searchScreen.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../widget/TextButton.dart';
import '../widget/app_bar_widget.dart';
import '../widget/chooseItem.dart';
import 'chooseFilterScreen.dart';


class FilterScreen extends StatefulWidget {
  final String userId;
  final GroceryUser loggedUser;

  const FilterScreen({Key? key, required this.userId, required this.loggedUser})
      : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool smoke = false,
      drinkers = false,
      tribal = false,
      isselected = false,
      isloading = false,
      saveSelection = false,
      loading = false;

  UserSearch usersearch = UserSearch();

  userSearch(String type) async {
    if (type == "0")
      setState(() {
        this.isloading = true;
      });
    else
      setState(() {
        saveSelection = true;
      });
    final snapShot = await FirebaseFirestore.instance
        .collection(Paths.userSearch)
        .doc(widget.userId)
        .get();

    if (!snapShot.exists) {
      await FirebaseFirestore.instance
          .collection(Paths.userSearch)
          .doc(widget.userId)
          .set({
        "userId": widget.userId,
        "minAge": 15,
        "maxAge": 100,
        "country": "",
        "nationality": "",
        "countryCode": "",
        "nationalityCode": "",
        "skinColor": [],
        "minHeight": 100,
        "maxHeight": 250,
        "minWeight": 40,
        "maxWeight": 200,
        "maritalState": "",
        "hijab": "",
        "religion": "",
        "marriageType": "",
        "education": "",
        "employment": "",
        "smoke": "",
        "drinkers": "",
        "tribal": "",
      }).then((value) async {
        var snapShot = await FirebaseFirestore.instance
            .collection(Paths.userSearch)
            .doc(widget.userId)
            .get();
        setState(() {
          this.usersearch = UserSearch.fromMap(snapShot.data() as Map);
          this.isloading = false;
          saveSelection = false;
        });
      });
    } else {
      setState(() {
        this.usersearch = UserSearch.fromMap(snapShot.data() as Map);
        this.usersearch.smoke == "smoker"
            ? this.smoke = true
            : this.smoke = false;
        this.usersearch.drinkers == "drinker"
            ? this.drinkers = true
            : this.drinkers = false;
        this.usersearch.tribal == "tribal"
            ? this.tribal = true
            : this.tribal = false;
        this.isloading = false;
        saveSelection = false;
      });
    }
  }

  @override
  void initState() {
    userSearch("0");
    super.initState();
  }

  Widget searchItem(
      { String? image,
      String? svgImage,
      bool? employment = false,
      required String title,
      required String subtitle,
      required Function() onTaping}) {
    return InkWell(
        onTap: onTaping,
        child: Container(
          height: AppSize.h160.h,
          width: AppSize.w173_3.w,
          padding:employment==true?
          EdgeInsets.only(top: AppSize.h19_3.h)  
          :EdgeInsets.symmetric(vertical: AppSize.h19_3.h),
          
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.r16.r),
              color: AppColors.lightGrey9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
     
            image==null? SvgPicture.asset(
                svgImage!,
                width: AppSize.w53_3.r,
                height: AppSize.h53_3.r,
                //fit: BoxFit.contain,
              ):  Image.asset(
                image,
                width: AppSize.w53_3.r,
                height: AppSize.h53_3.r,
                //fit: BoxFit.contain,
              ),
              SizedBox(
                height: AppSize.h16.h,
              ),
              Text(
                title,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  height:employment==true? AppSize.h1_5.h:null,
                  color: AppColors.black,
                    fontSize: AppFontsSizeManager.s18_6.sp,
                    
                    fontFamily: getTranslated(context, "Montserratsemibold")),
              ),
            employment==true? Spacer():SizedBox(height: AppSize.h10_6.h,),
              Text(
                  (subtitle.isEmpty || subtitle == "") ? '...' : subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.lightGrey5,
                      fontSize:  AppFontsSizeManager.s16.sp,
                      fontFamily: getTranslated(context, "Montserratmedium"))),
                      employment==true? Spacer(flex: 3,):SizedBox()
            ],
          ),
        ));
  }

  Widget checkItem(
      {required String image,
      required String title,
      required bool checkValue}) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                //border: Border.all(color: AppColors.grey),
                borderRadius: BorderRadius.circular(10),
                color: AppColors.white2,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Checkbox(
                      value: checkValue,
                      onChanged: (value) {
                        setState(() {
                          checkValue = value!;
                        });
                      },
                    ),
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                  color: AppColors.reddark,
                                  fontSize: 20,
                                  fontFamily:
                                      getTranslated(context, "fontFamily")),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.gren),
                                color: AppColors.green1.withOpacity(0.3)),
                            child: Image.asset(
                              image,
                              width: 20,
                              height: 20,
                            ))
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  deleteOnTap() async {
    setState(() {
      this.isloading = true;
    });
    setState(() {
      this.loading = true;
    });
    await FirebaseFirestore.instance
        .collection(Paths.userSearch)
        .doc(widget.userId)
        .set({
      "userId": widget.userId,
      "minAge": 15,
      "maxAge": 100,
      "country": "",
      "nationality": "",
      "countryCode": "",
      "nationalityCode": "",
      "skinColor": [],
      "minHeight": 100,
      "maxHeight": 250,
      "minWeight": 40,
      "maxWeight": 200,
      "maritalState": "",
      "religion": "",
      "marriageType": "",
      "education": "",
      "employment": "",
      "smoke": "",
      "drinkers": "",
      "tribal": "",
    }).then((value) async {
      var snapShot = await FirebaseFirestore.instance
          .collection(Paths.userSearch)
          .doc(widget.userId)
          .get();
      setState(() {
        this.usersearch = UserSearch.fromMap(snapShot.data() as Map);
        this.isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: this.isloading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
            child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                       bottom: AppPadding.p21_3.h),
                    ///--App Bar Widget--///
                    child: AppBarWidget2(
                        text: getTranslated(context, "search"),
                        /*iconHeight: AppSize.h24,
                        iconWidth: AppSize.w24,
                        imagePath:AssetsManager.outlineDeleteIconPath,
                        onPress:(){
                              isloading
                                  ? CircularProgressIndicator()
                                  : deleteOnTap();
                          setState(() {
                          });
                        }*/
                    ),
                  ),           
            
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: AppSize.w32.w),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
            
                            Text(
                             getTranslated(context, "ClearSearchHistory"),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: getTranslated(context, "Montserratsemibold"),
                                  fontSize: AppFontsSizeManager.s21_3.sp,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(width: AppSize.w18_6.w,),
                            InkWell(
                              onTap: (){deleteOnTap();},
                              child: SvgPicture.asset(
                                AssetsManager.deleteIconRed,
                                width: AppSize.w32.r,
                                height: AppSize.h32.r,
                                fit: BoxFit.cover,
                              ),
                            ),
            
                          ],
                        ),
                        SizedBox(height: AppSize.h46.h,),
                        Text(
                          getTranslated(context, "filterText"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.grey3,
                              fontFamily: getTranslated(context, "Montserratmedium"),
                              // fontWeight: FontWeight.w300,
                              fontSize: AppFontsSizeManager.s24.sp),
                        ),
            
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.h42_6.h,),
            
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: Expanded(
                      child: ListView(
                        // padding: EdgeInsets.only(left: size.width*.15,right: size.width*.15),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              searchItem(
                                  svgImage: AssetsManager.flagIcon,
                                  title: getTranslated(context, "country"),
                                  subtitle: this.usersearch.country!,
                                  onTaping: () {
                                    showCountryPicker(
                                        context: context,
                                        showPhoneCode: true,
                                        onSelect: (Country country) async {
                                          setState(() {
                                            this.usersearch.country =
                                                country.name;
                                            this.usersearch.countryCode =
                                                country.phoneCode;
                                            print("gg00000000");
                                            print(this.usersearch.country);
                                            print(this.usersearch.countryCode);
                                          });
                                          await FirebaseFirestore.instance
                                              .collection(Paths.userSearch)
                                              .doc(widget.userId)
                                              .set({
                                            "country": this.usersearch.country,
                                            "countryCode":
                                                this.usersearch.countryCode
                                          }, SetOptions(merge: true)).then(
                                                  (value) {
                                            print("user search updated");
                                          }).catchError((error) {
                                            print("user search update error");
                                          });
                                        },
                                        countryListTheme: CountryListThemeData(
                                            backgroundColor: AppColors.white1,
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                color: Colors.blueGrey),
                                            inputDecoration: InputDecoration(
                                                //labelText: 'Search',
                                                hintStyle: TextStyle(
                                                    fontFamily: getTranslated(
                                                        context, "fontFamily"),
                                                    fontSize: 12),
                                                hintText: getTranslated(
                                                    context, "favoritecountry"),
                                                prefixIcon:
                                                    const Icon(Icons.search),
                                                suffixIcon: InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        this.usersearch.country =
                                                            "";
                                                        this
                                                            .usersearch
                                                            .countryCode = "";
                                                      });
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              Paths.userSearch)
                                                          .doc(widget.userId)
                                                          .set(
                                                              {
                                                            "country": "",
                                                            "countryCode": ""
                                                          },
                                                              SetOptions(
                                                                  merge:
                                                                      true)).then(
                                                              (value) {
                                                        print(
                                                            "user search updated");
                                                        Navigator.pop(context);
                                                      }).catchError((error) {
                                                        print(
                                                            "user search update error");
                                                      });
                                                    },
                                                    child:
                                                        const Icon(Icons.close)),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  borderSide: BorderSide(
                                                    color: AppColors.reddark2,
                                                  ),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  borderSide: BorderSide(
                                                    color: AppColors.reddark2,
                                                  ),
                                                )),
                                            bottomSheetHeight: size.height * 0.90,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            )));
                                  }),
                              SizedBox(
                                width: AppSize.w73_3.w,
                              ),
                              searchItem(
                                  svgImage:
                                      AssetsManager.evaIcon,
                                  title: getTranslated(context, "skincolor"),
                                  subtitle: this.usersearch.skinColor.toString(),
                                  onTaping: () async {
                                    //yasmeen
                                    _show(context, size, 1);
                                    /*final result = await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return ChooseFilterScreen(
                                    screen: 1,
                                    userId: widget.userId,
                                  );
                                },
                              );
                              setState(() {
                                usersearch = result;
                              });*/
                                  }),
                            ],
                          ),
                          SizedBox(
                          height: AppSize.h26_6.h
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                searchItem(
                                    svgImage:
                                        AssetsManager.tablerIcon,
                                    title: getTranslated(context, "age"),
                                    subtitle: this.usersearch.minAge.toString() +
                                        "-" +
                                        this.usersearch.maxAge.toString(),
                                    onTaping: () async {
                                      _showRange(context, size, 1);
                                    }),
                                 SizedBox(
                                width: AppSize.w73_3.w,
                              ),
                                searchItem(
                                    svgImage:
                                        AssetsManager.tablerLineIcon,
                                    title: getTranslated(context, "height"),
                                    subtitle:
                                        this.usersearch.minHeight.toString() +
                                            "-" +
                                            this.usersearch.maxHeight.toString() +
                                            " " +
                                            "cm",
                                    onTaping: () async {
                                      _showRange(context, size, 2);
                                    }),
                              ]),
                          SizedBox(
                          height: AppSize.h26_6.h
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                searchItem(
                                    image: AssetsManager.wieghtIcon2,
                                    title: getTranslated(context, "weight"),
                                    subtitle:
                                        this.usersearch.minWeight.toString() +
                                            "-" +
                                            this.usersearch.maxWeight.toString() +
                                            " " +
                                            "kg",
                                    onTaping: () async {
                                      _showRange(context, size, 3);
                                    }),
                                SizedBox(
                                width: AppSize.w73_3.w,
                              ),
                                searchItem(
                                    svgImage:
                                        AssetsManager.solarIcon,
                                    title:
                                        getTranslated(context, "maritalStatus"),
                                    subtitle: this.usersearch.maritalState!,
                                    //getTranslated(context, this.usersearch.maritalState),
                                    onTaping: () async {
                                      _show(context, size, 2);
                                    }),
                              ]),
                          SizedBox(
                           height: AppSize.h26_6.h
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /* searchItem(
                                image: "assets/icons/icon/Group 2993.png",
                                title: getTranslated(context, "hijab"),
                                subtitle: this.usersearch.hijab.toString(),
                                onTaping: () async {
                                  final result = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return ChooseFilterScreen(
                                        screen: 0,
                                        userId: widget.userId,
                                      );
                                    },
                                  );
                                  setState(() {
                                    usersearch = result;
                                  });
                                }),*/
                                searchItem(
                                    svgImage:AssetsManager.bagIcon
                                        ,
                                        employment: true,
                                    title: getTranslated(
                                        context, "employmentStatus"),
                                    subtitle: this.usersearch.employment!,
                                    //getTranslated( context, this.usersearch.employment!),
                                    onTaping: () async {
                                      _show(context, size, 6);
                                    }),
                                SizedBox(
                                width: AppSize.w73_3.w,
                              ),
                                searchItem(
                                    svgImage:AssetsManager.religionIcon,
                                        
                                    title: getTranslated(context, "religion"),
                                    subtitle: this.usersearch.religion!,
                                    // getTranslated(context, this.usersearch.religion!),
                                    onTaping: () async {
                                      _show(context, size, 3);
                                    }),
                              ]),
                          SizedBox(
                          height: AppSize.h26_6.h
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                searchItem(
                                    svgImage:AssetsManager.ringIcon
                                        ,
                                    title: getTranslated(context, "marriageType"),
                                    subtitle: this.usersearch.marriageType!,
                                    //getTranslated(  context, this.usersearch.marriageType!),
                                    onTaping: () async {
                                      _show(context, size, 4);
                                    }),
                                SizedBox(
                                width: AppSize.w73_3.w,
                              ),
                                searchItem(
                                    svgImage:
                                       AssetsManager.educationIcon,
                                    title: getTranslated(context, "education"),
                                    subtitle: this.usersearch.education!,
                                    // getTranslated(context, this.usersearch.education!),
                                    onTaping: () async {
                                      _show(context, size, 5);
                                    }),
                              ]),
                          SizedBox(
                            height: AppSize.h26_6.h
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: AppSize.h160.h,
                                  width: AppSize.w173_3.w,
                                  padding: EdgeInsets.only(top: AppPadding.p24.h,bottom: AppPadding.p17_3.h,),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.r16.r),
                                      color: AppColors.lightGrey9),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: AppSize.h32.h,
                                        child: Switch(
                                          value: this.smoke,
                                          inactiveTrackColor: AppColors.lightGray,
                                          trackOutlineColor: MaterialStateProperty.all<Color?>(AppColors.white),
                                          inactiveThumbImage: AssetImage("",),
                                          activeColor: AppColors.reddark2,
                                          inactiveThumbColor: AppColors.grey3,
                                          onChanged: (bool value) async {
                                            setState(() {
                                              this.smoke = value;
                                              value
                                                  ? this.usersearch.smoke =
                                                      "smoker"
                                                  : this.usersearch.smoke =
                                                      "nonSmoker";
                                            });
                                                  
                                            await FirebaseFirestore.instance
                                                .collection(Paths.userSearch)
                                                .doc(widget.userId)
                                                .set({
                                              "smoke": this.usersearch.smoke,
                                            }, SetOptions(merge: true)).then(
                                                    (value) {
                                              print("user search updated");
                                            }).catchError((error) {
                                              print(
                                                  "user search update error");
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      Text(
                                        getTranslated(context, "Smoking"),
                                        style: TextStyle(
                                            color: AppColors.balck2,
                                            fontSize: AppFontsSizeManager.s18_6.sp,
                                            fontFamily: getTranslated(
                                                context, "Montserratsemibold")),
                                      ),
                                      Text(
                                        this.smoke==true?getTranslated(context, "true")
                                     :getTranslated(context, "false"),
                                        style: TextStyle(
                                            color: AppColors.pink2,
                                            fontSize: AppFontsSizeManager.s16.sp,
                                            fontFamily: getTranslated(
                                                context, "Montserratmedium")),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: AppSize.w73_3.w,
                                ),
                                Container(
                                 height: AppSize.h160.h,
                                  width: AppSize.w173_3.w,
                                 padding: EdgeInsets.only(top: AppPadding.p24.h,bottom: AppPadding.p17_3.h,),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.r16.r),
                                      color: AppColors.lightGrey9),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                    height: AppSize.h32.h,
                                        child: Switch(      
                                                                              
                                          inactiveThumbImage: AssetImage("",),
                                          inactiveTrackColor: AppColors.lightGray,
                                          trackOutlineColor: MaterialStateProperty.all<Color?>(AppColors.white),
                                          value: this.tribal,
                                          inactiveThumbColor: AppColors.grey3,
                                          activeColor: AppColors.reddark2,
                                          onChanged: (bool value) async {
                                            setState(() {
                                              this.tribal = value;
                                              value
                                                  ? this.usersearch.tribal =
                                                      "tribal"
                                                  : this.usersearch.tribal =
                                                      "nonTribal";
                                            });
                                            await FirebaseFirestore.instance
                                                .collection(Paths.userSearch)
                                                .doc(widget.userId)
                                                .set({
                                              "tribal":this.usersearch.tribal
                                            }, SetOptions(merge: true)).then(
                                                    (value) {
                                              print("user search updated");
                                            }).catchError((error) {
                                              print("user search update error");
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                          height: AppSize.h21_3.h,
                                      ),
                                      //p p
                                      Text(
                                        getTranslated(context, "tribal"),
                                        style: TextStyle(
                                            color: AppColors.balck2,
                                            fontSize: AppFontsSizeManager.s18_6.sp,
                                           fontFamily: getTranslated(
                                                context, "Montserratsemibold")),
                                      ),
                                      Text(
                                     this.tribal==true?getTranslated(context, "true")
                                     :getTranslated(context, "false"),
                                        style: TextStyle(
                                             color: AppColors.pink2,
                                             fontSize: AppFontsSizeManager.s16.sp,
                                            fontFamily: getTranslated(
                                                context, "Montserratsemibold")),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                          SizedBox(
                            height: AppSize.h64.h,
                          ),
                          isselected
                              ? Center(child: CircularProgressIndicator())
                              : Padding(
                                padding: EdgeInsets.symmetric(horizontal: AppPadding.p32.w),
                                child: Center(
                                    child:  TextButton1(onPress: () async {
                                      setState(() {
                                        this.loading = false;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SearchScreen(
                                              loggedUser: widget.loggedUser,
                                              usersearch: this.usersearch),
                                        ),
                                      );
                                    },Width:size.width,Height: AppSize.h66_6.h,
                                     Title:getTranslated(context, "search") ,
                                      ButtonRadius: AppRadius.r10_6.r,
                                       TextSize: AppFontsSizeManager.s21_3.sp,
                                       ButtonBackground: AppColors.pink2,
                                        TextFont: getTranslated(context, "Montserratsemibold"), TextColor: AppColors.white),
                                  ),
                              ),
                         SizedBox(
                      height:AppSize.h30_6.h,
                    ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ),
    );
  }

  void _show(BuildContext ctx, size, int screen) {
    showModalBottomSheet(
      elevation: 10,
      backgroundColor: Colors.transparent, //Color(0xfff9fafb),
      context: ctx,
      builder: (ctx) => Container(
        height: size.height * .8,
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
        decoration: BoxDecoration(
            color: Color(0xfff9fafb),
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(45.0),
              topRight: const Radius.circular(45.0),
            )),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StatefulBuilder(builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * .2,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Color(0xffaaaaaa),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if (screen == 0)
                      Column(
                        children: [
                          InkWell(
                            child: ChooseWidget(
                              ischecked:
                                  usersearch.hijab == "niqab" ? true : false,
                              title: getTranslated(context, "niqab"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.hijab = "niqab";
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked:
                                  usersearch.hijab == "jilbab" ? true : false,
                              title: getTranslated(context, "jilbab"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.hijab = "jilbab";
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked:
                                  usersearch.hijab == "veil" ? true : false,
                              title: getTranslated(context, "veil"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.hijab = "veil";
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.hijab == "nonVeiled"
                                  ? true
                                  : false,
                              title: getTranslated(context, "nonVeiled"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.hijab = "nonVeiled";
                              });
                            },
                          ),
                        ],
                      )
                    else if (screen == 1)
                      Column(
                        children: [
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.skinColor!.contains("white")
                                  ? true
                                  : false,
                              title: getTranslated(context, "white"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.skinColor!.contains("white")
                                    ? usersearch.skinColor!.remove("white")
                                    : usersearch.skinColor!.add("white");
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.skinColor!
                                      .contains("wheatishlight")
                                  ? true
                                  : false,
                              title: getTranslated(context, "wheatishlight"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.skinColor!.contains("wheatishlight")
                                    ? usersearch.skinColor!
                                        .remove("wheatishlight")
                                    : usersearch.skinColor!
                                        .add("wheatishlight");
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked:
                                  usersearch.skinColor!.contains("bronze")
                                      ? true
                                      : false,
                              title: getTranslated(context, "bronze"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.skinColor!.contains("bronze")
                                    ? usersearch.skinColor!.remove("bronze")
                                    : usersearch.skinColor!.add("bronze");
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked:
                                  usersearch.skinColor!.contains("wheatish")
                                      ? true
                                      : false,
                              title: getTranslated(context, "wheatish"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.skinColor!.contains("wheatish")
                                    ? usersearch.skinColor!.remove("wheatish")
                                    : usersearch.skinColor!.add("wheatish");
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked:
                                  usersearch.skinColor!.contains("lightblack")
                                      ? true
                                      : false,
                              title: getTranslated(context, "lightblack"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.skinColor!.contains("lightblack")
                                    ? usersearch.skinColor!.remove("lightblack")
                                    : usersearch.skinColor!.add("lightblack");
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked:
                                  usersearch.skinColor!.contains("darkblack")
                                      ? true
                                      : false,
                              title: getTranslated(context, "darkblack"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.skinColor!.contains("darkblack")
                                    ? usersearch.skinColor!.remove("darkblack")
                                    : usersearch.skinColor!.add("darkblack");
                              });
                            },
                          )
                        ],
                      )
                    else if (screen == 2)
                      Column(
                        children: [
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.maritalState == "single"
                                  ? true
                                  : false,
                              title: getTranslated(context, "single"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.maritalState = "single";
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.maritalState == "divorced"
                                  ? true
                                  : false,
                              title: getTranslated(context, "divorced"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.maritalState = "divorced";
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.maritalState == "married"
                                  ? true
                                  : false,
                              title: getTranslated(context, "married"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.maritalState = "married";
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked:
                                  usersearch.maritalState == "anotherwife"
                                      ? true
                                      : false,
                              title: getTranslated(context, "anotherwife"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.maritalState = "anotherwife";
                              });
                            },
                          ),
                        ],
                      )
                    else if (screen == 3)
                      Column(
                        children: [
                          InkWell(
                            child: ChooseWidget(
                              ischecked:
                                  usersearch.religion == "sunni" ? true : false,
                              title: getTranslated(context, "sunni"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.religion = "sunni";
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.religion == "shiite"
                                  ? true
                                  : false,
                              title: getTranslated(context, "shiite"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.religion = "shiite";
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.religion == "convert"
                                  ? true
                                  : false,
                              title: getTranslated(context, "convert"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.religion = "convert";
                              });
                            },
                          ),
                        ],
                      )
                    else if (screen == 4)
                      Column(
                        children: [
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.marriageType == "normal"
                                  ? true
                                  : false,
                              title: getTranslated(context, "normal"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.marriageType = "normal";
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.marriageType == "polygamy"
                                  ? true
                                  : false,
                              title: getTranslated(context, "polygamy"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.marriageType = "polygamy";
                              });
                            },
                          ),
                          // SizedBox(height: 15,),
                          // InkWell(
                          //   child: ChooseWidget(ischecked: usersearch.marriageType == "misyar"?true:false,title: getTranslated(context, "misyar"),),
                          //   onTap: (){
                          //     setState(() {
                          //       usersearch.marriageType = "misyar";
                          //     });
                          //   },
                          // ),
                        ],
                      )
                    else if (screen == 5)
                      Column(
                        children: [
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.education == "master"
                                  ? true
                                  : false,
                              title: getTranslated(context, "master"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.education = "master";
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked:
                                  usersearch.education == "phd" ? true : false,
                              title: getTranslated(context, "phd"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.education = "phd";
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.education == "highschool"
                                  ? true
                                  : false,
                              title: getTranslated(context, "highschool"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.education = "highschool";
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.education == "bachelor"
                                  ? true
                                  : false,
                              title: getTranslated(context, "bachelor"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.education = "bachelor";
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.education == "uneducated"
                                  ? true
                                  : false,
                              title: getTranslated(context, "uneducated"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.education = "uneducated";
                              });
                            },
                          ),
                        ],
                      )
                    else if (screen == 6)
                      Column(
                        children: [
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.employment == "employee"
                                  ? true
                                  : false,
                              title: getTranslated(context, "employee"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.employment = "employee";
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.employment == "manager"
                                  ? true
                                  : false,
                              title: getTranslated(context, "manager"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.employment = "manager";
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.employment == "worker"
                                  ? true
                                  : false,
                              title: getTranslated(context, "worker"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.employment = "worker";
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ChooseWidget(
                              ischecked: usersearch.employment == "unemployed"
                                  ? true
                                  : false,
                              title: getTranslated(context, "unemployed"),
                            ),
                            onTap: () {
                              setState(() {
                                usersearch.employment = "unemployed";
                              });
                            },
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    saveSelection
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      AppColors.reddark2,
                                      AppColors.reddark2
                                    ])),
                            height: 47,
                            child: MaterialButton(
                              onPressed: () async {
                                if (screen == 1) {
                                  print("ggggg5555555");
                                  print(usersearch.skinColor);
                                  await FirebaseFirestore.instance
                                      .collection(Paths.userSearch)
                                      .doc(widget.userId)
                                      .set({
                                    "skinColor": usersearch.skinColor,
                                  }, SetOptions(merge: true)).then((value) {
                                    print("user search updated");
                                  }).catchError((error) {
                                    print("user search update error");
                                  });
                                }

                                if (screen == 2) {
                                  await FirebaseFirestore.instance
                                      .collection(Paths.userSearch)
                                      .doc(widget.userId)
                                      .set({
                                    "maritalState": usersearch.maritalState,
                                  }, SetOptions(merge: true)).then((value) {
                                    print("user search updated");
                                  }).catchError((error) {
                                    print("user search update error");
                                  });
                                }

                                if (screen == 3) {
                                  await FirebaseFirestore.instance
                                      .collection(Paths.userSearch)
                                      .doc(widget.userId)
                                      .set({
                                    "religion": usersearch.religion,
                                  }, SetOptions(merge: true)).then((value) {
                                    print("user search updated");
                                  }).catchError((error) {
                                    print("user search update error");
                                  });
                                }

                                if (screen == 4) {
                                  await FirebaseFirestore.instance
                                      .collection(Paths.userSearch)
                                      .doc(widget.userId)
                                      .set({
                                    "marriageType": usersearch.marriageType,
                                  }, SetOptions(merge: true)).then((value) {
                                    print("user search updated");
                                  }).catchError((error) {
                                    print("user search update error");
                                  });
                                }

                                if (screen == 5) {
                                  await FirebaseFirestore.instance
                                      .collection(Paths.userSearch)
                                      .doc(widget.userId)
                                      .set({
                                    "education": usersearch.education,
                                  }, SetOptions(merge: true)).then((value) {
                                    print("user search updated");
                                  }).catchError((error) {
                                    print("user search update error");
                                  });
                                }

                                if (screen == 6) {
                                  await FirebaseFirestore.instance
                                      .collection(Paths.userSearch)
                                      .doc(widget.userId)
                                      .set({
                                    "employment": usersearch.employment,
                                  }, SetOptions(merge: true)).then((value) {
                                    print("user search updated");
                                  }).catchError((error) {
                                    print("user search update error");
                                  });
                                }

                                //Navigator.pop(context);
                                print("kkkkkkkkkkk");
                                print(usersearch.maritalState);
                                setState(() {
                                  saveSelection = true;
                                });
                                userSearch("1");
                                Navigator.pop(context);
                              },
                              //   color: AppColors.red1,
                              child: Text(
                                getTranslated(context, "save"),
                                style: TextStyle(
                                  fontFamily:
                                      getTranslated(context, "fontFamily"),
                                  color: AppColors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              );
            })),
      ),
    );
  }

  void _showRange(BuildContext ctx, size, int screen) {
    RangeValues age = const RangeValues(15, 100);
    RangeValues height = const RangeValues(100, 250);
    RangeValues weight = const RangeValues(40, 100);
    showModalBottomSheet(
      elevation: 10,
      backgroundColor: Colors.transparent, //Color(0xfff9fafb),
      context: ctx,
      builder: (ctx) => Container(
        height: size.height * .6,
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
        decoration: BoxDecoration(
            color: Color(0xfff9fafb),
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(45.0),
              topRight: const Radius.circular(45.0),
            )),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StatefulBuilder(builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * .2,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Color(0xffaaaaaa),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  screen == 1
                                      ? usersearch.minAge.toString()
                                      : screen == 2
                                          ? usersearch.minHeight.toString()
                                          : screen == 3
                                              ? usersearch.minWeight.toString()
                                              : usersearch.minWeight.toString(),
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    color: AppColors.balck2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  screen == 1
                                      ? "years"
                                      : screen == 2
                                          ? "Cm"
                                          : screen == 3
                                              ? "Kg"
                                              : "Kg",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    color: AppColors.balck2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * .1,
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  screen == 1
                                      ? usersearch.maxAge.toString()
                                      : screen == 2
                                          ? usersearch.maxHeight.toString()
                                          : screen == 3
                                              ? usersearch.maxWeight.toString()
                                              : usersearch.maxWeight.toString(),
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    color: AppColors.balck2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  screen == 1
                                      ? "years"
                                      : screen == 2
                                          ? "Cm"
                                          : screen == 3
                                              ? "Kg"
                                              : "Kg",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    color: AppColors.balck2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    if (screen == 1)
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColors.white2.withOpacity(0.4)),
                        child: RangeSlider(
                          values: age,
                          min: 15,
                          max: 100,
                          activeColor: AppColors.reddark2,
                          inactiveColor: Color(0xffdadada),
                          onChanged: (RangeValues values) {
                            setState(() {
                              age = values;
                              usersearch.minAge = age.start.toInt();
                              usersearch.maxAge = age.end.toInt();
                            });
                          },
                        ),
                      )
                    else if (screen == 2)
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColors.white2.withOpacity(0.4)),
                        child: RangeSlider(
                          values: height,
                          min: 100,
                          // divisions: 40,
                          max: 250,
                          activeColor: AppColors.reddark2,
                          inactiveColor: Color(0xffdadada),
                          onChanged: (RangeValues values) {
                            setState(() {
                              height = values;

                              usersearch.minHeight = height.start.toInt();
                              usersearch.maxHeight = height.end.toInt();
                            });
                          },
                        ),
                      )
                    else if (screen == 3)
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColors.white2.withOpacity(0.4)),
                        child: RangeSlider(
                          values: weight,
                          min: 40,
                          // divisions: 40,
                          max: 100,
                          activeColor: AppColors.reddark2,
                          inactiveColor: Color(0xffdadada),
                          onChanged: (RangeValues values) {
                            setState(() {
                              weight = values;

                              usersearch.minWeight = weight.start.toInt();
                              usersearch.maxWeight = weight.end.toInt();
                            });
                          },
                        ),
                      ),
                    SizedBox(height: 20),
                    saveSelection
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      AppColors.reddark2,
                                      AppColors.reddark2
                                    ])),
                            height: 45,
                            child: MaterialButton(
                              onPressed: () async {
                                setState(() {
                                  saveSelection = true;
                                });
                                if (screen == 1) {
                                  await FirebaseFirestore.instance
                                      .collection(Paths.userSearch)
                                      .doc(widget.userId)
                                      .set({
                                    "minAge": usersearch.minAge,
                                    "maxAge": usersearch.maxAge
                                  }, SetOptions(merge: true)).then((value) {
                                    print("user search updated");
                                  }).catchError((error) {
                                    print("user search update error");
                                  });
                                }
                                if (screen == 2) {
                                  await FirebaseFirestore.instance
                                      .collection(Paths.userSearch)
                                      .doc(widget.userId)
                                      .set({
                                    "minHeight": usersearch.minHeight,
                                    "maxHeight": usersearch.maxHeight
                                  }, SetOptions(merge: true)).then((value) {
                                    print("user search updated");
                                  }).catchError((error) {
                                    print("user search update error");
                                  });
                                }

                                if (screen == 3) {
                                  await FirebaseFirestore.instance
                                      .collection(Paths.userSearch)
                                      .doc(widget.userId)
                                      .set({
                                    "minWeight": usersearch.minWeight,
                                    "maxWeight": usersearch.maxWeight
                                  }, SetOptions(merge: true)).then((value) {
                                    print("user search updated");
                                  }).catchError((error) {
                                    print("user search update error");
                                  });
                                }

                                userSearch("1");
                                Navigator.pop(context);
                              },
                              //   color: AppColors.red1,
                              child: Text(
                                getTranslated(context, "save"),
                                style: TextStyle(
                                  fontFamily:
                                      getTranslated(context, "fontFamily"),
                                  color: AppColors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            })),
      ),
    );
  }
}
