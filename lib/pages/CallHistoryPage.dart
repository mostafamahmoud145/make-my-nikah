import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/FireStorePagnation/widgets/empty_display.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/historyAppointmentWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import 'package:shimmer/shimmer.dart';
import '../FireStorePagnation/paginate_firestore.dart';

class CallHistoryPage extends StatefulWidget {
  @override
  _CallHistoryPageState createState() => _CallHistoryPageState();
}

class _CallHistoryPageState extends State<CallHistoryPage>
    with AutomaticKeepAliveClientMixin<CallHistoryPage> {
  final TextEditingController searchController = new TextEditingController();

  late AccountBloc accountBloc;
  GroceryUser? user;
  late bool load;
  DateTime selectedDate = DateTime.now();
  bool avaliable = false;
  DateTime _now = DateTime.now();
  bool filter = false;
  late String time;
  late String _time;

  String lang = "";

  late Query filterQuery;

  @override
  void initState() {
    super.initState();
    accountBloc = BlocProvider.of<AccountBloc>(context);
    accountBloc.add(GetLoggedUserEvent());
    filterQuery = FirebaseFirestore.instance
        .collection(Paths.appAppointments)
        .where('consult.uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('appointmentStatus', isEqualTo: "closed")
        .orderBy('secondValue', descending: true);
    load = true;
    time = "Filter by date";
    _time = "التصفية حسب التاريخ";

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    lang = getTranslated(context, "lang");
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder(
        bloc: accountBloc,
        builder: (context, state) {
          print("Account state");
          print(state);
          if (state is GetLoggedUserInProgressState) {
            return Center(child: loadWidget());
          } else if (state is GetLoggedUserCompletedState) {
            user = state.user;
            checkAvaliable();
            return Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: AppPadding.p32.h,
                      bottom: AppPadding.p43_3.h,
                      left: AppPadding.p32.w,
                      right: AppPadding.p32.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        splashColor: Colors.white.withOpacity(0.6),
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          height: convertPtToPx(AppSize.h44.h),
                          width: convertPtToPx(AppSize.w222.w),
                          padding: EdgeInsets.only(
                              right: convertPtToPx(AppPadding.p5.r),
                              left: convertPtToPx(AppPadding.p5.r)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                convertPtToPx(AppRadius.r5.r)),
                            boxShadow: [shadow()],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AssetsManager.filter2IconPath,
                                  width: convertPtToPx(AppSize.w24.w),
                                  height: convertPtToPx(AppSize.h24.h),
                                ),
                                SizedBox(
                                  width: convertPtToPx(AppSize.w21_3.w),
                                ),
                                Text(
                                 time,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: getTranslated(
                                          context, "Montserratmedium"),
                                      color: AppColors.darkGrey,
                                      fontSize: convertPtToPx(
                                          AppFontsSizeManager.s16.sp),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          avaliable
                              ? Image.asset(
                                  AssetsManager.online,
                                  width: AppSize.w16.w,
                                  height: AppSize.h16.h,
                                )
                              : Image.asset(
                                  AssetsManager.offline,
                                  width: AppSize.w16.w,
                                  height: AppSize.h16.h,
                                ),
                          SizedBox(
                            width: convertPtToPx(AppSize.w6.w),
                          ),
                          Center(
                            child: Text(
                              avaliable
                                  ? getTranslated(context, "active")
                                  : getTranslated(context, "notActive"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                color: AppColors.black3,
                                fontSize: AppFontsSizeManager.s18_6.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  splashColor: Colors.white.withOpacity(0.6),
                  onTap: () {
                    setState(() {
                      filterQuery = FirebaseFirestore.instance
                          .collection(Paths.appAppointments)
                          .where('consult.uid', isEqualTo: user!.uid)
                          .where('appointmentStatus', isEqualTo: "closed")
                          .orderBy('secondValue', descending: true);
                      time = getTranslated(context, "filterTxt");
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          getTranslated(context, "allAppointment"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratsemibold"),
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: convertPtToPx(AppFontsSizeManager.s20.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: convertPtToPx(AppSize.w8.w),
                      ),
                      Image.asset(
                        AssetsManager.redCallIcon,
                        width: convertPtToPx(AppSize.w24.w),
                        height: convertPtToPx(AppSize.h24.h),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: convertPtToPx(AppSize.h32.h),
                ),
                Expanded(
                  child: PaginateFirestore(
                    onEmpty:EmptyDisplay(emptyText: "noData"),
                    key: ValueKey(filterQuery),
                    itemBuilderType: PaginateBuilderType.gridView,
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p32.r),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: convertPtToPx(AppSize.w10.w),
                        mainAxisSpacing: 20,
                        mainAxisExtent: 206.h,
                        childAspectRatio: 1.8),
                    itemBuilder: (context, documentSnapshot, index) {
                      return HistoryAppointmentWiget(
                        appointment: AppAppointments.fromMap(
                            documentSnapshot[index].data() as Map),
                        loggedUser: user!,
                      );
                    },
                    query: filterQuery,
                    isLive: true,
                  ),
                ),
              ],
            );
          } else {
            return Center(child: loadWidget());
          }
        },
      ),
    );
  }

  BoxShadow shadow() {
    return BoxShadow(
      color: Color.fromRGBO(32, 32, 32, 0.04),
      blurRadius: 11.0,
      spreadRadius: 0.0,
      offset: Offset(0.0, 4.0), // shadow direction: bottom right
    );
  }

  Widget loadWidget() {
    return Shimmer.fromColors(
        period: Duration(milliseconds: 800),
        baseColor: Colors.grey.withOpacity(0.6),
        highlightColor: Colors.black.withOpacity(0.6),
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width * .9,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    // Create a new DateTime object with only the year, month, and day (time is set to 00:00:00)
    final DateTime currentDate = DateTime(now.year, now.month, now.day);
    final DateTime? picked = await showDatePickerDialog(

      contentPadding: EdgeInsets.zero,
      context: context,
      initialDate: selectedDate,
      minDate: DateTime(2015, 10, 30),
      maxDate: currentDate,
      currentDate: currentDate,
      selectedDate: currentDate,
      currentDateDecoration: const BoxDecoration(),
      currentDateTextStyle: const TextStyle(),
      daysOfTheWeekTextStyle: TextStyle(
          fontFamily: getTranslated(context, "Montserratsemibold"),
          fontSize: 12,
          color: AppColors.grey3
      ),
      //disbaledCellsDecoration: const BoxDecoration(),
      disabledCellsTextStyle: const TextStyle(color: AppColors.grey),
      enabledCellsDecoration: const BoxDecoration(),
      enabledCellsTextStyle: const TextStyle(),
      initialPickerType: PickerType.days,
      selectedCellDecoration: const BoxDecoration(
        color: AppColors.pink2,
        shape: BoxShape.circle,
      ),
      selectedCellTextStyle: const TextStyle(
        color: AppColors.white,
      ),
      leadingDateTextStyle: const TextStyle(
          color: AppColors.pink2
      ),
      slidersColor: Colors.lightBlue,
      highlightColor: Colors.redAccent,
      slidersSize: 20,
      splashColor: Colors.lightBlueAccent,
      splashRadius: 40,
      centerLeadingDate: true,


    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        int month = selectedDate.month;
        int day = selectedDate.day;
        filterQuery = FirebaseFirestore.instance
            .collection(Paths.appAppointments)
            .where('consult.uid', isEqualTo: user!.uid)
            .where('appointmentStatus', isEqualTo: "closed")
            .where('date.month', isEqualTo: month)
            .where('date.day', isEqualTo: day)
            .orderBy('secondValue', descending: true);
        time = selectedDate.toString().substring(0, 10);
      });
  }

  checkAvaliable() async {
    if (user != null &&
        user!.userType == "CONSULTANT"||
        user!.userType == "COACH"&&
        user!.profileCompleted == true) {
      String dayNow = _now.weekday.toString();
      int timeNow = _now.hour;
      if (user!.workDays!.contains(dayNow)) {
        if (int.parse(user!.workTimes![0].from!) <= timeNow &&
            int.parse(user!.workTimes![0].to!) > timeNow) {
          avaliable = true;
        }
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
