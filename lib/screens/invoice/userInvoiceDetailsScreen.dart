import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/InvoiceModel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../config/colorsFile.dart';

class UserInvoiceItem extends StatefulWidget {
Invoice invoice;
UserInvoiceItem({required this.invoice});

  @override
  State<UserInvoiceItem> createState() => _UserInvoiceItemState();
}

class _UserInvoiceItemState extends State<UserInvoiceItem> {
String status=" ";
bool load=true;
  void initState() {
    checkStatus();
    super.initState();

  }
  checkStatus() async {
    try{
      print("payStatusqqqq");

      var response = await http.post( Uri.parse(
          'https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/getInvoice'),
        body: {
          'id' :widget.invoice.invoiceId,
        },
      );


      String responseBody = response.body;
      var res = json.decode(responseBody);
      print(res);
      print(res['invoiceData']['status']);
      setState(() {
        status=res['invoiceData']['status'];
        load=false;
      });
    }catch(e){
print("payStatusqqqq000");
print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    DateFormat dateFormat = DateFormat('dd/MM/yy');
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top:50,left: 20,right:20),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [

                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Image.asset(
                            getTranslated(context, "back"),
                            width: 30,
                            height: 30,
                          ),
                        ),
                        Text(getTranslated(context, "invoices"),
                          style: TextStyle(
                            color: AppColors.reddark2,
                            fontFamily: getTranslated(context,"fontFamily"),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: (){
                          Clipboard.setData(ClipboardData(text: widget.invoice.invoice!));
                          Fluttertoast.showToast(
                            msg: getTranslated(context, "textCopy"),
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 5,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );

                        },
                        icon:Icon(Icons.copy,color: AppColors.reddark2,)),
                  ],
                ),
                SizedBox(height:40),
                Stack(alignment: Alignment.center,children: [
                  Container(
                    height: 81,
                    width: 81,
                    child: Image.asset('assets/icons/icon/Mask Group 47.png',width: 40,height: 40,fit:BoxFit.fill,)
                  ),
                  //Image.asset('assets/icons/icon/dashBorder.png',width: 86,height: 86,)
                ], ),
                SizedBox(height:15),
                Text(widget.invoice.user!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColors.black2,
                        fontSize: 13,
                        fontWeight: FontWeight.w600
                    )),
                SizedBox(height:50),
                Card(
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),),
                  elevation:2,
                  shadowColor: Theme.of(context).primaryColor,
                  color: Colors.white,
                  child: Container(
                    width: size.width*8,
                    //height: size.height*.39,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(getTranslated(context, "clientName"),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.reddark2,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                  )),
                              Spacer(),
                              Text(widget.invoice.user!.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.black2,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                  )),
                            ],
                          ),
                          SizedBox(height:20),
                          Row(
                            children: [
                              Text(getTranslated(context, "clientaccount"),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.reddark2,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                  )),
                              Spacer(),
                              Text(widget.invoice.email!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color:  AppColors.black2,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                  )),
                            ],
                          ),
                          SizedBox(height:20),
                          Row(
                            children: [
                              Text(getTranslated(context, "phoneNumber"),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.reddark2,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                  )),
                              Spacer(),
                              Text(widget.invoice.user!.phone,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.black2,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                  )),
                            ],
                          ),
                          SizedBox(height:20),
                          Row(
                            children: [
                              Text(getTranslated(context, "due"),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.reddark2,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                  )),
                              Spacer(),
                              Text('${dateFormat.format(widget.invoice.timestamp!.toDate())}',
                                  //'${dateFormat.format(widget.invoice.due.toDate())}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.black2,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                  )),
                            ],
                          ),
                          SizedBox(height:20),
                          Row(
                            children: [
                              Text(getTranslated(context, "expireDate"),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.reddark2,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                  )),
                              Spacer(),
                              Text('${dateFormat.format(widget.invoice.expire!.toDate())}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.black2,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                  )),
                            ],
                          ),
                          SizedBox(height:20),
                          Row(
                            children: [
                              Text(getTranslated(context, "price"),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.reddark2,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                  )),
                              Spacer(),
                              Text(widget.invoice.price,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.black2,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                  )),
                            ],
                          ),
                          SizedBox(height:20),
                          Row(
                            children: [
                              Text(getTranslated(context, "status"),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.reddark2,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                  )),
                              Spacer(),
                              load?CircularProgressIndicator(): Text(status,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.black2,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                  )),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

