import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/FireStorePagnation/paginate_firestore.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/appReview.dart';
import 'package:grocery_store/models/courses.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../config/app_fonts.dart';
import '../config/app_values.dart';
import '../config/colorsFile.dart';
import '../models/banner.dart';
import '../models/category_question_model.dart';
import '../models/userReview.dart';
import '../widget/image_slider_widget.dart';
import '../widget/courseListWidget.dart';
import '../widget/question_category_widget.dart';
import '../widget/tab_bar_widget.dart';
import '../widget/tab_button.dart';

class AcademyPage extends StatefulWidget {
  @override
  _AcademyPageState createState() => _AcademyPageState();
}

class _AcademyPageState extends State<AcademyPage>
    with AutomaticKeepAliveClientMixin<AcademyPage> {
  late AccountBloc accountBloc;
  GroceryUser? user;
  bool load = true, loadBanner = true;
  late Query query;
  bool courses = true, qa = false, webinar = false;
  List<banner> AcademyBannerList = [];
  banner? bannerItem;

  List<AppReviews> appReviews = [];
  List<UserReviews> userReviews = [];

  bool appReviewLoad = false;
  bool userReviewLoad = false;
  Size? size;
  Query filterQuery = FirebaseFirestore.instance
      .collection("Courses")
      .where('status', isEqualTo: true)
      .orderBy('order', descending: false);

  @override
  void initState() {
    super.initState();
    getImageSlider();
    accountBloc = BlocProvider.of<AccountBloc>(context);
    accountBloc.add(GetLoggedUserEvent());
  }

  getImageSlider() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Banners')
          .where('type', isEqualTo: "Academy")
          .where('status', isEqualTo: true)
          .get();

      var _bannerList = List<banner>.from(
        querySnapshot.docs.map(
              (snapshot) => banner.fromMap(snapshot.data() as Map),
        ),
      );

      setState(() {
        AcademyBannerList = _bannerList;
        loadBanner = false;
      });
    } catch (e) {
      setState(() {
        loadBanner = false;
        print("Error loading banners");
        print(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder(
          bloc: accountBloc,
          builder: (context, state) {
            print("Account state");
            print(state);
            if (state is GetLoggedUserInProgressState) {
              return Center(child: loadWidget());
            }
            else if (state is GetLoggedUserCompletedState) {
              user=state.user;
              return  body();
            }
            else {
              return body();
            }
          },

        ),);

  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: AppSize.h32.h),
          /// -SLIDER_WIDGET- ///
          ImageSliderWidget(AcademyBannerList: AcademyBannerList),
          SizedBox(height: AppSize.h32.h),
          /// -TAB BAR WIDGET- ///
          Center(
            child: Container(
              width: size!.width * AppSize.w0_85,
              height: AppSize.h50,
              padding: EdgeInsets.symmetric(horizontal: AppPadding.p32.w),
              child: TabBarWidget(
                width: AppSize.w506_6.w,
                height: AppSize.h72.h,
                radius: AppRadius.r16.r,
                buttons: [
                  //button x
                  TabButton(
                    onPress: () {
                      setState(() {
                        qa = false;
                        webinar = false;
                        courses = true;
                      });
                    },
                    Height: AppSize.h53_3.h,
                    Width: AppSize.w122_6.w,
                    ButtonRadius: AppRadius.r10_6.r,
                    ButtonColor:
                    courses ? AppColors.pink2 : Colors.transparent,
                    Title: getTranslated(context, "courses"),
                    TextFont: getTranslated(context, "academyFontFamily"),
                    TextSize: AppFontsSizeManager.s21_3.sp,
                    TextColor:
                    courses ? AppColors.white : AppColors.darkGrey,
                  ),
                  //button y
                  TabButton(
                    onPress: () {
                      setState(() {
                        qa = true;
                        webinar = false;
                        courses = false;
                      });
                    },
                    Height: AppSize.h53_3.h,
                    Width: AppSize.w122_6.w,
                    ButtonRadius: AppRadius.r10_6.r,
                    ButtonColor: qa ? AppColors.pink2 : Colors.transparent,
                    Title: getTranslated(context, "qa"),
                    TextFont: getTranslated(context, "academyFontFamily"),
                    TextSize: AppFontsSizeManager.s21_3.sp,
                    TextColor: qa ? AppColors.white : AppColors.darkGrey,
                  ),
                  TabButton(
                    onPress: () {
                      setState(() {
                        qa = false;
                        webinar = true;
                        courses = false;
                      });
                    },
                    Height: AppSize.h53_3.h,
                    Width: AppSize.w160.w,
                    ButtonRadius: AppRadius.r10_6.r,
                    ButtonColor:
                    webinar ? AppColors.pink2 : Colors.transparent,
                    Title: getTranslated(context, "webinar"),
                    TextFont: getTranslated(context, "academyFontFamily"),
                    TextSize: AppFontsSizeManager.s21_3.sp,
                    TextColor:
                    webinar ? AppColors.white : AppColors.darkGrey,
                  ),
                ],
                padding: EdgeInsets.all(AppPadding.p7),
              ),
            ),
          ),
          SizedBox(height: AppSize.h32.h),
          courses ? coursesWidget() : SizedBox(),
          qa ? qaWidget() : SizedBox(),
          webinar ? webinarWidget() : SizedBox()
        ],
      ),
    );
  }

  Widget coursesWidget() {
    return SizedBox(
      height: size!.height * 0.7, // Specify the height
      child: PaginateFirestore(
        itemBuilderType: PaginateBuilderType.gridView,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSize.w21_3.w,
          mainAxisSpacing: AppSize.h32.h,
          mainAxisExtent: 292.h,
        ),
        itemBuilder: (context, documentSnapshot, index) {
          return courseListWidget(
            course: Courses.fromMap(documentSnapshot[index].data() as Map),
            loggedUser: user,
          );
        },
        query: FirebaseFirestore.instance
            .collection('Courses')
            .where('status', isEqualTo: true)
            .orderBy('order', descending: false),
        isLive: true,
      ),
    );
  }

  Widget qaWidget() {
    return SizedBox(
      height: size!.height * 0.7, // Specify the height
      child: PaginateFirestore(
        separator: Container(
          height: .5,
          width: AppSize.w506_6.w,
          color: Color.fromRGBO(211, 211, 211, 1.0),
        ),
        itemBuilderType: PaginateBuilderType.listView,
        itemBuilder: (context, documentSnapshot, index) {
          return QuestionCategoryWidget(
            categoryQuestion: CategoryQuestion.fromMap(
                documentSnapshot[index].data() as Map<String, dynamic>),
          );
        },
        query: FirebaseFirestore.instance.collection("QuestionCategorys"),
        isLive: true,
      ),
    );
  }

  Widget webinarWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Center(
        child: Text(
          getTranslated(context, "comingSoon"),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: getTranslated(context, "Montserratsemibold"),
            color: AppColors.grey5,
            fontSize: AppFontsSizeManager.s18_6.sp,
          ),
        ),
      ),
    );
  }

  Widget loadWidget() {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.pink,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
