import 'package:flutter/material.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';

class ChooseWidget extends StatelessWidget {
   final bool ischecked;
   final String title;

  const ChooseWidget({
    Key? key,
    required this.ischecked,
     required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
     Container(
       width: MediaQuery.of(context).size.width * 0.7,
       height: 45,
       padding: EdgeInsets.only(right: 10),
       child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           SizedBox(),
           Text(this.title,style: TextStyle(
           fontSize: 16,
           fontFamily: getTranslated(context, "fontFamily"),
           color: AppColors.black
       ),),
             this.ischecked?Icon(
               Icons.check_circle,
               size: 15,
               color: AppColors.reddark2,
             ):   SizedBox(),
         ],
       ),
       decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(30),
           color:AppColors.white,
          // border: Border.all(color: AppColors.grey2)
       ),
     );
}