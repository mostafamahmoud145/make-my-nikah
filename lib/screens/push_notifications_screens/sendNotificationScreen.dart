import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/processing_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class SendNotificationScreen extends StatefulWidget {
  @override
  _SendNotificationScreenState createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<dynamic, dynamic> notificationMap = Map();
  TextEditingController controller = TextEditingController();
  var image;
  var selectedImage;
  String url = "noImage";
  String link = "noLink";
  bool? isSending, sendReq = false, langReq = false, isAdding = false;
  String? selectedType = null,
      selectedCountry = "00",
      selectedLang = null,
      theme;
  String? lang = "language",
      langValue = "",
      done = "Save",
      title = "Please select language",
      dropdownTypeValue,
      dropdownLangValue;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<KeyValueModel> _langArray = [
    KeyValueModel(key: "ar", value: "العربية"),
    KeyValueModel(key: "en", value: "English"),
  ];
  List<KeyValueModel> _typeArray = [
    KeyValueModel(key: 0, value: "العربية"),
    KeyValueModel(key: 1, value: "English"),
  ];

  @override
  void initState() {
    super.initState();
    isSending = false;
  }

  @override
  void didChangeDependencies() {
    getThemeName().then((theme) {
      setState(() {
        this.theme = theme;
      });
    });
    super.didChangeDependencies();
  }

  Future cropImage(context) async {
    image = await ImagePicker().getImage(source: ImageSource.gallery);
    File croppedFile = File(image.path);

    if (croppedFile != null) {
      print('File size: ' + croppedFile.lengthSync().toString());
      setState(() {
        selectedImage = croppedFile;
      });
    } else {
      //not croppped

    }
  }

  sendNotification() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (selectedType == null || selectedLang == null) {
        if (selectedType == null)
          setState(() {
            sendReq = true;
          });
        if (selectedLang == null)
          setState(() {
            langReq = true;
          });
      } else {
        setState(() {
          isAdding = true;
        });

        if (selectedImage != null) {
          var uuid = Uuid().v4();
          Reference storageReference = FirebaseStorage.instance
              .ref()
              .child('pushNotificationImages/$uuid');
          await storageReference.putFile(selectedImage);
          url = await storageReference.getDownloadURL();
        }
        notificationMap.update(
          'imageUrl',
          (val) => url,
          ifAbsent: () => url,
        );
        notificationMap.update(
          'link',
          (val) => link,
          ifAbsent: () => link,
        );
        String id = Uuid().v4();
        await FirebaseFirestore.instance
            .collection(Paths.generalNotificationsPath)
            .doc(id)
            .set({
          'title': notificationMap['title'],
          'body': notificationMap['body'],
          'notificationType': notificationMap['notificationType'],
          'notificationLang': notificationMap['notificationLang'],
          'notificationCountry': notificationMap['notificationCountry'] +
              " - " +
              notificationMap['countryName'],
          'notificationTimestamp': Timestamp.now(),
          'imageUrl': url,
          'link': link,
        });

        //call function
        var refundRes = await http.post(
          Uri.parse(
              'https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/sendNewNotification'),
          body: notificationMap,
        );
        print("jjjjjjjj123");
        print(notificationMap['title']);
        print(notificationMap['body']);
        print(notificationMap['notificationType']);
        print(notificationMap['notificationLang']);
        print(notificationMap['notificationCountry']);
        print(notificationMap['imageUrl']);
        print(notificationMap['link']);
        var refund = jsonDecode(refundRes.body);
        print(refund['message']);
        print(refund['data']);
        setState(() {
          isAdding = false;
        });
        if (refund['message'] != 'Success') {
          showSnack('Please fill all the details!', context);
        } else {
          setState(() {
            isAdding = false;
          });
          Navigator.pop(context);
        }
      }
    }
  }

  showUpdatingDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: 'Sending notification..\nPlease wait!',
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
    _typeArray = [
      KeyValueModel(
          key: "CONSULTANT", value: getTranslated(context, "consultNum")),
      KeyValueModel(key: "USER", value: getTranslated(context, "userNum")),
      KeyValueModel(
          key: "SUPPORT", value: getTranslated(context, "supportNum")),
    ];

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
                      getTranslated(context, "sendNotification"),
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
          Expanded(
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
                      Center(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: size.width * 0.45,
                              width: size.width * 0.9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: theme == "light"
                                    ? Colors.white
                                    : Colors.transparent,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 0.0),
                                    blurRadius: 15.0,
                                    spreadRadius: 2.0,
                                    color: Colors.black.withOpacity(0.05),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: selectedImage == null
                                    ? Icon(
                                        Icons.image,
                                        size: 50.0,
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image.file(
                                          selectedImage,
                                        ),
                                      ),
                              ),
                            ),
                            selectedImage != null
                                ? Positioned(
                                    top: 10.0,
                                    right: 10.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Material(
                                        color: Theme.of(context).primaryColor,
                                        child: InkWell(
                                          splashColor:
                                              Colors.white.withOpacity(0.6),
                                          onTap: () {
                                            cropImage(context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(),
                                            width: 30.0,
                                            height: 30.0,
                                            child: Icon(
                                              Icons.edit,
                                              color: theme == "light"
                                                  ? Colors.white
                                                  : Colors.black,
                                              size: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Positioned(
                                    top: 10.0,
                                    right: 10.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Material(
                                        color: Theme.of(context).primaryColor,
                                        child: InkWell(
                                          splashColor:
                                              Colors.white.withOpacity(0.6),
                                          onTap: () {
                                            cropImage(context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(),
                                            width: 30.0,
                                            height: 30.0,
                                            child: Icon(
                                              Icons.add,
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
                        validator: (String? val) {
                          if (val!.trim().isEmpty) {
                            return getTranslated(context, 'required');
                          }
                          return null;
                        },
                        onSaved: (val) {
                          notificationMap.update(
                            'title',
                            (val) => val.trim(),
                            ifAbsent: () => val!.trim(),
                          );
                        },
                        enableInteractiveSelection: true,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
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
                            // color: Colors.black54,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          //prefixIcon: Icon(Icons.title),
                          labelText: getTranslated(context, "title"),
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
                        validator: (String? val) {
                          if (val!.trim().isEmpty) {
                            return getTranslated(context, 'required');
                          }

                          return null;
                        },
                        onSaved: (val) {
                          notificationMap.update(
                            'body',
                            (val) => val.trim(),
                            ifAbsent: () => val!.trim(),
                          );
                        },
                        enableInteractiveSelection: true,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        minLines: 1,
                        maxLines: 6,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 15),
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
                            //color: Colors.black54,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          // prefixIcon: Icon(Icons.mail),
                          labelText: getTranslated(context, "description"),
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
                      Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: theme == "light"
                                  ? Colors.white
                                  : Colors.transparent,
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: DropdownButton<String>(
                              hint: Text(
                                getTranslated(context, "sendTo"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily:
                                      getTranslated(context, "fontFamily"),
                                  //color: Colors.black,
                                  fontSize: 15.0,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              underline: Container(),
                              isExpanded: true,
                              value: dropdownTypeValue,
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: Colors.black),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                color: Color(0xFF3b98e1),
                                fontSize: 13.0,
                                letterSpacing: 0.5,
                              ),
                              items: _typeArray
                                  .map((data) => DropdownMenuItem<String>(
                                      child: Text(
                                        data.value.toString(),
                                        style: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      value: data.key.toString() //data.key,
                                      ))
                                  .toList(),
                              onChanged: (String? value) {
                                print("selectedValue");
                                print(value);
                                setState(() {
                                  selectedType = value;
                                  dropdownTypeValue = value;
                                  notificationMap.putIfAbsent(
                                      'notificationType', () => selectedType);
                                });
                              },
                            ),
                          )),
                      sendReq!
                          ? Text(
                              getTranslated(context, "required"),
                              style: GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                                color: Colors.red,
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: theme == "light"
                                  ? Colors.white
                                  : Colors.transparent,
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: DropdownButton<String>(
                              hint: Text(
                                getTranslated(context, "selectLanguage"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily:
                                      getTranslated(context, "fontFamily"),
                                  //color: Colors.black,
                                  fontSize: 15.0,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              underline: Container(),
                              isExpanded: true,
                              value: dropdownLangValue,
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: Colors.black),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                color: Color(0xFF3b98e1),
                                fontSize: 13.0,
                                letterSpacing: 0.5,
                              ),
                              items: _langArray
                                  .map((data) => DropdownMenuItem<String>(
                                      child: Text(
                                        data.value.toString(),
                                        style: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      value: data.key.toString() //data.key,
                                      ))
                                  .toList(),
                              onChanged: (String? value) {
                                print("selectedValue");
                                print(value);
                                setState(() {
                                  selectedLang = value;
                                  dropdownLangValue = value;
                                  notificationMap.putIfAbsent(
                                      'notificationLang', () => selectedLang);
                                });
                              },
                            ),
                          )),
                      langReq!
                          ? Text(
                              getTranslated(context, "required"),
                              style: GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                                color: Colors.red,
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        readOnly: true,
                        controller: controller,
                        onSaved: (val) {
                          if (val != null) {
                            notificationMap.update(
                              'notificationCountry',
                              (val) => selectedCountry,
                              ifAbsent: () => selectedCountry,
                            );
                            notificationMap.update(
                              'countryName',
                              (val) => controller.text,
                              ifAbsent: () => controller.text,
                            );
                          }
                        },
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: true,
                            onSelect: (Country country) {
                              setState(() {
                                selectedCountry = "+" + country.phoneCode;
                                controller.text = country.name;
                              });
                            },
                            // Optional. Sets the theme for the country list picker.
                            countryListTheme: CountryListThemeData(
                              // Optional. Sets the border radius for the bottomsheet.
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40.0),
                                topRight: Radius.circular(40.0),
                              ),
                              // Optional. Styles the search field.
                              inputDecoration: InputDecoration(
                                labelText: 'Search',
                                hintText: 'Start typing to search',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xFF8C98A8)
                                        .withOpacity(0.2),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        enableInteractiveSelection: true,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        minLines: 1,
                        maxLines: 6,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 15),
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
                            //color: Colors.black54,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          // prefixIcon: Icon(Icons.mail),
                          labelText: getTranslated(context, "selectCountry"),
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
                      /*TextFormField(
                        textAlignVertical: TextAlignVertical.center,

                        onSaved: (val) {
                         setState(() {
                           link=val;
                         });
                        },
                        enableInteractiveSelection: true,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
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
                            // color: Colors.black54,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          //prefixIcon: Icon(Icons.title),
                          labelText: "link",
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),*/
                      SizedBox(
                        height: 25.0,
                      ),
                      isAdding!
                          ? Center(child: CircularProgressIndicator())
                          : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromRGBO( 207, 0, 54,1),
                                Color.fromRGBO( 255, 47, 101,1)
                              ],
                            )),
                              height: 45.0,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              child: MaterialButton(
                                onPressed: () {
                                  //add notificationMap
                                  sendNotification();
                                },
                                //color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.send,
                                      color: theme == "light"
                                          ? Colors.white
                                          : Colors.black,
                                      size: 20.0,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      getTranslated(
                                          context, "sendNotification"),
                                      style: GoogleFonts.poppins(
                                        color: theme == "light"
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
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
