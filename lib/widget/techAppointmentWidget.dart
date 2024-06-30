
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/SupportList.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/supportMessagesScreen.dart';
import 'package:intl/intl.dart';

class TechAppointmentWiget extends StatefulWidget {
  final AppAppointments appointment;
  final GroceryUser? user;
  final GroceryUser loggedUser;

  TechAppointmentWiget(
      {required this.appointment, required this.loggedUser,  this.user});

  @override
  _TechAppointmentWigetState createState() => _TechAppointmentWigetState();
}

class _TechAppointmentWigetState extends State<TechAppointmentWiget>
    with SingleTickerProviderStateMixin {
  bool userChating = false, consultChating = false,loadingChat=false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String time;
    DateFormat dateFormat = DateFormat('dd/MM/yy');
    DateTime localDate;
    if (widget.appointment.utcTime != null)
      localDate = DateTime.parse(widget.appointment.utcTime).toLocal();
    else
      localDate = DateTime.parse(
              widget.appointment.appointmentTimestamp.toDate().toString())
          .toLocal();
    if (localDate.hour == 12)
      time = "12 Pm";
    else if (localDate.hour == 0)
      time = "12 Am";
    else if (localDate.hour > 12)
      time = (localDate.hour - 12).toString() +
          ":" +
          localDate.minute.toString() +
          "Pm";
    else
      time = (localDate.hour).toString() +
          ":" +
          localDate.minute.toString() +
          "Am";
    //String time=(widget.appointment.time.hour).toString()+":"+widget.appointment.time.minute.toString();

    /* if(widget.appointment.time.hour>12)
      time=(widget.appointment.time.hour-12).toString()+":"+widget.appointment.time.minute.toString()+"Pm";
    else
      time=(widget.appointment.time.hour).toString()+":"+widget.appointment.time.minute.toString()+"Am";*/
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 47, bottom: 2.5, right: 47, top: 15),
            child: Row(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${dateFormat.format(localDate)}',
                        //'${dateFormat.format(widget.appointment.appointmentTimestamp.toDate())}',
                        //DateFormat.yMMMd().format(DateTime.parse(widget.appointment.appointmentTimestamp.toDate().toString())).toString(), // Apr
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.3,
                          fontFamily: "Montserrat",
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'assets/icons/icon/outline-event.png',
                        width: 13,
                        height: 13,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        time,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 9.0,
                          fontFamily: "Montserrat",
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'assets/icons/icon/whiteTime.png',
                        width: 13,
                        height: 13,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              width: size.width * 0.8,
              //height: size.height * 0.18,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: const Color(0x21665a5f),
                      offset: Offset(0, 2),
                      blurRadius: 6,
                      spreadRadius: 0)
                ],
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  width: 1.0,
                  style: BorderStyle.solid,
                  color: Colors.black.withOpacity(0.08),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 21,
                          top: 18,
                        ),
                        child: Row(
                          children: [
                            Text(
                              //widget.appointment.user.name!=null?widget.appointment.user.name:widget.appointment.user.phone,
                              getTranslated(context, "husband"),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: AppColors.black4,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w300,
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.3,
                              ),
                            ),
                            Container(
                              width: size.width * 0.35,
                              child: Text(
                                widget.appointment.user.name,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: AppColors.balck2,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                      Spacer(),
                      userChating
                          ? CircularProgressIndicator()
                          : Padding(
                              padding:
                                  const EdgeInsets.only(right: 15, top: 18),
                              child: InkWell(
                                onTap: (){
                                  startUserChating();

                                },
                                child: Container(
                                  width: size.width * 0.06,
                                  height: size.width * 0.06,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.lightPink1,
                                          offset: Offset(0, 1),
                                          blurRadius: 2,
                                          spreadRadius: 0)
                                    ],
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                   child:Icon(
                                      Icons.chat_outlined,
                                      color: AppColors.reddark,
                                      size: size.width * 0.04,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                  SizedBox(height: 7),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 22.7, bottom: 9),
                        child: Row(
                          children: [
                            Text(
                              //getTranslated(context, "callStatus"),
                              getTranslated(context, "wife"),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: AppColors.black4,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w300,
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.3,
                              ),
                            ),
                            Container(
                              width: size.width * 0.35,
                              child: Text(
                                widget.appointment.consult.name,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: AppColors.black2,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily:
                                      getTranslated(context, "fontFamily"),
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      consultChating
                          ? CircularProgressIndicator()
                          :Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: InkWell(
                          onTap: (){
                            startConsultChating();
                          },
                          child: Container(
                            width: size.width * 0.06,
                            height: size.width * 0.06,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.lightPink1,
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    spreadRadius: 0)
                              ],
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Icon(
                              Icons.chat_outlined,
                              color: AppColors.brown,
                              size: size.width * 0.04,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 9.5,
                  ),
                  // Line 279
                  Container(
                      width: size.width * 0.8,
                      height: 0.5,
                      decoration:
                          BoxDecoration(color: const Color(0xffededed))),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: size.height * 0.03,
                        width: size.width * 0.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(1),
                          ),
                          border: Border.all(
                            color: AppColors.reddark,
                            width: 0.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.appointment.appointmentStatus,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.reddark,
                              fontSize: 11.0,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      widget.appointment.type == null
                          ? SizedBox()
                          : Container(
                              height: size.height * 0.03,
                              width: size.width * 0.15,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)),
                                  border: Border.all(
                                      color: AppColors.brown, width: 0.5)),
                              child: Center(
                                child: Text(
                                  widget.appointment.type,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.brown,
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Montserrat",
                                    fontStyle: FontStyle.normal,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(
                        width: 5,
                      ),
                      /*Container(
                        height: 30,
                        width: size.width * .25,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Text(
                            double.parse(
                                        widget.appointment.callPrice.toString())
                                    .toStringAsFixed(3) +
                                "\$",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              color: AppColors.black,
                              fontSize: 13.0,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              )),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  StartChat() async {
    setState(() {
      loadingChat = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("SupportList")
        .where(
          'userUid',
          isEqualTo: widget.user!.uid,
        )
        .limit(1)
        .get();
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      var item = SupportList.fromMap(querySnapshot.docs[0].data() as Map);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SupportMessageScreen(item: item, user: widget.loggedUser),
        ),
      );
      setState(() {
        loadingChat = false;
      });
    } else {
      setState(() {
        loadingChat = false;
      });
    }
  }

  startUserChating() async {
    setState(() {
      userChating = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("SupportList")
        .where(
          'userUid',
          isEqualTo: widget.appointment.user.uid,
        )
        .limit(1)
        .get();
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      var item = SupportList.fromMap(querySnapshot.docs[0].data() as Map);
      item.userName = widget.appointment.user.name;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SupportMessageScreen(item: item, user: widget.loggedUser),
        ),
      );
      setState(() {
        userChating = false;
      });
    } else {
      setState(() {
        userChating = false;
      });
    }
  }

  startConsultChating() async {
    setState(() {
      consultChating = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("SupportList")
        .where(
          'userUid',
          isEqualTo: widget.appointment.consult.uid,
        )
        .limit(1)
        .get();
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      var item = SupportList.fromMap(querySnapshot.docs[0].data() as Map);
      item.userName = widget.appointment.consult.name;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SupportMessageScreen(item: item, user: widget.loggedUser),
        ),
      );
      setState(() {
        consultChating = false;
      });
    } else {
      setState(() {
        consultChating = false;
      });
    }
  }
}
