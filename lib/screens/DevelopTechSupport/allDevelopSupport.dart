import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/FireStorePagnation/paginate_firestore.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/DevelopTechSupport.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/developListItem.dart';
//import '../FireStorePagnation/paginate_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../config/colorsFile.dart';

class AllDevelopTechScreen extends StatefulWidget {
  final GroceryUser loggedUser;

  const AllDevelopTechScreen({Key? key, required this.loggedUser})
      : super(key: key);

  @override
  _AllDevelopTechScreenState createState() => _AllDevelopTechScreenState();
}

class _AllDevelopTechScreenState extends State<AllDevelopTechScreen>
    with SingleTickerProviderStateMixin {
  bool load = false,
      _new = true,
      _open = false,
      _done = false,
      _closed = false,
      saving = false,
      showText = false;
  final TextEditingController titleController = new TextEditingController();
  String theme = "light";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      getTranslated(context, "development"),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontFamily: getTranslated(context, "fontFamily"),
                          fontSize: 17.0,
                          color: AppColors.balck2),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.white.withOpacity(0.6),
                          onTap: () {
                            addDialog(size);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            width: 38.0,
                            height: 35.0,
                            child: Icon(
                              Icons.add_circle_outline,
                              color: Colors.black,
                              size: 24.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
          Center(
              child: Container(
                  color: AppColors.white3, height: 1, width: size.width)),
          SizedBox(
            height: 5,
          ),
          Center(
            child: Container(
                height: 60,
                width: size.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(0.0, 1.0),
                    )
                  ],
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        splashColor: Colors.green.withOpacity(0.6),
                        onTap: () {
                          setState(() {
                            _new = true;
                            _open = false;
                            _done = false;
                            _closed = false;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: size.width * .20,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: _new
                                ? theme == "light"
                                    ? Theme.of(context).primaryColor
                                    : Colors.black
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Text(
                              "New",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                color: _new
                                    ? theme == "light"
                                        ? Colors.white
                                        : Colors.white
                                    : theme == "light"
                                        ? Theme.of(context).primaryColor
                                        : Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        splashColor: Colors.green.withOpacity(0.6),
                        onTap: () {
                          setState(() {
                            _new = false;
                            _open = true;
                            _done = false;
                            _closed = false;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: size.width * .20,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: _open
                                ? theme == "light"
                                    ? Theme.of(context).primaryColor
                                    : Colors.black
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Text(
                              "Open",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                color: _open
                                    ? theme == "light"
                                        ? Colors.white
                                        : Colors.white
                                    : theme == "light"
                                        ? Theme.of(context).primaryColor
                                        : Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        splashColor: Colors.green.withOpacity(0.6),
                        onTap: () {
                          setState(() {
                            _new = false;
                            _open = false;
                            _done = true;
                            _closed = false;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: size.width * .20,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: _done
                                ? theme == "light"
                                    ? Theme.of(context).primaryColor
                                    : Colors.black
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Text(
                              "Done",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                color: _done
                                    ? theme == "light"
                                        ? Colors.white
                                        : Colors.white
                                    : theme == "light"
                                        ? Theme.of(context).primaryColor
                                        : Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        splashColor: Colors.green.withOpacity(0.6),
                        onTap: () {
                          setState(() {
                            _new = false;
                            _open = false;
                            _done = false;
                            _closed = true;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: size.width * .20,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: _closed
                                ? theme == "light"
                                    ? Theme.of(context).primaryColor
                                    : Colors.black
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Text(
                              "Closed",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                color: _closed
                                    ? theme == "light"
                                        ? Colors.white
                                        : Colors.white
                                    : theme == "light"
                                        ? Theme.of(context).primaryColor
                                        : Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ])),
          ),
          SizedBox(
            height: 10,
          ),
          _new
              ? Expanded(
                  child: PaginateFirestore(
                    itemBuilderType: PaginateBuilderType.listView,
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
                    //Change types accordingly
                    itemBuilder: (context, documentSnapshot, index) {
                      return DevelopListItem(
                          size: size,
                          item: DevelopTechSupport.fromMap(
                              documentSnapshot[index].data() as Map),
                          theme: theme,
                          user: widget.loggedUser);
                    },
                    query: FirebaseFirestore.instance
                        .collection(Paths.developTechSupportPath)
                        .where('status', isEqualTo: "new")
                        .orderBy('sendTime', descending: true),
                    // to fetch real-time data
                    isLive: true,
                  ),
                )
              : SizedBox(),
          _open
              ? Expanded(
                  child: PaginateFirestore(
                    itemBuilderType: PaginateBuilderType.listView,
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
                    //Change types accordingly
                    itemBuilder: (context, documentSnapshot, index) {
                      return DevelopListItem(
                          size: size,
                          item: DevelopTechSupport.fromMap(
                              documentSnapshot[index].data() as Map),
                          theme: theme,
                          user: widget.loggedUser);
                    },
                    query: FirebaseFirestore.instance
                        .collection(Paths.developTechSupportPath)
                        .where('status', isEqualTo: "open")
                        .orderBy('sendTime', descending: true),
                    // to fetch real-time data
                    isLive: true,
                  ),
                )
              : SizedBox(),
          _done
              ? Expanded(
                  child: PaginateFirestore(
                    itemBuilderType: PaginateBuilderType.listView,
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
                    //Change types accordingly
                    itemBuilder: (context, documentSnapshot, index) {
                      return DevelopListItem(
                          size: size,
                          item: DevelopTechSupport.fromMap(
                              documentSnapshot[index].data() as Map),
                          theme: theme,
                          user: widget.loggedUser);
                    },
                    query: FirebaseFirestore.instance
                        .collection(Paths.developTechSupportPath)
                        .where('status', isEqualTo: "done")
                        .orderBy('sendTime', descending: true),
                    // to fetch real-time data
                    isLive: true,
                  ),
                )
              : SizedBox(),
          _closed
              ? Expanded(
                  child: PaginateFirestore(
                    itemBuilderType: PaginateBuilderType.listView,
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
                    //Change types accordingly
                    itemBuilder: (context, documentSnapshot, index) {
                      return DevelopListItem(
                          size: size,
                          item: DevelopTechSupport.fromMap(
                              documentSnapshot[index].data() as Map),
                          theme: theme,
                          user: widget.loggedUser);
                    },
                    query: FirebaseFirestore.instance
                        .collection(Paths.developTechSupportPath)
                        .where('status', isEqualTo: "closed")
                        .orderBy('sendTime', descending: true),
                    // to fetch real-time data
                    isLive: true,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  addDialog(Size size) {
    return showDialog(
      builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          elevation: 5.0,
          contentPadding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  getTranslated(context, "developNotes"),
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  width: size.width * .6,
                  height: 55,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: TextFormField(
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    enableInteractiveSelection: false,
                    style: TextStyle(
                      fontFamily: getTranslated(context, "fontFamily"),
                      fontSize: 14.0,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                      border: InputBorder.none,
                      hintText: getTranslated(context, "title"),
                      hintStyle: TextStyle(
                        fontFamily: getTranslated(context, "fontFamily"),
                        fontSize: 14.0,
                        color: Colors.black54,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w400,
                      ),
                      counterStyle: TextStyle(
                        fontFamily: getTranslated(context, "fontFamily"),
                        fontSize: 12.5,
                        color: Colors.black54,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                showText
                    ? Text(
                        getTranslated(context, "required"),
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      width: 50.0,
                      child: MaterialButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () {
                          setState(() {
                            load = false;
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          getTranslated(context, 'cancel'),
                          style: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            color: Colors.black87,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    saving
                        ? CircularProgressIndicator()
                        : Container(
                            width: 50.0,
                            child: MaterialButton(
                              padding: const EdgeInsets.all(0.0),
                              onPressed: () async {
                                if (titleController.text == null ||
                                    titleController.text == "")
                                  setState(() {
                                    showText = true;
                                  });
                                else {
                                  setState(() {
                                    showText = false;
                                    saving = true;
                                  });
                                  String developListId = Uuid().v4();
                                  await FirebaseFirestore.instance
                                      .collection(Paths.developTechSupportPath)
                                      .doc(developListId)
                                      .set({
                                    'developTechSupportId': developListId,
                                    'status': "new",
                                    'sendTime': FieldValue.serverTimestamp(),
                                    'owner': widget.loggedUser.userType,
                                    'userUid': widget.loggedUser.uid,
                                    'userName': widget.loggedUser.name,
                                    'title': titleController.text,
                                  });
                                  setState(() {
                                    saving = false;
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                getTranslated(context, 'save'),
                                style: TextStyle(
                                  fontFamily:
                                      getTranslated(context, "fontFamily"),
                                  color: Colors.red.shade700,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            );
          })),
      barrierDismissible: false,
      context: context,
    );
  }
}
