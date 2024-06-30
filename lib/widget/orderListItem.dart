

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/order.dart';
import 'package:grocery_store/screens/orderDetailsScreen.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

class OrderListItem extends StatelessWidget {
  final Orders order;
  final String type;
  final bool fromSupport;
  OrderListItem({required this.order, required this.type,  required this.fromSupport});
  @override
  Widget build(BuildContext context) {
    String lang = getTranslated(context, "lang");
    Size size = MediaQuery.of(context).size;
    DateFormat dateFormat = DateFormat('dd/MM/yy');
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${dateFormat.format(order.orderTimestamp.toDate())}',
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                  color:AppColors.grey,
                  fontSize: 15.0,
                  //   fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              //SizedBox(width: 40,),
            ],
          ),
        ),
        InkWell(
          splashColor: Colors.green.withOpacity(0.6),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetails(
                  order: order,
                  type: type,
                  fromSupport: fromSupport,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  type != "USER" ? order.user.name : order.consult.name,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                    color:AppColors.pink,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  )
                              ),
                              // here is circle arrow

                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              DotIndicator(
                                color: AppColors.pink,
                                size: 10,

                              ),
                              SizedBox(width: 20,),
                              Text(
                                getTranslated(context, "packageCall"),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 1,
                                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                  color: Colors.black54,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              //    SizedBox(width: size.width * 0.4,),

                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: SizedBox(
                              height: 20.0,
                              child: SolidLineConnector(
                                color: AppColors.lightGrey,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width:20,
                                height: 20,
                                decoration:  BoxDecoration(
                                  //  border: Border.all(color: AppColors.pink,width: 5),
                                  shape: BoxShape.rectangle,
                                  color: Colors.transparent,
                                ),
                                child: Icon(Icons.check,color: Colors.lightGreen,size: 20,),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                getTranslated(context, "answeredCall"),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 1,
                                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                  color: Colors.black54,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // SizedBox(width: size.width * 0.4,),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: SizedBox(
                              height: 20.0,
                              child: SolidLineConnector(
                                color: AppColors.lightGrey,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DotIndicator(
                                color: AppColors.red,
                                size: 10,
                              ),
                              SizedBox(width: 10,),
                              Text(
                                getTranslated(context, "remainingCall"),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 1,
                                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                  color: Colors.black54,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              //  SizedBox(width: size.width * 0.4,),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                getTranslated(context, "callprice"),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 1,
                                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                  color:AppColors.pink,
                                  fontSize: 15.0,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                double.parse(order.callPrice.toString())
                                    .toStringAsFixed(3) +
                                    "\$",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 1,
                                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                  color:AppColors.pink,
                                  fontSize: 15.0,
                                ),
                              ),
                              //  SizedBox(width: size.width * 0.4,),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: 5,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap:(){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetails(
                                    order: order,
                                    type: type,
                                    fromSupport: fromSupport,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: AppColors.white,
                                  border: Border.all(
                                      color: AppColors.pink,
                                      width: 2
                                  )
                              ),
                              child:Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.pink,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text(
                              order.packageCallNum.toString(),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 1,
                              style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                color: AppColors.pink,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              )
                          ),
                          SizedBox(height: 20,),
                          Text(
                              order.answeredCallNum.toString(),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 1,
                              style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                color: AppColors.pink,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              )
                          ),
                          SizedBox(height: 30,),
                          Text(
                              order.remainingCallNum.toString(),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 1,
                              style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                color:AppColors.pink,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              )
                          ),
                          SizedBox(height: 20,),
                          Container(
                            width: 45,
                            height: 20,
                            decoration: BoxDecoration(
                                color: AppColors.pink,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Text(
                                (order.callPrice * order.packageCallNum).toString() +"\$",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 1,
                                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                  color:AppColors.white,
                                  fontSize: 12.0,
                                  // fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                )
                            ),
                          )


                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
