
import 'package:flutter/material.dart';
import '../../config/colorsFile.dart';
import '../../localization/localization_methods.dart';
import '../../models/user.dart';

class ConsultTimeWidget extends StatefulWidget {
  final GroceryUser consultant;
  ConsultTimeWidget({required this.consultant});

  @override
  _ConsultTimeWidgetState createState() => _ConsultTimeWidgetState();
}

class _ConsultTimeWidgetState extends State<ConsultTimeWidget>with SingleTickerProviderStateMixin {
  bool selected=false,loadInterest=true;
  String languages="", workDays="",workDaysValue="",from="",to="",lang="";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if(widget.consultant.workDays!.length>0) {
      workDays="";
      if(widget.consultant.workDays!.contains("1"))
      {
        workDays=workDays+getTranslated(context,"monday")+",";
      }
      if(widget.consultant.workDays!.contains("2"))
      {
        workDays=workDays+getTranslated(context,"tuesday")+",";
      }
      if(widget.consultant.workDays!.contains("3"))
      {
        workDays=workDays+getTranslated(context,"wednesday")+",";
      }
      if(widget.consultant.workDays!.contains("4"))
      {
        workDays=workDays+getTranslated(context,"thursday")+",";
      }
      if(widget.consultant.workDays!.contains("5"))
      {
        workDays=workDays+getTranslated(context,"friday")+",";
      }
      if(widget.consultant.workDays!.contains("6"))
      {
        workDays=workDays+getTranslated(context,"saturday")+",";
      }
      if(widget.consultant.workDays!.contains("7"))
      {
        workDays=workDays+getTranslated(context,"sunday")+",";
      }
      setState(() {
        workDaysValue="";
        workDaysValue=workDays;
      });
    }
   var  localFrom= DateTime.parse(widget.consultant.fromUtc!).toLocal().hour;
    var localTo=DateTime.parse(widget.consultant.toUtc!).toLocal().hour;
    if(localTo==0)
      localTo=24;
    if(widget.consultant.workTimes!.length>0)
    {
      if( localFrom==12)
        from="12 PM";
      else if( localFrom==0)
        from="12 AM";
      else if( localFrom>12)
        from=((localFrom)-12).toString()+" PM";
      else
        from=(localFrom).toString()+" AM";

    }
    if(widget.consultant.workTimes!.length>0)
    {
      if( localTo==12)
        to="12 PM";
      else if( localTo==0||localTo==24)
        to="12 AM";
      else if( localTo>12)
        to=((localTo)-12).toString()+" PM";
      else
        to=(localTo).toString()+" AM";

    }
    return  Column(children: [
      Center(
        child: Container(height: 40,width: size.width*.35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              shadow()
            ],
          ),
          child:  Center(
            child: Text(
              getTranslated(context, "timeOfWork"),
              style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),  color: Colors.black.withOpacity(0.5),
                fontSize: 15.0,
                fontWeight: FontWeight.normal,),

            ),
          ),
        ),
      ),

      SizedBox(height: 20,),
      Row(mainAxisAlignment:MainAxisAlignment.start,crossAxisAlignment:CrossAxisAlignment.center,children: [
        //Icon( Icons.calendar_today_outlined,size:30,  color: Theme.of(context).primaryColor,),
        Image.asset(
        'assets/applicationIcons/Iconly-Two-tone-Calendar-1.png',
          width: 25,
          height: 25,
        ),
        SizedBox(width: 5,),
        Container(height: 70,width: size.width*.8,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: AppColors.lightPink,
            borderRadius: BorderRadius.circular(30.0),

          ),child:  Center(
            child: Text(
              workDaysValue,
              textAlign: TextAlign.center,
              maxLines: 3,
              style: TextStyle(fontFamily: getTranslated(context, "fontFamily"), color: Theme.of(context).primaryColor,
                fontSize: 13.0,
                fontWeight: FontWeight.normal, ),
            ),
          ),
        ),
      ],),
      SizedBox(height: 20,),
      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,crossAxisAlignment:CrossAxisAlignment.center,children: [
        // Icon( Icons.update,size:30,  color: Theme.of(context).primaryColor,),
        Image.asset('assets/applicationIcons/Iconly-Two-tone-TimeCircle.png',
          width: 25,
          height: 25,
        ),
        SizedBox(width: 5,),
        Container(height: 35,width: size.width*.3,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: AppColors.lightPink,
            borderRadius: BorderRadius.circular(30.0),

          ),child:  Center(
            child:  Text(
              from,
              textAlign: TextAlign.center,
              maxLines: 3,
              style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                color: Theme.of(context).primaryColor,
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                letterSpacing: 0.5,
              ),),
          ),
        ),
        Container(height: 35,width: size.width*.3,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: AppColors.lightPink,
            borderRadius: BorderRadius.circular(30.0),

          ),child:  Center(
            child:Text(
              to,
              textAlign: TextAlign.center,
              maxLines: 3,
              style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                color: Theme.of(context).primaryColor,
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                letterSpacing: 0.5,
              ),),
          ),
        ),
        SizedBox(width: 5,),
      ],),
    ],);

  }
  BoxShadow shadow(){return
    BoxShadow(
      color: AppColors.lightGrey,
      blurRadius: 2.0,
      spreadRadius: 0.0,
      offset: Offset(
          0.0, 1.0), // shadow direction: bottom right
    );}
}
