import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/models/coursePackage.dart';
import 'package:grocery_store/models/courses.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/widget/appointmentDialogwidget/text_dialog.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/utils/payment_types.dart';
import 'package:grocery_store/screens/PayCoursesFeature/utils/service/PayCourseCubit/pay_course_cubit.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:uuid/uuid.dart';
import '../../../../../localization/localization_methods.dart';
import '../../../../../models/user.dart';
import '../../buy_couse_dialog.dart';

class BuyCourseWidget extends StatefulWidget {
  const BuyCourseWidget({super.key, required this.user, required this.course});

  final Courses course;
  final GroceryUser user;

  @override
  State<BuyCourseWidget> createState() => _BuyCourseWidgetState();
}

class _BuyCourseWidgetState extends State<BuyCourseWidget> {
  dynamic price, discount = 0;
  late CoursePackage order;

  bool book = false;
  @override
  void initState() {
    order = CoursePackage(
      id: Uuid().v4(),
      active: true,
      price: price,
      discount: 0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: AppSize.h50.h,
        ),
        BuyCouseDialog(
          course: widget.course,
          loggedUser: widget.user,
          package: order,
          getData: getDataFromDialog,
        ),
      ],
    );
  }

  Future<void> getDataFromDialog({
    required PaymentTypes paymentType,
    required double totalPrice,
    String? promoCodeId,
  }) async {
    this.price = totalPrice;
    final payCourseCubit = BlocProvider.of<PayCourseCubit>(context);
    switch (paymentType) {
      case PaymentTypes.balance:
        customTextDialog(
          text: getTranslated(context, 'payFromBalanceNote'),
          buttonText: getTranslated(context, 'Ok'),
          context: context,
          okFunction: () async {
            Navigator.pop(context);
            try {
              payCourseCubit.user = widget.user;
              payCourseCubit.course = widget.course;
              await payCourseCubit.userBalancePayment(context, totalPrice,promoCodeId);
              //  (totalPrice);
            } catch (e) {
              print('error from pay ${e.toString()}');
            }
            // Navigator.pop(context);
          },
        );
        break;

      case PaymentTypes.stripe:
        payCourseCubit.user = widget.user;
        payCourseCubit.course = widget.course;
        await payCourseCubit.stripePayment(price: totalPrice,promoCodeId:promoCodeId, context: context);
        break;

      case PaymentTypes.tapCompany:
        payCourseCubit.user = widget.user;
        payCourseCubit.course = widget.course;
        await payCourseCubit.pay(order);
        break;
    }
  }
}
