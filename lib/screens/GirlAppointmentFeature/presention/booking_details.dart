import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/consultPackage.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/GirlAppointmentFeature/utils/service/GirlAppointmentCubit/girl_appointment_cubit.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/screens/GirlAppointmentFeature/presention/girl_appointment_dialog.dart';
import '../../CoacheAppoinmentFeature/presention/widget/appointmentDialogwidget/text_dialog.dart';
import '../../CoacheAppoinmentFeature/utils/payment_types.dart';
import 'widget/choose_call_type_widget.dart';
import 'widget/dialogs/not_allowed_video_dialog.dart';
import 'widget/girl_appointment_avilalble_hour.dart';
import 'widget/dialogs/change_type_to_seeker_for_wife.dart';
import 'widget/confirm_connection_buttom.dart';
import 'widget/dialogs/confirm_dialog_not_valid_user.dart';
import 'widget/girl_avilable_days_builder_widget.dart';
import 'widget/text_title_with_fram.dart';

class GirlBookingDetails extends StatefulWidget {
  const GirlBookingDetails({
    super.key,
    required this.load,
    required this.loggedUser,
    required this.consultant,
    required this.validPartner,
  });

  final GroceryUser consultant;
  final bool validPartner;
  final bool load;
  final GroceryUser? loggedUser;

  @override
  State<GirlBookingDetails> createState() => _GirlBookingDetailsState();
}

class _GirlBookingDetailsState extends State<GirlBookingDetails> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = new TextEditingController();
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
  dynamic price=30, discount = 0;
  late Size size;
  GroceryUser? consultant;
  String? theme;
  int callNum = 0;

  bool loadVIdeoList = true;

  ScrollController _scrollController = new ScrollController();
  String? lang;
  String type="";
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
    order = consultPackage(
        Id: Uuid().v4(),
        consultUid: widget.consultant.uid!,
        active: true,
        price: 30,
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
        ? GirlAppointmentDialig(
            loggedUser: widget.loggedUser!,
            consultant: widget.consultant,
            package: order,
            localFrom: localFrom,
            localTo: localTo,
            getData: getDataFromDialog,
            backFromBooking: backFromBooking,
          )
        : Column(
            children: [
              TextTitleWithFram(title: getTranslated(context, "workTime")),
              //days
              GirlAvilableDaysBuilderWidget(consultant: widget.consultant),
              //Clock
              GirlClockWidget(consultant: widget.consultant),
              //call
              SizedBox(
                height: AppSize.h32.h,
              ),
              // CallType
              ChooseCallType(
                onPressVideo: () {
                  setState(() {
                    type = "video";
                  });
                },
                type: type,
                onPressVoice: () {
                  setState(() {
                    type = "audio";
                  });
                },
              ),

              SizedBox(
                height: AppSize.h64.h,
              ),
              //Confirm Connection Button
              load
                  ? Center(child: CircularProgressIndicator())
                  : ConfirmConnectionButtom(
                      onPress: () async {
                        if (widget.loggedUser == null)
                          Navigator.pushNamed(context, '/Register_Type');
                        else if (widget.loggedUser!.userType == "COACH" ||
                            widget.loggedUser!.userType == "CLIENT")
                          changeTypeDialog(context, widget.loggedUser);
                        else if (type == "")
                          Fluttertoast.showToast(
                              msg: getTranslated(context, "selectCallType"),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        else if (type == "video" &&
                            widget.loggedUser!.userConsultIds == null) {
                          Fluttertoast.showToast(
                              msg: getTranslated(context, "audioFirst"),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (type == "video" &&
                            widget.loggedUser!.userConsultIds != null &&
                            (!(widget.loggedUser!.userConsultIds!
                                .contains(widget.consultant.uid!)))) {
                          notAllowedVideoDialog(context);
                        } else if (widget.loggedUser != null &&
                            currentNumber == 0 &&
                            widget.validPartner == false) {
                          confirmDialogNotValidUser(context, () async {
                            Navigator.pop(context);
                            book = !book;
                            setState(() {});
                          });
                        } else if (widget.loggedUser != null &&
                            currentNumber == 0 &&
                            widget.validPartner) {
                          book = !book;
                          setState(() {});
                          // orderPay();
                        } else {
                          book = !book;
                          setState(() {});
                          // showAddAppointmentDialog(
                          //     order!.orderId, order!.callPrice);
                        }
                      },
                    ),
              SizedBox(
                height: AppSize.h89_3.h,
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
    String? promoCodeId,
    required double totalPrice,
  }) async {
    this.price = totalPrice;
    this.currentNumber = currentNumber;
    this._selectedDateCard = selectedCard;
    this._time = time;
    this._todayAppointmentList = todayAppointmentList;
    this._selectedDate = date;
    this.promoCodeId=promoCodeId;
    final girlAppointmentCubit = BlocProvider.of<GirlAppointmentCubit>(context);
    switch (paymentType) {
      case PaymentTypes.balance:
        customTextDialog(
          text: getTranslated(context, 'payFromBalanceNote'),
          buttonText: getTranslated(context, 'Ok'),
          context: context,
          okFunction: () async {
            Navigator.pop(context);
            try {
              girlAppointmentCubit.consultant = widget.consultant;
              girlAppointmentCubit.user = widget.loggedUser!;
              await girlAppointmentCubit.userBalancePayment(context: context, pricee:totalPrice, 
        consultType:type,promoCodeId:promoCodeId,);
             // Navigator.pop(context);

            } catch (e) {
              print("qqqqqq ${e.toString()}");
              customTextDialog(
                context: context,
                buttonText: getTranslated(context, 'Ok'),
                text:getTranslated(context, 'error'),
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
        girlAppointmentCubit.consultant = widget.consultant;
        girlAppointmentCubit.user = widget.loggedUser!;
        await girlAppointmentCubit.stripePayment( context: context, pricee:totalPrice, 
        consultType:type,promoCodeId:promoCodeId,);
        break;

      case PaymentTypes.tapCompany:
      girlAppointmentCubit.consultant = widget.consultant;
        girlAppointmentCubit.user = widget.loggedUser!;
        await girlAppointmentCubit.pay(order.price);
        break;
    }
  }
}
