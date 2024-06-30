import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_plus/date_picker_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/hijri_picker.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/consultDays.dart';
import 'package:grocery_store/models/promoCode.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/widget/appointmentDialogwidget/available_days_widget.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/widget/appointmentDialogwidget/available_hours_widget.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/widget/appointmentDialogwidget/custom_stepper.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/utils/payment_types.dart';
import 'package:grocery_store/screens/GirlAppointmentFeature/utils/service/GirlAppointmentCubit/girl_appointment_cubit.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../config/app_fonts.dart';
import '../../../config/assets_manager.dart';
import '../../../localization/localization_methods.dart';
import '../../../models/consultPackage.dart';
import '../../CoacheAppoinmentFeature/presention/widget/appointmentDialogwidget/text_dialog.dart';
import '../../PayCoursesFeature/presention/widget/payCourseDialogwidget/order_details_widget.dart';
import '../../walletFeature/utils/custom_widgets_for_payment_sheet.dart';
import 'dart:io';
import '../../../widget/payment_radio_button.dart';
import '../utils/service/funcation/check_balance.dart';
import 'widget/Invoice_girl_widget.dart';

class GirlAppointmentDialig extends StatefulWidget {
  final GroceryUser loggedUser;
  final GroceryUser consultant;
  final int localFrom;
  final int localTo;
  consultPackage package;
  Function({
    required DateTime date,
    // required int currentNumber,
    required int selectedCard,
    // required String consultType,
    required String time,
    required List<dynamic> todayAppointmentList,
    required PaymentTypes paymentType,
    required double totalPrice,
    String? promoCodeId,
  }) getData;

  GirlAppointmentDialig({
    required this.loggedUser,
    required this.consultant,
    required this.package,
    required this.localFrom,
    required this.localTo,
    required this.getData,
    required this.backFromBooking,
  });

  Function({
    required bool backFromBooking,
  }) backFromBooking;

  @override
  _GirlAppointmentDialigState createState() => _GirlAppointmentDialigState();
}

class _GirlAppointmentDialigState extends State<GirlAppointmentDialig> {
  final TextEditingController controller = TextEditingController();
  int selectedCard = -1;
  bool hijri = false,
      gregorian = true,
      loadDates = false,
      dateSelected = true,
      dateUnSelect = false;
  String time = DateFormat('yyyy-MM-dd').format(DateTime.now()), dateText = "";
  String?
      displayedTime; //= DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  late DateTime selectedDate = DateTime.now(), date;
  List<String> todayAppointmentList = [];
  int currentPage = 0;
  String? promoCodeId;
  PromoCode? promo;
  
  dynamic discount = 0;
  bool valid = false, checkPromo = false, checkValid = true;
  String? selectedTime;
  PaymentTypes? paymentType;
  late String userImage, userName, lang = "ar", theme = "light";
  bool showDayError = false;
  late Size size;

  @override
  void initState() {
    super.initState();
    // getDate();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: CustomStepper(
              progress: currentPage,
              width: size.width,
            ),
          ),
          SizedBox(
            height: convertPtToPx(AppSize.h24).h,
          ),
          pages(size)[currentPage],
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
                    if (currentPage > 0) {
                      setState(() {
                        currentPage--;
                      });
                    } else {
                      widget.backFromBooking(backFromBooking: true);
                    }
                  },
                  child: Container(
                    height: convertPtToPx(AppSize.h40).h,
                    width: convertPtToPx(AppSize.h40).h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius:
                          BorderRadius.circular(convertPtToPx(AppRadius.r8).r),
                      border: Border.all(color: AppColors.primary2, width: 1),
                    ),
                    child: Icon(
                      Icons.arrow_back_sharp,
                      size: AppSize.w40.r,
                      color: AppColors.primary2,
                    ),
                  ),
                ),
                PrimaryButton(
                  text: currentPage == (pages(size).length - 1)
                      ? getTranslated(context, "payment")
                      : getTranslated(context, "next"),
                  color: AppColors.primary2,
                  width: convertPtToPx(AppSize.w133_3).w,
                  height: convertPtToPx(AppSize.h40).h,
                  buttonRadius: convertPtToPx(AppRadius.r8).r,
                  textSize: AppFontsSizeManager.s21_3.sp,
                  onPress: () async {
                    if (currentPage == 0) {
                      if (displayedTime == null) {
                        /// show select day text.
                        setState(() {
                          showDayError = true;
                        });
                      } else if (todayAppointmentList.isEmpty ||
                          selectedCard < 0 ||
                          selectedTime == null) {
                        customTextDialog(
                            context: context,
                            okFunction: () {
                              Navigator.pop(context);
                            },
                            buttonText: getTranslated(context, 'Ok'),

                            /// change this text
                            text: getTranslated(context, 'timeNotSelected'),
                            textSize: AppFontsSizeManager.s24);
                      } else {
                        setState(() {
                          currentPage++;
                        });
                      }
                    } else {
                      if (currentPage < (pages(size).length - 1)) {
                        setState(() {
                          currentPage++;
                        });
                      } else {
                        if (paymentType == null) {
                          customTextDialog(
                              context: context,
                              text:
                                  getTranslated(context, 'chosePaymentMethod'),
                              buttonText: getTranslated(context, 'Ok'),
                              okFunction: () {
                                Navigator.pop(context);
                              });
                        } else {
                          widget.getData(
                            date: DateTime.parse(
                                todayAppointmentList[selectedCard]),
                            selectedCard: selectedCard,
                            time: time,
                            promoCodeId:promoCodeId,
                            todayAppointmentList: todayAppointmentList,
                            paymentType: paymentType!,
                            totalPrice: widget.package.price -
                                ((discount * widget.package.price) / 100),
                          );
                        }
                      }
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
    );
  }

  List<Widget> pages(Size size) {
    return [availableDays(size), orderDetailsWidget(size)];
  }

  Widget availableDays(Size size) {
    return AvailableDays(
        isGregorian: gregorian,
        ishijri: hijri,
        onTapHijri: () {
          setState(() {
            displayedTime = HijriCalendar.now().toString();
            selectedDate = DateTime.now();
            time = DateFormat('yyyy-MM-dd').format(DateTime.now());
            gregorian = false;
            hijri = true;
          });
        },
        onTapGregorian: () {
          setState(() {
            displayedTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
            selectedDate = DateTime.now();
            time = DateFormat('yyyy-MM-dd').format(DateTime.now());
            gregorian = true;
            hijri = false;
          });
        },
        onTapselectDay: () async {
          if (hijri)
            _selectHijriDate(context);
          else
            _selectDate(context);
        },
        availableHours: availableHours,
        displayedTime: displayedTime,
        loadDates: loadDates,
        showDayError: showDayError);
  }

  Widget availableHours() {
    final girlAppointmentCubit = BlocProvider.of<GirlAppointmentCubit>(context);
    // GirlAppointmentDialigCubit.date = DateTime.parse(selectedTime??(todayAppointmentList.isNotEmpty?todayAppointmentList.first:)).toLocal();
    girlAppointmentCubit.selectedCard = selectedCard;
    girlAppointmentCubit.time = time;
    girlAppointmentCubit.todayAppointmentList = todayAppointmentList;
    return AvailableHourss(
        todayAppointmentList:
            todayAppointmentList.map((e) => e.toString()).toList(),
        intialSelectedTime: selectedTime ?? "",
        onChanged: (value) {
          selectedTime = value;
          print("selectedTime:$selectedTime");
          selectedCard = todayAppointmentList.indexOf(value!);
          girlAppointmentCubit.date = DateTime.parse(value).toLocal();
          girlAppointmentCubit.selectedCard = selectedCard;
          girlAppointmentCubit.time = time;
          girlAppointmentCubit.todayAppointmentList = todayAppointmentList;
          // addAppointment(DateTime.parse(todayAppointmentList[index]).toLocal());
          setState(() {});
        },
        loadDates: loadDates);
  }

  Widget orderDetailsWidget(Size size) {
    return Container( padding: EdgeInsets.symmetric(
          horizontal: convertPtToPx(AppRadius.r16).w,
          vertical: convertPtToPx(AppRadius.r16).h),
      decoration: BoxDecoration(
        color: AppColors.tabBar,
        borderRadius: BorderRadius.circular(convertPtToPx(AppRadius.r12).r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         // if (widget.package.discount == null || widget.package.discount == 0)
            PromoCodeWidget(
              checkValid: checkValid,
              discount: discount,
              controller: controller,
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
          InvoiceGirlWidget(
            package: widget.package,
            displayedTime: displayedTime,
            selectedTime: selectedTime,
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
          if (checkBalanceGirlAppointment(
              package: widget.package,
              consultant: widget.consultant,
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
       /*      PaymentRadioButton(
               // endIconWidth: AppSize.w42
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
            controller.text=promo!.code;
            checkPromo = false;
            valid = true;
            checkValid = true;
            discount = promo!.discount;
            BlocProvider.of<GirlAppointmentCubit>(context).discountt = promo!.discount;
          });
        else
          setState(() {
            print("promo4");
            promoCodeId = "";
            checkPromo = false;
            valid = false;
            checkValid = false;
            discount = 0;
            BlocProvider.of<GirlAppointmentCubit>(context).discountt =0;
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
          BlocProvider.of<GirlAppointmentCubit>(context).discountt = 0;
        });
      }
    }
  }

  getDate() async {
    try {
      if (DateTime(selectedDate.year, selectedDate.month, selectedDate.day)
              .isBefore(DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day)) ||
          (!widget.consultant.workDays!
              .contains(selectedDate.weekday.toString())))
        setState(() {
          loadDates = false;
          todayAppointmentList = [];
          dateText = getTranslated(context, "selectData");
        });
      else {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection(Paths.consultDaysPath)
            .doc(time + "-" + widget.consultant.uid!)
            .get();
        if (documentSnapshot.exists) {
          ConsultDays consultDays =
              ConsultDays.fromMap(documentSnapshot.data() as Map);
          List<String> appointmentList = [];

          for (int start = 0;
              start < consultDays.todayAppointmentList.length;
              start++) {
            if (DateTime.parse(consultDays.todayAppointmentList[start])
                .toLocal()
                .isAfter(DateTime.now())) {
              appointmentList.add(consultDays.todayAppointmentList[start]);
            }
          }
          print('================l $todayAppointmentList');

          setState(() {
            loadDates = false;
            todayAppointmentList = appointmentList;
            if (todayAppointmentList.length == 0) {
              dateText = getTranslated(context, "noAppointment");
            } else {
              // selectedTime = todayAppointmentList.first;
              selectedCard = 0;
            }
          });
        } else {
          var from = DateTime(selectedDate.year, selectedDate.month,
              selectedDate.day, widget.localFrom);
          var to = DateTime(selectedDate.year, selectedDate.month,
              selectedDate.day, widget.localTo);

          /// ttt is difference between start and end time of the teacher.
          var ttt = (to.difference(from).inHours).round();
          if (ttt <= 0) {
            to = DateTime(
                selectedDate.year, selectedDate.month, selectedDate.day, 24);
            ttt = (to.difference(from).inHours).round();
          }
          List<String> appointmentList = [];
          var lessonTime = 3;
          var lessonMintes = 20;
          for (int start = 0; start < ttt * lessonTime; start++) {
            if (from
                .add(Duration(minutes: start * lessonMintes))
                .isAfter(DateTime.now())) {
              var value = from.add(Duration(minutes: start*lessonMintes)).toUtc().toString();
              appointmentList.add(value);
            }
          }
          await FirebaseFirestore.instance
              .collection(Paths.consultDaysPath)
              .doc(time + "-" + widget.consultant.uid!)
              .set({
            'id': time + "-" + widget.consultant.uid!,
            'day': time,
            'date': DateTime(
                    selectedDate.year, selectedDate.month, selectedDate.day)
                .millisecondsSinceEpoch,
            'consultUid': widget.consultant.uid,
            'todayAppointmentList': appointmentList,
          });
          setState(() {
            loadDates = false;
            todayAppointmentList = appointmentList;
            // selectedTime = todayAppointmentList.first;
            selectedCard = 0;
          });
        }
      }
    } catch (e) {
      print("startnew12ddd" + e.toString());
      String id = Uuid().v4();
      await FirebaseFirestore.instance
          .collection(Paths.errorLogPath)
          .doc(id)
          .set({
        'timestamp': Timestamp.now(),
        'id': id,
        'seen': false,
        'desc': e.toString(),
        'phone':
            widget.loggedUser == null ? " " : widget.loggedUser.phoneNumber,
        'screen': "ConsultantDetailsScreen",
        'function': "getDate",
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    try {
      // Get the current date
      final DateTime now = DateTime.now();

      // Create a new DateTime object with only the year, month, and day (time is set to 00:00:00)
      final DateTime currentDate = DateTime(now.year, now.month, now.day);
      final DateTime? picked = await showDatePickerDialog(

        contentPadding: EdgeInsets.zero,
        context: context,
        initialDate: selectedDate,
        minDate: currentDate,
        maxDate: DateTime(2061, 10, 30),
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
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
          time = DateFormat('yyyy-MM-dd').format(picked);
          displayedTime = time;
          loadDates = true;
          todayAppointmentList = [];
          dateText = getTranslated(context, "load");
          showDayError = false;
        });
        getDate();
      }
    } catch (e) {
      String id = Uuid().v4();
      // await FirebaseFirestore.instance
      //     .collection(Paths.errorLogPath)
      //     .doc(id)
      //     .set({
      //   'timestamp': Timestamp.now(),
      //   'id': id,
      //   'seen': false,
      //   'desc': e.toString(),
      //   'phone':
      //       widget.loggedUser == null ? " " : widget.loggedUser.phoneNumber,
      //   'screen': "ConsultantDetailsScreen",
      //   'function': "_selectDate",
      // });
    }
  }

  Future<Null> _selectHijriDate(BuildContext context) async {
    try {
      var currentHijirDate=new HijriCalendar.now();
      final HijriCalendar? picked = await showHijriDatePicker(
        context: context,
        initialDate: currentHijirDate,
        lastDate: new HijriCalendar()
          ..hYear = currentHijirDate.hYear+1
          ..hMonth = currentHijirDate.hMonth
          ..hDay = currentHijirDate.hDay,
        firstDate: currentHijirDate,
        initialDatePickerMode: DatePickerMode.day,
      );
      if (picked != null) {
        setState(() {
          selectedDate = HijriCalendar()
              .hijriToGregorian(picked.hYear, picked.hMonth, picked.hDay);
          time = DateFormat('yyyy-MM-dd').format(selectedDate);
          displayedTime = picked.toString();
          loadDates = true;
          todayAppointmentList = [];
          dateText = getTranslated(context, "load");
          showDayError = false;
        });
        getDate();
      }
    } catch (e) {
      print("errorooooooo"+e.toString());
    }
  }
}
