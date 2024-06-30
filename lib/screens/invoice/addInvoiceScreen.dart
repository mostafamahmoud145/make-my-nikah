

import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../../config/colorsFile.dart';

class AddInvoiceScreen extends StatefulWidget {

  AddInvoiceScreen();
  @override

  _AddInvoiceScreenState createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? owner,
      code,
      discount,
      theme = "light";
  bool createInvoiceDone=false;

  @override
  void initState() {
    super.initState();
    createInvoiceDone=false;
  }


  Future<void> createInvoice({String? email, String? name}) async {
    try {
      var response = await http.post( Uri.parse(
          'https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/sendInvoice'),
          body: {
            'name' :nameController.text,
            'email':emailController.text,
          },
      );

      String responseBody = response.body;
      var res = json.decode(responseBody);
      print(res['messageData']);

    } catch (e) {
      print("createInvoice111  " + e.toString());
    }
  }
  TextEditingController nameController = TextEditingController();
  TextEditingController consultantNameController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController expireDateController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var due, expire;
  GroceryUser? user;
  List<GroceryUser> users = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
            child: Column(
              //  crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 80),
                    color: Colors.black45,
                    width: 60,
                    height: 1,
                  ),
                ),
                SizedBox(height: 6),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 80),
                    color: Colors.black45,
                    width: 100,
                    height: 1,
                  ),
                ),
                Text(getTranslated(context, "createInvoice"),
                  style: TextStyle(
                    color:AppColors.reddark2,
                    fontFamily: getTranslated(context,"fontFamily"),
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 80),
                    color: Colors.black45,
                    width: 100,
                    height: 1,
                  ),
                ),
                SizedBox(height: 6),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 80),
                    color: Colors.black45,
                    width: 60,
                    height: 1,
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: nameController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return getTranslated(context, "plsEnterClientName");
                    }
                    return null;
                  },
                  onSaved: (val) {},
                  enableInteractiveSelection: true,
                  style: TextStyle(
                    fontFamily: getTranslated(context,"fontFamily"),
                    color: Colors.black,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.0),
                    helperStyle: TextStyle(
                      fontFamily: getTranslated(context,"fontFamily"),
                      color: Colors.black.withOpacity(0.65),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    errorStyle: TextStyle(
                      fontFamily: getTranslated(context,"fontFamily"),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    hintStyle: TextStyle(
                      fontFamily: getTranslated(context,"fontFamily"),
                      color: Colors.black54,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    labelText: getTranslated(context, "clientName"),
                    labelStyle: TextStyle(
                        fontFamily: getTranslated(context,"fontFamily"),
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: AppColors.grey2
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                // TextFormField(
                //   controller: emailController,
                //   textAlignVertical: TextAlignVertical.center,
                //   textAlign: TextAlign.center,
                //   validator: (value) {
                //     if (value.isEmpty) {
                //       return getTranslated(context, "plsEnterClientEmail");
                //     }
                //   },
                //   onSaved: (val) {},
                //   enableInteractiveSelection: true,
                //   style: TextStyle(
                //     fontFamily: getTranslated(context,"fontFamily"),
                //     color: Colors.black,
                //     fontSize: 14.5,
                //     fontWeight: FontWeight.w500,
                //     letterSpacing: 0.5,
                //   ),
                //   textInputAction: TextInputAction.done,
                //   keyboardType: TextInputType.emailAddress,
                //   textCapitalization: TextCapitalization.words,
                //   decoration: InputDecoration(
                //     contentPadding:
                //     EdgeInsets.symmetric(horizontal: 15.0),
                //     helperStyle: TextStyle(
                //       fontFamily: getTranslated(context,"fontFamily"),
                //       color: Colors.black.withOpacity(0.65),
                //       fontWeight: FontWeight.w500,
                //       letterSpacing: 0.5,
                //     ),
                //     errorStyle: TextStyle(
                //       fontFamily: getTranslated(context,"fontFamily"),
                //       fontSize: 13.0,
                //       fontWeight: FontWeight.w500,
                //       letterSpacing: 0.5,
                //     ),
                //     hintStyle: TextStyle(
                //       fontFamily: getTranslated(context,"fontFamily"),
                //       color: Colors.black54,
                //       fontSize: 14.5,
                //       fontWeight: FontWeight.w500,
                //       letterSpacing: 0.5,
                //     ),
                //     labelText: getTranslated(context, "clientaccount"),
                //     labelStyle: TextStyle(
                //         fontFamily: getTranslated(context,"fontFamily"),
                //         fontSize: 14.5,
                //         fontWeight: FontWeight.w500,
                //         letterSpacing: 0.5,
                //         color: AppColors.grey2
                //     ),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(5.0),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 30,
                // ),
                TextFormField(
                  controller: phoneController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return getTranslated(context, "plsEnterClientPhone");
                    }
                    return null;
                  },
                  onSaved: (val) {},
                  enableInteractiveSelection: true,
                  style: TextStyle(
                    fontFamily: getTranslated(context,"fontFamily"),
                    color: Colors.black,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.0),
                    helperStyle: TextStyle(
                      fontFamily: getTranslated(context,"fontFamily"),
                      color: Colors.black.withOpacity(0.65),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    errorStyle: TextStyle(
                      fontFamily: getTranslated(context,"fontFamily"),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    hintStyle: TextStyle(
                      fontFamily: getTranslated(context,"fontFamily"),
                      color: Colors.black54,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    labelText: getTranslated(context, "phoneNumber"),
                    labelStyle: TextStyle(
                        fontFamily: getTranslated(context,"fontFamily"),
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: AppColors.grey2
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: priceController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return getTranslated(context, "required");
                    }
                    return null;
                  },
                  onSaved: (val) {},
                  enableInteractiveSelection: true,
                  style: TextStyle(
                    fontFamily: getTranslated(context,"fontFamily"),
                    color: Colors.black,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.0),
                    helperStyle: TextStyle(
                      fontFamily: getTranslated(context,"fontFamily"),
                      color: Colors.black.withOpacity(0.65),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    errorStyle: TextStyle(
                      fontFamily: getTranslated(context,"fontFamily"),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    hintStyle: TextStyle(
                      fontFamily: getTranslated(context,"fontFamily"),
                      color: Colors.black54,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    labelText: getTranslated(context, "price"),
                    labelStyle: TextStyle(
                        fontFamily: getTranslated(context,"fontFamily"),
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: AppColors.grey2
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: ()  async{
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            createInvoiceDone=true;
                          });
                          createInvoice(email: emailController.text,name: nameController.text);
                          postInvoice(
                             // email: emailController.text,
                             // expiry: expireDateController.text,
                              phone: phoneController.text,
                              price: priceController.text,
                              userName: nameController.text
                          );
                       }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            createInvoiceDone ==true ? CircularProgressIndicator():Container(
                              width: size.width*.30,
                              height: size.height*.06,
                              decoration: BoxDecoration(
                                color: AppColors.reddark2,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5)),
                              ),
                              child: Center(
                                child: Text(
                                  getTranslated(context, "save"),
                                  style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: size.width*.05,),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width*.30,
                              height: size.height*.06,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.all(color:AppColors.grey4),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5)),
                              ),
                              child: Center(
                                child: Text(
                                  getTranslated(context, "endInvoice"),
                                  style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                                    color:AppColors.reddark2,
                                    fontSize: 15.0,
                                    //fontWeight: FontWeight.bold,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }

  postInvoice({
    required String userName,
    required String price,
    required var phone,
  }) async {

    String phones = phone + "@gmail.com";

    var res;

    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(Paths.usersPath)
          .where( 'phoneNumber', isEqualTo: phoneController.text, ).get();

      for (var doc in querySnapshot.docs) {
        users.add(GroceryUser.fromMap(doc.data() as Map));
      }
      if(users.length>0)
      {
        user=users[0];
        var dueDate=DateTime.now().add(Duration(minutes: 10));
        var expireDate=DateTime.now().add(Duration(days: 3));

        try {
          var response = await http.post( Uri.parse(
              'https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/sendInvoice'),
            body: {
              'name' :nameController.text,
              'email':phones,
              'amount':(int.parse(priceController.text)*100).toString()
            },
          );

          String responseBody = response.body;
           res = json.decode(responseBody);
          print(res['messageData']);

        } catch (e) {
          print("createInvoice111  " + e.toString());
        }

        String invoiceId = res['messageData']['id'];
        await FirebaseFirestore.instance.collection(Paths.invoicePath) .doc(invoiceId).set({
          'user': {
            'uid': user!.uid,
            'name': userName,
            'image': user!.photoUrl,
            'phone': phone,
            'countryCode': user!.countryCode,
            'countryISOCode': user!.countryISOCode,
          },
          'id':res['id'],
          'expiry':expireDate,
          'email':phone + "@gmail.com",
          'price':priceController.text,
          'invoice':res['messageData']['hosted_invoice_url'],
          'timestamp':DateTime.now(),
          "invoiceId":invoiceId,
        }).then((value){
          Fluttertoast.showToast(
            msg: getTranslated(context, "invoiceCreatedDone"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          print(expireDate.microsecondsSinceEpoch);
          print(dueDate.microsecondsSinceEpoch);
          Navigator.pop(context);
        }).catchError((error){
          Fluttertoast.showToast(
            msg: getTranslated(context, "invoiceDataError"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          setState(() {
            createInvoiceDone=false;
          });
        });

      }
      else{
        //flutter toast
        Fluttertoast.showToast(
          msg: getTranslated(context, "invoiceDataError"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() {
          createInvoiceDone=false;
        });
      }

    }catch(e){
      Fluttertoast.showToast(
        msg: getTranslated(context, "invoiceCreatedError"),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

}

