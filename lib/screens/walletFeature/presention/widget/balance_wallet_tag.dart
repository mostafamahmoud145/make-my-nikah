import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/walletFeature/presention/widget/drow_down_charge_to_widget.dart';
import 'package:grocery_store/screens/walletFeature/presention/widget/pay_buttom_widget.dart';
import 'package:grocery_store/screens/walletFeature/presention/widget/textformfaild_payment_wideget.dart';
import 'package:grocery_store/screens/walletFeature/presention/widget/title_widget.dart';
import 'package:grocery_store/screens/walletFeature/utils/service/strip_cubit/strip_payment_cubit.dart';
import 'package:grocery_store/widget/resopnsive.dart';

class BalanceWallet extends StatefulWidget {
  final GroceryUser loggedUser;
  final bool saving;
  const BalanceWallet(
      {super.key, required this.loggedUser, required this.saving});

  @override
  State<BalanceWallet> createState() => _BalanceWalletState();
}

class _BalanceWalletState extends State<BalanceWallet> {
  dynamic dropdownValue = "0";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? toController = TextEditingController(),
      amountController = TextEditingController();

  @override
  void initState() {
    toController!.text = widget.loggedUser.phoneNumber!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.p32.w,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DrowDownChargeToWidget(
                    onChanged: (String? value) {
                      print("fdfdf");
                      print(value);
                      setState(() {
                        if (value == "0")
                          toController!.text = widget.loggedUser.phoneNumber!;
                        else
                          toController!.text = "";
                        dropdownValue = value;
                      });
                    },
                    dropdownValue: dropdownValue,
                  ),
                  StripTitleWidget(title: getTranslated(context,"To")),
                  Container(
                    height: AppSize.h70_6.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.lightGrey6, width: AppSize.w1.w),
                      borderRadius: BorderRadius.circular(
                        AppRadius.r10_6.r,
                      ),
                    ),
                    child: TextFormFaildPayment(
                      controller: toController,
                      hint: getTranslated(context, "to"),
                      icon: SvgPicture.asset(
                        AssetsManager.phoneIcon,
                        height: AppSize.h32.r,
                        width: AppSize.w32.r,
                      ),
                    ),
                  ),
                  StripTitleWidget(title:getTranslated(context, 'amount')),
                  Container(
                    height: AppSize.h70_6.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.lightGrey6, width: AppSize.w1.w),
                      borderRadius: BorderRadius.circular(
                        AppRadius.r10_6.r,
                      ),
                    ),
                    child: TextFormFaildPayment(
                        icon: Icon(
                          Icons.attach_money,
                          color: AppColors.reddark2,
                          size: AppSize.w32.r,
                        ),
                        controller: amountController,
                        hint: getTranslated(context, 'amount')),
                  ),
                  SizedBox(
                    height: AppSize.h21_3.h,
                  ),
                  widget.saving
                      ? Center(child: CircularProgressIndicator())
                      : PayButtomWidget(
                          onPressed: () async {
                            print(toController!.text);
                         await   BlocProvider.of<StripPaymentCubit>(context).save(
                                
                                toController!.text,
                                amountController!.text,
                                context,
                                _formKey.currentState!.validate(),widget.loggedUser);
                          },
                        ),
                  SizedBox(
                    height: AppSize.h72.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
