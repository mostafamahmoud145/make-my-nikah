
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/historyAppointmentWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../FireStorePagnation/paginate_firestore.dart';import 'package:shimmer/shimmer.dart';

import '../widget/appointmentWidget.dart';

class CoachesCallPage extends StatefulWidget {
  @override
  _CoachesCallPageState createState() => _CoachesCallPageState();
}

class _CoachesCallPageState extends State<CoachesCallPage>
    with AutomaticKeepAliveClientMixin<CoachesCallPage> {
  final TextEditingController searchController = new TextEditingController();

  late AccountBloc accountBloc;
  GroceryUser? user;
  late bool load;
  DateTime selectedDate = DateTime.now();
  bool avaliable=false;
  DateTime _now = DateTime.now();
  bool filter=false;
  late String time;
  late Query filterQuery;
  @override
  void initState() {
    super.initState();
    accountBloc = BlocProvider.of<AccountBloc>(context);
    accountBloc.add(GetLoggedUserEvent());

  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body:BlocBuilder(
        bloc: accountBloc,
        builder: (context, state) {
          print("Account state");
          print(state);
          if (state is GetLoggedUserInProgressState) {
            return Center(child: loadWidget());
          }
          else if (state is GetLoggedUserCompletedState) {
            user=state.user;
            checkAvaliable();
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                  const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 10),
                  child: Column(
                    children: [
                      avaliable
                          ? Image.asset(
                        AssetsManager.online,
                        width: 12,
                        height: 12,
                      )
                          : Image.asset(
                        AssetsManager.offline,
                        width: 12,
                        height: 12,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Center(
                        child: Text(
                          avaliable
                              ? getTranslated(context, "active")
                              : getTranslated(context, "notActive"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            color: AppColors.black3,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PaginateFirestore(
                    separator: SizedBox(height: AppSize.h32.h,),
                    itemBuilderType: PaginateBuilderType.listView,
                    padding:  EdgeInsets.only( 
                      left: AppSize.w53_3.w, right: AppSize.w53_3.w,),
                    itemBuilder: (context, documentSnapshot, index) {
                      return  AppointmentWiget(
                          appointment: AppAppointments.fromMap(
                              documentSnapshot[index].data() as Map),
                          loggedUser: user!,
                          theme: "light");
                    },
                    query:FirebaseFirestore.instance
                        .collection(Paths.appAppointments)
                        .where('consult.uid', isEqualTo: user!.uid)
                        .where('appointmentStatus', isEqualTo: "open")
                        .orderBy('timestamp', descending: true),
                    // to fetch real-time data
                    isLive: true,
                  ),
                )
              ],
            );
          }
          else {
            return Center(child: loadWidget());
          }
        },
      ),


    );
  }
  BoxShadow shadow(){return
    BoxShadow(
      color: Color.fromRGBO(32, 32 ,32, 0.04),
      blurRadius: 11.0,
      spreadRadius: 0.0,
      offset: Offset(
          0.0, 4.0), // shadow direction: bottom right
    );}
  Widget loadWidget()
  {
    return Shimmer.fromColors(
        period: Duration(milliseconds: 800),
        baseColor: Colors.grey.withOpacity(0.6),
        highlightColor: Colors.black.withOpacity(0.6),
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width*.9,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ));
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        int month=selectedDate.month;
        int day=selectedDate.day;
        filterQuery=FirebaseFirestore.instance.collection(Paths.appAppointments)
            .where('consult.uid', isEqualTo: user!.uid)
            .where('appointmentStatus', isEqualTo: "closed")
            .where('date.month', isEqualTo:month)
            .where('date.day', isEqualTo:day)
            .orderBy('secondValue', descending: true);
        time= selectedDate.toString().substring(0,10);
      });
  }
  checkAvaliable() async {
    if(user!=null&&user!.userType=="COACH"&&user!.profileCompleted==true)
    {
      String dayNow=_now.weekday.toString();
      int timeNow=_now.hour;
      if(user!.workDays!.contains(dayNow))
      {
        if (int.parse(user!.workTimes![0].from! )<=timeNow&&int.parse(user!.workTimes![0].to! )>timeNow) {
          avaliable=true;

        }
      }
    }

  }
  @override
  bool get wantKeepAlive => true;
}
