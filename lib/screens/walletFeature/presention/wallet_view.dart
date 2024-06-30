import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/walletFeature/presention/widget/balance_wallet_tag.dart';
import 'package:grocery_store/screens/walletFeature/presention/widget/history_wallet_tag.dart';
import 'package:grocery_store/screens/walletFeature/presention/widget/title_widget.dart';
import 'package:grocery_store/screens/walletFeature/presention/widget/wallet_Tab_Buttom_widget.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../../../config/assets_manager.dart';
import '../../../config/app_values.dart';
import '../../../config/colorsFile.dart';

import '../../../widget/app_bar_widget.dart';

class WalletView extends StatefulWidget {
  final GroceryUser loggedUser;

  const WalletView({Key? key, required this.loggedUser}) : super(key: key);

  @override
  _WalletViewState createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView>
    with SingleTickerProviderStateMixin {
  bool load = false, showBalance = true, showHistory = false;
  bool saving = false, showPayView = false;
  late GroceryUser searchUser, user;
  late AccountBloc accountBloc;
  late String balance = "0";
  int _stackIndex = 1;

  String lang = "";

  @override
  void initState() {
    super.initState();
    accountBloc = BlocProvider.of<AccountBloc>(context);
    accountBloc.add(GetLoggedUserEvent());
    accountBloc.stream.listen((state) {
      print(state);
      if (state is GetLoggedUserCompletedState) {
        user = state.user;
        if (mounted)
          setState(() {
            load = false;
          });
        if (user != null &&
            user.photoUrl != null &&
            user.photoUrl != "") if (mounted)
          setState(() {
            balance = user.balance.toString();
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    lang = getTranslated(context, "lang");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white1,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              width: size.width,
              child: AppBarWidget2(
                text: getTranslated(context, "wallet"),
              ),
            ),
            SizedBox(height: AppSize.h21_3.h,),
            Center(
              child: Container(
                  color: AppColors.white3,
                  height: AppSize.h1.h,
                  width: size.width),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: AppSize.h32.h, bottom: AppSize.h32.h),
              child: SvgPicture.asset(
                AssetsManager.paymentImagePath,
                width: AppSize.w178.w,
                height: AppSize.h206_1.h,
              ),
            ),
            AddBalanceText(),
            SizedBox(height: AppSize.h32.h),
            WalletTabBar(
              showBalance: showBalance,
              showHistory: showHistory,
              onpressedAddBalance: () {
                setState(() {
                  this.showBalance = !showBalance;
                  this.showHistory = !showHistory;
                });
              },
              onpressedPaymentHistory: () {
                setState(() {
                  this.showBalance = !showBalance;
                  this.showHistory = !showHistory;
                });
              },
            ),
            SizedBox(
              height: showHistory ? AppSize.h22.h : AppSize.h32.h,
            ),
            Visibility(
              visible: showBalance,
              child: BalanceWallet(
                  loggedUser: widget.loggedUser, saving: saving),
            ),
            Visibility(
              visible: showHistory,
              child: HistoryWallet(loggedUser: widget.loggedUser),
            )
          ],
        ),
      ),
    );
  }
}
