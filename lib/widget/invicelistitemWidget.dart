import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/order.dart';
import 'package:grocery_store/screens/invoice/userInvoiceDetailsScreen.dart';
import 'package:intl/intl.dart';
import '../config/paths.dart';
import '../models/InvoiceModel.dart';
class InvoiceListItem extends StatelessWidget {
  Invoice invoice;
  InvoiceListItem({required this.invoice });

  @override

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateFormat dateFormat = DateFormat('dd/MM/yy');
    return  Container(
          width: size.width,
          //height:size.height*.067,
          child:  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width:size.width*.40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${invoice.user!.name}',
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppColors.black2,
                                fontSize: 13,
                                fontWeight: FontWeight.w500
                            )),
                        Text('${dateFormat.format(invoice.expire!.toDate())}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                            color: AppColors.grey2,
                            fontSize: 12
                        )),
                      ],
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.reddark2,width: .5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text('${invoice.price +"\$"}',
                          style:TextStyle(
                              color: AppColors.reddark2,
                              fontSize: 13,
                              fontWeight: FontWeight.w600
                          )),
                    ),
                  ),
                  //SizedBox(width:30),
                  InkWell(
                    onTap: (){
                    //  getPromoDetails(userId: invoice.user.uid);
                      Navigator.push(context,MaterialPageRoute(
                          builder: (context)=>UserInvoiceItem(invoice:invoice,)));
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor,width: 1),
                        color: AppColors.reddark2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Icon(Icons.arrow_forward_outlined,
                            color: AppColors.white,
                            size: 20,
                          )
                      ),
                    ),
                  )

                ],
              ),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.reddark2,width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
        );
  }
}



