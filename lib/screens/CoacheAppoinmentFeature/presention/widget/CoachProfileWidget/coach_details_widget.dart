import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/consultPackage.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/widget/appointmentDialogwidget/text_dialog.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/widget/dialogs/confirm_complete_profile_dialog.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/utils/payment_types.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/utils/service/CoachAppointmentCubit/coach_appointment_cubit.dart';
import 'package:grocery_store/widget/about_me_widget.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/reviewWidget.dart';
import 'package:uuid/uuid.dart';

import '../../coach_appointment_dialog.dart';
import 'coach_book_bottom.dart';
import 'coach_clock_widget.dart';
import 'coach_days_widget.dart';
import 'coach_price_widget.dart';

class CoachDetailsWidget extends StatefulWidget {
  const CoachDetailsWidget({
    super.key,
    required this.load,
    required this.user,
    required this.consultant,
  });

  final GroceryUser consultant;

  final bool load;
  final GroceryUser? user;

  @override
  State<CoachDetailsWidget> createState() => _CoachDetailsWidgetState();
}

class _CoachDetailsWidgetState extends State<CoachDetailsWidget> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = new TextEditingController();
  GroceryUser? user;
  int currentNumber = 0;
  List<consultPackage> packages = [];
  bool fristinit = true;
  late dynamic callsValue;

  bool first = true,
      showPayView = false,
      load = false,
      valid = false,
      checkPromo = false,
      loadReviews = true,
      loadPackage = true,
      fromBalance = false;
  bool chating = false, sharing = false, selected = false;
  late String initialUrl = '', userImage, orderId2, userName = "dreamUser";
  consultPackage? package;
  bool loadScreen = true;
  String? promoCodeId;
  dynamic price, discount = 0;
  late Size size;
  GroceryUser? consultant;
  String? theme;
  int callNum = 0;

  bool loadVIdeoList = true;

  ScrollController _scrollController = new ScrollController();
  String? lang;
  bool showBookingSection = false;
  int _selectedDateCard = -1;
  String? _time;
  List<dynamic> _todayAppointmentList = [];
  DateTime? _selectedDate;
  List<dynamic> consultantCourses = [];
  String? courseId;
  var index;
  /////////////////////////////////////////
  late int localFrom;
  late int localTo;
  late consultPackage order;

  bool book = false;
  @override
  void initState() {
    localFrom = DateTime.parse(widget.consultant.fromUtc!).toLocal().hour;
    localTo = DateTime.parse(widget.consultant.toUtc!).toLocal().hour;
   order= consultPackage(
                Id: Uuid().v4(),
                consultUid: widget.consultant.uid!,
                active: true,
                price: price,
                discount: 0,
                callNum: 1);
    super.initState();
  }

  void backFromBooking({
    required bool backFromBooking,
  }) {
    if (backFromBooking == true) {
      setState(() {
        book = false;
        package = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return book
        ? CoachAppointment(
            loggedUser: widget.user!,
            consultant: widget.consultant,
            package:order ,
            localFrom: localFrom,
            localTo: localTo,
            getData: getDataFromDialog,
            backFromBooking: backFromBooking,
          )
        : Column(
            children: [
              AboutMeWidget(consultant: widget.consultant),
              SizedBox(
                height: AppSize.h32.h,
              ),
              ReviewWidget(consultant: widget.consultant),
              //days
              CoachDaysWidget(consultant: widget.consultant),
              //clock
              CoachClockWidget(consultant: widget.consultant),
              //call Price
              CoachPriceWidget(consultant: widget.consultant),

              widget.load
                  ? Center(child: CircularProgressIndicator())
                  : CoachBookBottom(
                      onPress: () {
                        if (widget.user == null) {
                          Navigator.pushNamed(context, '/Register_Type');
                        } else if (widget.user!.profileCompleted == false)
                          ConfirmCompleteProfile(context, widget.user);
                        else {
                          print("object");
                          book = true;
                          setState(() {});
                        }
                      },
                    ),
            ],
          );
  }

  Future<void> getDataFromDialog({
    required DateTime date,
    required int selectedCard,
    required String time,
    required List<dynamic> todayAppointmentList,
    required PaymentTypes paymentType,
    required double totalPrice,
    String? promoCodeId,
  }) async {
    this.price = totalPrice;
    this.currentNumber = currentNumber;
    this._selectedDateCard = selectedCard;
    this._time = time;
    this._todayAppointmentList = todayAppointmentList;
    this._selectedDate = date;
    this.promoCodeId=promoCodeId;
  final coachAppointmentCubit =
                BlocProvider.of<CoachAppointmentCubit>(context);
    switch (paymentType) {
      case PaymentTypes.balance:
        customTextDialog(
          text: getTranslated(context, 'payFromBalanceNote'),
          buttonText: getTranslated(context, 'Ok'),
          context: context,
          okFunction: () async {
          
            Navigator.pop(context);
            try {
              coachAppointmentCubit.consultant = widget.consultant;
              coachAppointmentCubit.user = widget.user!;
              await coachAppointmentCubit.userBalancePayment(context,totalPrice,promoCodeId);
              //  (totalPrice);
            } catch (e) {
              customTextDialog(
                context: context,
                buttonText: getTranslated(context, 'Ok'),
                text: getTranslated(context, 'error'),
                okFunction: () {
                  Navigator.pop(context);
                },
              );
              print('error from pay');
            }
            // Navigator.pop(context);
          },
        );
        break;

      case PaymentTypes.stripe:
      print("==============totalPrice"+totalPrice.toString());
      print(promoCodeId);
              coachAppointmentCubit.consultant = widget.consultant;
              coachAppointmentCubit.user = widget.user!;
              await coachAppointmentCubit.stripePayment(price: totalPrice , context: context,promoCodeId:promoCodeId);
        break;

      case PaymentTypes.tapCompany:
         await  coachAppointmentCubit.pay(order);
        break;
    }
  }
}
