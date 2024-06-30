import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/walletFeature/presention/widget/adding_success_dialog.dart';
import 'package:grocery_store/screens/walletFeature/presention/widget/wallet_add_dialoge.dart';
import 'package:grocery_store/screens/walletFeature/presention/widget/wallet_cancel_dialoge.dart';
import 'package:grocery_store/screens/walletFeature/utils/stripe_payment_bottom_sheet.dart';
import 'package:uuid/uuid.dart';
part 'strip_payment_state.dart';

class StripPaymentCubit extends Cubit<StripPaymentState> {
  StripPaymentCubit() : super(StripPaymentInitial());
  late GroceryUser currentUser;
  late GroceryUser searchUser;
  // bool saving = false, showPayView = false;
  late GroceryUser resever;
  String initialUrl = '';
  save(reseverPhone, amount, context, bool valid, currentUserr) async {
    currentUser = currentUserr;
    List<GroceryUser> users = [];
    if (valid) {
      try {
        //get userdata
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection(Paths.usersPath)
            .where(
              'phoneNumber',
              isEqualTo: reseverPhone,
            )
            .where(
              'userType',
              isEqualTo: "USER",
            )
            .get();
        for (var doc in querySnapshot.docs) {
          users.add(GroceryUser.fromMap(doc.data() as Map));
        }
        if (users.length > 0) {
          searchUser = users[0];
          emit(StripPaymentUpdate());
          showAddingBalanceDialoge(
            title: getTranslated(context, "balanceTransfer"),
            msg: getTranslated(context, "SureTransferAmount"),
            amount: amount,
            to: reseverPhone,
            context: context,
            pay: () async {
              try {
                bool isPaymentSuccessful =
                    await bottomSheet(context, amount, reseverPhone);
                if (isPaymentSuccessful) {
                  await updateUserBalanceInFirebase(
                      context, amount, reseverPhone);
                } else {
                  cantAddingDialog(context,
                      data: getTranslated(context, "invalidNumbers"),
                      status: false);
                }
              } catch (e) {
                Navigator.pop(context);
              }
              emit(StripPaymentUpdate());
            },
          );
        } else {
          cantAddingDialog(context,
              data: getTranslated(context, "invalidNumbers"), status: false);
          emit(StripPaymentUpdate());
        }
      } catch (e) {}
    }
  }

  bottomSheet(context, amount, reseverPhone) async {
    String id = Uuid().v4();
    final isPaymentSuccessful = await showModalBottomSheet<bool>(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: StripePaymentBottomSheet(
            loggedUser: currentUser,
            price: double.parse(amount),
            productName:
                "{${currentUser.phoneNumber}_to_$reseverPhone $amount\$_$id}",
            productDesc:
                'money transfair from ${currentUser.phoneNumber} - to - $reseverPhone',
          ),
        );
      },
    );
    return isPaymentSuccessful;
  }

  updateUserBalanceInFirebase(context, amount, reseverPhone) async {
    final accountBloc = BlocProvider.of<AccountBloc>(context);
    //update userBalance
    dynamic balance = double.parse(amount.toString());
    print(balance);
    if (searchUser.balance != null) {
      balance = searchUser.balance! + balance;
      searchUser.balance = balance;
    }
    print("runtimeType ${amount.runtimeType}");
    await FirebaseFirestore.instance
        .collection(Paths.userPaymentHistory)
        .doc(Uuid().v4())
        .set({
      'userUid': currentUser.uid,
      'payType': "send",
      'payDate': Timestamp.now(), //FieldValue.serverTimestamp(),
      'payDateValue': DateTime.now().millisecondsSinceEpoch,
      'amount': double.parse(amount.toString()),
      'otherData': {
        'uid': searchUser.uid,
        'name': searchUser.name,
        'image': searchUser.photoUrl,
        'phone': searchUser.phoneNumber,
      },
    });
    await FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .doc(searchUser.uid)
        .set({
      'balance': balance,
    }, SetOptions(merge: true));
    await FirebaseFirestore.instance
        .collection(Paths.userPaymentHistory)
        .doc(Uuid().v4())
        .set({
      'userUid': searchUser.uid,
      'payType': "receive",
      'payDate': Timestamp.now(), //FieldValue.serverTimestamp(),
      'payDateValue': Timestamp.now().millisecondsSinceEpoch,
      'amount': double.parse(amount.toString()),
      'otherData': {
        'uid': currentUser.uid,
        'name': currentUser.name,
        'image': currentUser.photoUrl,
        'phone': currentUser.phoneNumber,
      },
    });
    Navigator.pop(context);
    addingSuccessDialog(context,
        size: MediaQuery.of(context).size, status: true, amount: amount);
    if (currentUser.phoneNumber == reseverPhone)
      accountBloc.add(GetLoggedUserEvent());
    emit(StripPaymentUpdate());
  }
}
