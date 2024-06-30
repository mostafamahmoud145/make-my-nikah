

import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
 late  String lang="Language",langValue="",done="Save",title="Please choose your preferred language",dropdownValue;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<KeyValueModel> _datas = [
    KeyValueModel(key: 0, value: "English"),
    KeyValueModel(key: 1, value: "العربية"),
  ];
  bool saving=false;
  @override
  void initState() {
    super.initState();
    lang="English";
    dropdownValue = "0";
    title="Please choose your preferred language";
    langValue="en";
  }

  void showFailedSnakbar(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body:  Column(
          children: <Widget>[
            Container(
              height: size.height*.5,
              width: size.width,
              color: Colors.white,
              child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: size.height*.02,),
                  Image.asset('assets/icons/icon/Group2878.png',width: 97,height: 93,),
                ],
              )),
            ),
            Container(
              height: size.height*.5,
              width: size.width,
              color: Colors.white,
              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                        color: AppColors.blacklight,
                        fontSize: 18,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                  SizedBox(height: size.height*.04,),
                  Container(width:size.width*0.7,height: 45.0,decoration:
                    BoxDecoration(
                     color:AppColors.white ,
                      border: Border.all(
                        color: AppColors.white3,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                     ),
                      child:Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: DropdownButton<String>(
                          icon: Icon(Icons.keyboard_arrow_down,color: AppColors.reddark,),
                          hint: Text(lang,textAlign:TextAlign.start,style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                            color: AppColors.black2,
                              fontSize: 17,
                              fontWeight: FontWeight.w300
                          ),),
                          underline:Container(),
                          isExpanded: true,
                          value: dropdownValue,
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(fontFamily: getTranslated(context, getTranslated(context,"fontFamily")),
                              color: AppColors.black2,
                              fontSize: 15,
                              fontWeight: FontWeight.w300
                          ),
                          items: _datas
                              .map((data) => DropdownMenuItem<String>(
                              child: Center(
                                child: Text(data.value.toString(),style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                                    color: AppColors.black2,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300
                                ),),
                              ),
                              value: data.key.toString()//data.key,
                          ))
                              .toList(),
                          onChanged: (String? value) {
                            if(value=="1")
                            {
                              setState(() {
                                lang="العربية";
                                dropdownValue = value!;
                                title="من فضلك قم باختيار اللغة المفضلة";
                                langValue="ar";
                                done="حفظ";
                              });
                            }
                            else if(value=="0") {
                              setState(() {
                                lang = "English";
                                dropdownValue = value!;
                                title="Please choose your preferred language";
                                langValue="en";
                                done="Save";
                              });
                            }

                          },

                        ),
                      )
                  ),
                  SizedBox(height: size.height*.1,),
                  saving?Center(child: CircularProgressIndicator()):Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(getTranslated(context, "leftrose"),width: 40,height: 40,),
                        Container(
                          width: size.width * 0.6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.pink2,
                                AppColors.red1,

                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,

                            )
                          ),
                          height: 50,
                          child: MaterialButton(
                            onPressed: () async {
                              setState(() {
                                saving=true;
                              });
                              if(langValue=="") {
                                showFailedSnakbar(getTranslated(context, "chooseLang"));
                                  setState(() {
                                    saving=false;
                                  });
                              }
                              else{
                               _changeLanguage(langValue);
                                setState(() {
                                  saving=false;
                                });
                                Navigator.pushNamed(context, '/home');
                              }

                            },
                           // color: AppColors.red1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              done,
                              style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                                color: Colors.white,fontWeight: FontWeight.w400,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                        Image.asset(getTranslated(context, "rightrose"),width: 40,height: 40,),
                      ],
                    ),
                  SizedBox(height: size.height*.1,),
                  //),
                ],),
            ),
          ],
        ),
    );
  }
  void _changeLanguage(String lang) async {
    print(lang);
    final _temp = await setLocal(lang);
    MyApp.setLocale(context, _temp);
  }
}
