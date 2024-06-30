import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/models/user.dart';
import '../FireStorePagnation/paginate_firestore.dart';
import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';
import '../models/report.dart';
import '../widget/reportWidget.dart';

class AllReporsScreen extends StatefulWidget {
  final GroceryUser loggedUser;

  const AllReporsScreen({Key? key, required this.loggedUser}) : super(key: key);

  @override
  State<AllReporsScreen> createState() => _AllReporsScreenState();
}

class _AllReporsScreenState extends State<AllReporsScreen> {
  bool isloading = false;
  DateTime selectedDate = DateTime.now();
  bool seen = false, notSeen = true;
  late Query query;
  bool filter = false;
  String time = "Filter by date";
  late Query filterQuery;
  String? dropdownvalue;
  var items = [
    'Sort By',
    'new',
    'closed',
  ];

  @override
  void initState() {
    super.initState();
    query = FirebaseFirestore.instance
        .collection(Paths.complaintsPath)
        .where('status', isEqualTo: "new")
        .orderBy('complaintTime', descending: true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
              width: size.width,
              child: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 0.0, bottom: 6.0),
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
                    Text(
                      getTranslated(context, "reports"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          fontSize: 17.0,
                          color: AppColors.balck2,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ))),
          Center(
              child: Container(
                  color: AppColors.white3, height: 1, width: size.width)),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 20),
            child: Container(
              height: 35,
              width: size.width * .9,
              padding: EdgeInsets.only(right: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 35,
                    width: size.width * .5,
                    padding: EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: AppColors.white3,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            time,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: getTranslated(context, "fontFamily"),
                              color: AppColors.grey,
                              fontSize: 11.0,
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.white.withOpacity(0.6),
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Image.asset(
                              "assets/icons/icon/Group2893.png",
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.30,
                    decoration: BoxDecoration(
                        color: AppColors.white3,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: DropdownButton(
                          value: dropdownvalue,
                          underline: Container(),
                          isExpanded: true,
                          hint: Text(
                            "SortBy",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: getTranslated(context, "fontFamily"),
                              color: AppColors.black,
                              fontSize: 12.0,
                            ),
                          ),
                          items: items.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily:
                                      getTranslated(context, "fontFamily"),
                                  color: AppColors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                            );
                          }).toList(),
                          icon: Image.asset(
                            "assets/icons/icon/Group2894.png",
                            width: 15,
                            height: 15,
                            color: AppColors.reddark,
                          ),
                          onChanged: (value) {
                            setState(() {
                              dropdownvalue = value.toString();
                              query = FirebaseFirestore.instance
                                  .collection(Paths.complaintsPath)
                                  .where('status', isEqualTo: dropdownvalue)
                                  .orderBy('complaintTime', descending: true);
                            });
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: PaginateFirestore(
              key: ValueKey(query),
              itemBuilderType: PaginateBuilderType.listView,
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
              //Change types accordingly
              itemBuilder: (context, documentSnapshot, index) {
                return ReportWidget(
                  loggedUser: widget.loggedUser,
                  report: Report.fromMap(
                    documentSnapshot[index].data() as Map,
                  ),
                );
              },
              query: query,
              // to fetch real-time data
              isLive: true,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    final DateTime currentDate = DateTime(now.year, now.month, now.day);
    final DateTime? picked = await showDatePickerDialog(

      contentPadding: EdgeInsets.zero,
      context: context,
      initialDate: selectedDate,
      minDate: currentDate,
      maxDate: DateTime(2061, 10, 30),
      currentDate: currentDate,
      selectedDate: currentDate,
      currentDateDecoration: const BoxDecoration(),
      currentDateTextStyle: const TextStyle(),
      daysOfTheWeekTextStyle: TextStyle(
          fontFamily: getTranslated(context, "Montserratsemibold"),
          fontSize: 12,
          color: AppColors.grey3
      ),
      //disbaledCellsDecoration: const BoxDecoration(),
      disabledCellsTextStyle: const TextStyle(color: AppColors.grey),
      enabledCellsDecoration: const BoxDecoration(),
      enabledCellsTextStyle: const TextStyle(),
      initialPickerType: PickerType.days,
      selectedCellDecoration: const BoxDecoration(
        color: AppColors.pink2,
        shape: BoxShape.circle,
      ),
      selectedCellTextStyle: const TextStyle(
        color: AppColors.white,
      ),
      leadingDateTextStyle: const TextStyle(
          color: AppColors.pink2
      ),
      slidersColor: Colors.lightBlue,
      highlightColor: Colors.redAccent,
      slidersSize: 20,
      splashColor: Colors.lightBlueAccent,
      splashRadius: 40,
      centerLeadingDate: true,


    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        query = FirebaseFirestore.instance
            .collection(Paths.complaintsPath)
            .where('status', isEqualTo: dropdownvalue)
            .where('complaintTime', isGreaterThanOrEqualTo: selectedDate)
            .where('complaintTime',
                isLessThanOrEqualTo: selectedDate.add(Duration(days: 1)))
            .orderBy('complaintTime', descending: true);
        time = selectedDate.toString().substring(0, 10);
        filter = true;
      });
  }

  Widget build11(BuildContext context) {
    Size size = Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    query = FirebaseFirestore.instance.collection(Paths.complaintsPath);
    //.orderBy('complaintTime', descending: true);

    // List of items in our dropdown menu
    String dropdownvalue = 'Item 1';

    // List of items in our dropdown menu
    var items = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
    ];

    return Scaffold(
        backgroundColor: AppColors.white,
        body: this.isloading
            ? Center(child: CircularProgressIndicator())
            : Column(children: [
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 40.0, bottom: 40.0),
                    child: Row(
                      children: [
                        InkWell(
                          child: Image.asset(
                            getTranslated(
                              context,
                              "back",
                            ),
                            width: 20,
                            height: 20,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          getTranslated(context, "reports"),
                          style: TextStyle(
                              color: AppColors.black2,
                              fontFamily: getTranslated(context, "fontFamily"),
                              fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                    child: PaginateFirestore(
                  key: ValueKey(query),
                  itemBuilderType: PaginateBuilderType.listView,
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
                  itemBuilder: (context, documentSnapshot, index) {
                    return documentSnapshot.length == 0
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: size.height * 0.15,
                                ),
                                Image.asset(
                                  "assets/icons/icon/Group2902.png",
                                  width: 200,
                                  height: 200,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  getTranslated(context, "noreport"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppColors.grey2,
                                      fontFamily:
                                          getTranslated(context, "fontFamily"),
                                      fontSize: 21),
                                )
                              ],
                            ),
                          )
                        : ReportWidget(
                            report: Report.fromMap(
                                documentSnapshot[index].data() as Map),
                            loggedUser: widget.loggedUser,
                          );
                  },
                  query: query,
                  isLive: true,
                ))
              ]));
  }
}
