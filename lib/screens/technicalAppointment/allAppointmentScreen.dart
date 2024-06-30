import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/FireStorePagnation/paginate_firestore.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/addFakeAppointment.dart';
import 'package:grocery_store/widget/techAppointmentWidget.dart';
//import '../FireStorePagnation/paginate_firestore.dart';
class AllAppointmentsScreen extends StatefulWidget {
  final GroceryUser loggedUser;

  const AllAppointmentsScreen({Key? key, required this.loggedUser})
      : super(key: key);

  @override
  _AllAppointmentsScreenState createState() => _AllAppointmentsScreenState();
}

class _AllAppointmentsScreenState extends State<AllAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  bool load = false, today = true, all = false, filter = false;
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  bool showResult = false;
  String? from, to;
  Query? filterQuery;

  @override
  void initState() {
    super.initState();
    from = "From";
    to = "To";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(
                left: 27.0, right: 30.0, top: 27.0, bottom: 15.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                SizedBox(width: 10),
                Text(
                  getTranslated(context, "appointments"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: getTranslated(context, "fontFamily"),
                      color: AppColors.reddark2,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                ),
                Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.white.withOpacity(0.6),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddAppointmentScreen(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        width: 38.0,
                        height: 35.0,
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Colors.red,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
          Center(
              child: Container(
                  color: AppColors.white3, height: 1, width: size.width)),
          SizedBox(height: 1),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 35, right: 35, bottom: 30, top: 30),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      // splashColor: Colors.green.withOpacity(0.5),
                      splashColor: AppColors.white,
                      onTap: () {
                        setState(() {
                          today = true;
                          all = false;
                          filter = false;
                          showResult = false;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              getTranslated(context, "today"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: today
                                    ? AppColors.reddark2
                                    : AppColors.lightGrey1,
                                fontSize: 19.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Montserrat",
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          Container(
                            height: 7,
                            width: 7,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color:
                                  today ? AppColors.reddark2 : AppColors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      // splashColor: Colors.green.withOpacity(0.5),
                      splashColor: AppColors.white,
                      onTap: () {
                        setState(() {
                          all = true;
                          today = false;
                          filter = false;
                          showResult = false;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              getTranslated(context, "all"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: all
                                    ? AppColors.reddark2
                                    : AppColors.lightGrey1,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 19.0,
                                letterSpacing: 0.3,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ),
                          Container(
                            height: 7,
                            width: 7,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: all ? AppColors.reddark2 : AppColors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      //splashColor: Colors.green.withOpacity(0.5),
                      splashColor: AppColors.white,
                      onTap: () {
                        setState(() {
                          today = false;
                          all = false;
                          filter = true;
                          //showResult=true;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              getTranslated(context, "filter"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: filter
                                    ? AppColors.reddark2
                                    : AppColors.lightGrey1,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 19.0,
                                letterSpacing: 0.3,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ),
                          Container(
                            height: 7,
                            width: 7,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color:
                                  filter ? AppColors.reddark2 : AppColors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          today
              ? Expanded(
                  child: PaginateFirestore(
                    itemBuilderType: PaginateBuilderType.listView,
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
                    //Change types accordingly
                    itemBuilder: (context, documentSnapshot, index) {
                      return TechAppointmentWiget(
                        appointment: AppAppointments.fromMap(
                            documentSnapshot[index].data() as Map),
                        loggedUser: widget.loggedUser,
                        user: null,
                      );
                    },
                    query: FirebaseFirestore.instance
                        .collection(Paths.appAppointments)
                        .where('date.month', isEqualTo: DateTime.now().month)
                        .where('date.day', isEqualTo: DateTime.now().day)
                        .where('date.year', isEqualTo: DateTime.now().year)
                        .orderBy('secondValue', descending: true),
                    // to fetch real-time data
                    isLive: true,
                  ),
                )
              : SizedBox(),
          all
              ? Expanded(
                  child: PaginateFirestore(
                    itemBuilderType: PaginateBuilderType.listView,
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
                    //Change types accordingly
                    itemBuilder: (context, documentSnapshot, index) {
                      return TechAppointmentWiget(
                        appointment: AppAppointments.fromMap(
                            documentSnapshot[index].data() as Map),
                        loggedUser: widget.loggedUser,
                        user: null,
                      );
                    },
                    query: FirebaseFirestore.instance
                        .collection(Paths.appAppointments)
                        .orderBy('secondValue', descending: true),
                    // to fetch real-time data
                    isLive: true,
                  ),
                )
              : SizedBox(),
          filter
              ? Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Center(
                        child: Text(
                          getTranslated(context, "filter"),
                          style: TextStyle(
                              color: AppColors.lightGrey2,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              fontSize: 26.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          splashColor: Colors.white.withOpacity(0.5),
                          onTap: () {
                            _selectFromDate(context);
                            /*print("ssss = ${size.width}");
                                print("hhhh = ${size.height}");*/
                          },
                          child: Container(
                            height: size.height * 0.04,
                            width: size.width * .23,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3)),
                                border: Border.all(
                                    color: AppColors.reddark2, width: 0.5)),
                            child: Center(
                              child: Text(
                                from!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.lightGrey2,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Montserrat",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 70,
                        ),
                        InkWell(
                          splashColor: Colors.white.withOpacity(0.5),
                          onTap: () {
                            _selectToDate(context);
                          },
                          child: Container(
                            height: size.height * 0.04,
                            width: size.width * .23,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                              border: Border.all(
                                  color: AppColors.reddark2, width: 0.5),
                            ),
                            child: Center(
                              child: Text(
                                to!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.lightGrey2,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Montserrat",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.06,
                    ),
                    Container(
                      width: size.width * 0.32,
                      height: size.height * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromRGBO( 207, 0, 54,1),
                              Color.fromRGBO( 255, 47, 101,1)
                            ],
                          )
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            filterQuery = FirebaseFirestore.instance
                                .collection(Paths.appAppointments)
                                .where('timeValue',
                                    isGreaterThanOrEqualTo:
                                        selectedFromDate.millisecondsSinceEpoch)
                                .where('timeValue',
                                    isLessThanOrEqualTo:
                                        selectedToDate.millisecondsSinceEpoch)
                                .orderBy('timeValue', descending: true);
                          });
                          showResult = true;
                        },
                        child: Text(
                          getTranslated(context, "results"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                )
              : SizedBox(),
          showResult
              ? Expanded(
                  child: PaginateFirestore(
                    key: ValueKey(filterQuery),
                    itemBuilderType: PaginateBuilderType.listView,
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
                    //Change types accordingly
                    itemBuilder: (context, documentSnapshot, index) {
                      return TechAppointmentWiget(
                          appointment: AppAppointments.fromMap(
                              documentSnapshot[index].data() as Map),
                          loggedUser: widget.loggedUser);
                    },

                    query: filterQuery!,
                    isLive: true,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedFromDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedFromDate)
      setState(() {
        selectedFromDate = picked;
        from = selectedFromDate.toString().substring(0, 10);
      });
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedToDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedToDate)
      setState(() {
        selectedToDate = picked;
        to = selectedToDate.toString().substring(0, 10);
      });
  }
}
