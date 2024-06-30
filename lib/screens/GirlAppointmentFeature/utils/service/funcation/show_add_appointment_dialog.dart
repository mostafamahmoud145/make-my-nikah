import 'package:flutter/material.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/addAppointmentDialog.dart';

showAddAppointmentDialog(
    {required String orderId,
    required dynamic callPrice,
    context,
    required GroceryUser loggedUser,
    required GroceryUser consultant,
    String? type,
    required int localFrom,
    required int localTo}) async {
  bool isProceeded = await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AddAppointmentDialog(
          loggedUser: loggedUser,
          consultant: consultant,
          localFrom: localFrom,
          localTo: localTo,
          type: type!,
          orderId: orderId,
          callPrice: callPrice);
    },
  );
  return isProceeded;

  // if (isProceeded != null) {
  //   if (isProceeded) {
  //     setState(() {
  //       load = false;
  //     });
  //   }
  // }
}
