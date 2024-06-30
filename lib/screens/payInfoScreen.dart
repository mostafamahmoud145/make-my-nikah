
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:image_picker/image_picker.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';
import '../models/user.dart';
import '../widget/processing_dialog.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class payInfoScreen extends StatefulWidget {
  final String consultUid;

  const payInfoScreen({Key? key, required this.consultUid}) : super(key: key);

  @override
  _payInfoScreenState createState() => _payInfoScreenState();
}

class _payInfoScreenState extends State<payInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<dynamic, dynamic> adminMap = Map();
  var image;
  var selectedImage;
  bool isAdding = false, load = true;
  late GroceryUser consult;
  //late String fullName, bankName, accountNumber, address, personalId;

  @override
  void initState() {
    super.initState();
    getConsultDetails();
  }

  Future<void> getConsultDetails() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .doc(widget.consultUid)
        .get();
    GroceryUser currentUser = GroceryUser.fromMap(documentSnapshot.data() as Map);
    setState(() {
      consult = currentUser;
     /* fullName = consult.fullName!;
      bankName = consult.bankName!;
      accountNumber = consult.bankAccountNumber!;
      address = consult.fullAddress!;
      personalId = consult.personalIdUrl!;*/
      load = false;
    });
  }


  Future cropImage(context) async {
    image = await ImagePicker().getImage(source: ImageSource.gallery);
    File croppedFile = File(image.path);

    if (croppedFile != null) {
      print('File size: ' + croppedFile.lengthSync().toString());
      setState(() {
        selectedImage = croppedFile;
        adminMap.update(
          'profileImage',
          (value) => selectedImage,
          ifAbsent: () => selectedImage,
        );
      });
    } else {
      //not croppped

    }
  }

  addNewAdmin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isAdding = true;
      });
      String? url = consult.personalIdUrl;
      if (selectedImage != null) {
        var uuid = Uuid().v4();
        Reference storageReference =
            FirebaseStorage.instance.ref().child('profileImages/$uuid');
        await storageReference.putFile(selectedImage);

        url = await storageReference.getDownloadURL();
      }
      await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(consult.uid)
          .set({
        'fullName': consult.fullName,
        'bankName': consult.bankName,
        'bankAccountNumber': consult.bankAccountNumber,
        'fullAddress': consult.fullAddress,
        'personalIdUrl': url,
      }, SetOptions(merge: true));

      setState(() {
        isAdding = false;
      });
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  showUpdatingDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: 'Adding new admin..\nPlease wait!',
        );
      },
    );
  }

  void showSnack(String text, BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: BorderRadius.circular(7),
      backgroundColor: Colors.red.shade500,
      animationDuration: Duration(milliseconds: 300),
      isDismissible: true,
      boxShadows: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 1.0,
          blurRadius: 5.0,
          offset: Offset(0.0, 2.0),
        )
      ],
      shouldIconPulse: false,
      duration: Duration(milliseconds: 2000),
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      messageText: Text(
        '$text',
        style: GoogleFonts.poppins(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          color: Colors.white,
        ),
      ),
    )..show(context);
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      iconSize: 30,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset(
                        getTranslated(context, 'back'),
                        width: 30,
                        height: 30,
                      ),
                    ),
                    Text(
                      getTranslated(context, "paymentInfo"),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          fontSize: 17.0,
                          color: AppColors.balck2,
                          fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ))),
          Center(
              child: Container(
                  color: AppColors.white3, height: 1, width: size.width)),

          load
              ? CircularProgressIndicator()
              : Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(width: size.width*0.32),
                                Text(
                                  getTranslated(context, "personalPhotoId"),
                                  style: GoogleFonts.poppins(
                                    color: AppColors.grey1,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: size.width * 0.35,
                                    width: size.width * 0.85,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 0.0),
                                          blurRadius: 15.0,
                                          spreadRadius: 2.0,
                                          color: Colors.black.withOpacity(0.05),
                                        ),
                                      ],
                                    ),
                                    child: (consult.personalIdUrl == null ||
                                                consult
                                                    .personalIdUrl!.isEmpty) &&
                                            selectedImage == null
                                        ? Icon(
                                            Icons.person,
                                            size: 50.0,
                                      color: AppColors.grey2,
                                          )
                                        : selectedImage != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(0.0),
                                                child:
                                                    Image.file(selectedImage),
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(0.0),
                                                child: FadeInImage.assetNetwork(
                                                  placeholder:
                                                      'assets/icons/icon/load.gif',
                                                  placeholderScale: 0.5,
                                                  imageErrorBuilder: (context,
                                                          error, stackTrace) =>
                                                      Icon(
                                                    Icons.person,
                                                    size: 50.0,
                                                  ),
                                                  image: consult.personalIdUrl!,
                                                  fit: BoxFit.cover,
                                                  fadeInDuration: Duration(
                                                      milliseconds: 250),
                                                  fadeInCurve: Curves.easeInOut,
                                                  fadeOutDuration: Duration(
                                                      milliseconds: 150),
                                                  fadeOutCurve:
                                                      Curves.easeInOut,
                                                ),
                                              ),
                                  ),
                                  Positioned(
                                    bottom: 1.0,
                                    left: 1.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: Material(
                                        color: AppColors.chat,
                                        child: InkWell(
                                          splashColor:
                                              Colors.white.withOpacity(0.6),
                                          onTap: () {
                                            //TODO: take user to edit
                                            cropImage(context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:Theme.of(context).primaryColor,
                                              /*  gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                AppColors.green1,
                                                AppColors.pink,
                                              ],
                                            ),*/
                                            ),
                                            width: 30.0,
                                            height: 30.0,
                                            child: Icon(
                                              (consult.personalIdUrl == null ||
                                                      consult.personalIdUrl!
                                                          .isEmpty)
                                                  ? Icons.edit
                                                  : Icons.add,
                                              color: Colors.white,
                                              size: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              initialValue: consult.fullName,
                              validator: (String? val) {
                                if (val!.trim().isEmpty) {
                                  return getTranslated(context, "required");
                                }
                                return null;
                              },
                              onSaved: (val) {
                                consult.fullName = val!;
                              },
                              enableInteractiveSelection: false,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15.0),
                                helperStyle: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.65),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                errorStyle: GoogleFonts.poppins(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.black54,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                prefixIcon: Icon(Icons.person),
                                prefixStyle: GoogleFonts.poppins(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                labelText: getTranslated(context, "fullName"),
                                labelStyle: GoogleFonts.poppins(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              initialValue: consult.bankName,
                              validator: (String? val) {
                                if (val!.trim().isEmpty) {
                                  return getTranslated(context, "required");
                                }
                                return null;
                              },
                              onSaved: (val) {
                                consult.bankName = val!;
                              },
                              enableInteractiveSelection: true,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15.0),
                                helperStyle: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.65),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                errorStyle: GoogleFonts.poppins(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.black54,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                prefixIcon: Icon(Icons.account_balance),
                                prefixStyle: GoogleFonts.poppins(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                labelText: getTranslated(context, "bankName"),
                                labelStyle: GoogleFonts.poppins(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              initialValue: consult.bankAccountNumber,
                              validator: (String? val) {
                                if (val!.trim().isEmpty) {
                                  return getTranslated(
                                      context, "accountNumber");
                                }
                                return null;
                              },
                              onSaved: (val) {
                                consult.bankAccountNumber = val!;
                              },
                              enableInteractiveSelection: false,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15.0),
                                helperStyle: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.65),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                errorStyle: GoogleFonts.poppins(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.black54,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                prefixIcon: Icon(Icons.account_balance),
                                labelText:
                                    getTranslated(context, "accountNumber"),
                                labelStyle: GoogleFonts.poppins(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              initialValue: consult.fullAddress,
                              validator: (String? val) {
                                if (val!.trim().isEmpty) {
                                  return getTranslated(context, "address");
                                }
                                return null;
                              },
                              onSaved: (val) {
                                consult.fullAddress = val!;
                              },
                              enableInteractiveSelection: false,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15.0),
                                helperStyle: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.65),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                errorStyle: GoogleFonts.poppins(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.black54,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                prefixIcon: Icon(Icons.location_on_outlined),
                                labelText: getTranslated(context, "address"),
                                labelStyle: GoogleFonts.poppins(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            isAdding
                                ? Center(child: CircularProgressIndicator())
                                : Container(
                                    height: 45.0,
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            AppColors.reddark2,
                                            AppColors.reddark,
                                          ],
                                        )),
                                    child: MaterialButton(
                                      onPressed: () {
                                        //add adminMap
                                        addNewAdmin();
                                      },
                                      //m color:AppColors.chat,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child:  Text(
                                        getTranslated(context, "save"),
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: 25.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
