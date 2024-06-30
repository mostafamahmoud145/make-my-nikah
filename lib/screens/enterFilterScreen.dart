
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';
import '../models/userSearch.dart';
import '../widget/chooseItem.dart';


class EnterFilterScreen extends StatefulWidget {
  final int screen;
  final String userId;
  const EnterFilterScreen({Key? key,required this.screen,required this.userId}) : super(key: key);

  @override
  State<EnterFilterScreen> createState() => _ChooseFilterScreenState();
}

class _ChooseFilterScreenState extends State<EnterFilterScreen> {


  RangeValues age = const RangeValues(15, 100);
  RangeValues height = const RangeValues(100, 250);
  RangeValues weight = const RangeValues(40, 100);

  UserSearch _userSearch = UserSearch();

  bool isloading = false;

  getSearchUser()
  async {
    setState(() {
      this.isloading = true;
    });

    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection(Paths.userSearch).doc(widget.userId)
        .get();
    setState(() {
      this._userSearch = UserSearch.fromMap(snapshot.data() as Map);

      this.isloading = false;
    });
  }

@override
  void initState() {

  super.initState();

   getSearchUser();

  }
  @override
  Widget build(BuildContext context) {


    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: this.isloading ? Center(child: CircularProgressIndicator(),) :Column(
          children: [
            SafeArea(child: Padding(
              padding: EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 40.0, bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        child: Container(width: 20, height: 20,
                          child: Image.asset(
                            getTranslated(context, "back",), width: 10, height: 20,),
                        ),
                        onTap: ()
                        {
                          Navigator.pop(context, this._userSearch);
                        },
                      ),
                      SizedBox(width: 20,),
                      if(widget.screen == 1)
                        Text(
                          getTranslated(context, "age"),
                          style: TextStyle(color: AppColors.reddark2,
                              fontFamily: getTranslated(context, "fontFamily"),
                              fontSize: 20),)
                      else if(widget.screen == 2)
                        Text(
                          getTranslated(context, "height"),
                          style: TextStyle(color: AppColors.reddark2,
                              fontFamily: getTranslated(context, "fontFamily"),
                              fontSize: 20),)

                      else if(widget.screen == 3)
                          Text(
                            getTranslated(context, "weight"),
                            style: TextStyle(color: AppColors.reddark2,
                                fontFamily: getTranslated(context, "fontFamily"),
                                fontSize: 20),)

                    ],
                  ),
                  InkWell(
                    onTap: ()
                    {
                      if(widget.screen == 1)
                      {
                        FirebaseFirestore.instance.collection(Paths.userSearch).doc(widget.userId).set({
                          "minAge" : 15,
                          "maxAge" : 100
                        },SetOptions(merge: true));
                        setState(() {
                          this._userSearch.minAge=15;
                          this._userSearch.maxAge=100;
                        });
                      }
                      else if(widget.screen == 2)
                      {
                        FirebaseFirestore.instance.collection(Paths.userSearch).doc(widget.userId).set({
                          "minHeight" : 100,
                          "maxHeight" : 250
                        },SetOptions(merge: true));
                        setState(() {
                          this._userSearch.minHeight=100;
                          this._userSearch.maxHeight=250;
                        });
                      }
                      else if(widget.screen == 3)
                      {
                        FirebaseFirestore.instance.collection(Paths.userSearch).doc(widget.userId).set({
                         "minWeight" : 40,
                         "maxWeight" : 200
                        },SetOptions(merge: true));
                        setState(() {
                          this._userSearch.minWeight=40;
                          this._userSearch.maxWeight=200;
                        });
                      }
                    },
                    child: Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                          color: AppColors.reddark2,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text(
                          getTranslated(context, "clean"),
                          style: TextStyle(fontFamily: getTranslated(context,"fontFamily"), color: AppColors.white,
                              fontSize: 12.0,fontWeight: FontWeight.normal ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
            Center(
              child: Container(width: size.width*.50,height: size.width*.25,
                  child: Stack( alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                    widget.screen == 1?this._userSearch.minAge.toString()+"-"+this._userSearch.maxAge.toString():
                                    widget.screen == 2?this._userSearch.minHeight.toString()+"-"+this._userSearch.maxHeight.toString():
                                    widget.screen == 3?this._userSearch.minWeight.toString()+"-"+this._userSearch.maxWeight.toString():
                                    this._userSearch.minWeight.toString()+"-"+this._userSearch.maxWeight.toString(),
                                   style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: getTranslated(context, "fontFamily"),
                                    color: AppColors.black
                                ),textAlign: TextAlign.center,),
                                SizedBox(height: 10,)
                              ],
                            ),
                        ),
                      ),
                      Image.asset("assets/plan/Group2863.png",width: size.width*.50,height: size.width*.30,fit: BoxFit.fill,),

                    ],
                  ),
                ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1,),

            if(widget.screen == 1)
              Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color:AppColors.white2.withOpacity(0.4)
              ),
              child: RangeSlider(
               values: age,
               min: 15,
              // divisions: 40,
               max: 100,
                activeColor: AppColors.green1,
                onChanged: (RangeValues values) {
                  setState(() {
                    age = values;
                    this._userSearch.minAge = age.start.toInt();
                    this._userSearch.maxAge = age.end.toInt();
                  });
                },
              ),
            )
            else if(widget.screen == 2)
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color:AppColors.white2.withOpacity(0.4)
                ),
                child: RangeSlider(
                  values: height,
                  min: 100,
                  // divisions: 40,
                  max: 250,
                  activeColor: AppColors.green1,
                  onChanged: (RangeValues values) {
                    setState(() {
                      height = values;

                      this._userSearch.minHeight = height.start.toInt();
                      this._userSearch.maxHeight = height.end.toInt();
                    });
                  },
                ),
              )
            else if(widget.screen == 3)
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color:AppColors.white2.withOpacity(0.4)
                  ),
                  child: RangeSlider(
                    values: weight,
                    min: 40,
                    // divisions: 40,
                    max: 100,
                    activeColor: AppColors.green1,
                    onChanged: (RangeValues values) {
                      setState(() {
                        weight = values;

                        this._userSearch.minWeight = weight.start.toInt();
                        this._userSearch.maxWeight = weight.end.toInt();
                      });
                    },
                  ),
                )
            ,
            SizedBox(height: MediaQuery.of(context).size.height * 0.1,),

            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.green1,
                        AppColors.red1
                      ]
                  )
              ),
              height: 45,
              child: MaterialButton(
                onPressed: () async {


                  if(widget.screen == 1)
                    {
                      await FirebaseFirestore.instance
                          .collection(Paths.userSearch)
                          .doc(widget.userId).set({
                        "minAge" : this._userSearch.minAge,
                        "maxAge" : this._userSearch.maxAge
                      },SetOptions(merge: true)).then((value) {
                        print("user search updated");
                      }).catchError((error) {
                        print("user search update error");
                      });
                    }
                  if(widget.screen == 2)
                  {
                    await FirebaseFirestore.instance
                        .collection(Paths.userSearch)
                        .doc(widget.userId).set({
                      "minHeight" : this._userSearch.minHeight,
                      "maxHeight" : this._userSearch.maxHeight
                    },SetOptions(merge: true)).then((value) {
                      print("user search updated");
                    }).catchError((error) {
                      print("user search update error");
                    });

                  }

                  if(widget.screen == 3)
                  {
                    await FirebaseFirestore.instance
                        .collection(Paths.userSearch)
                        .doc(widget.userId).set({
                      "minWeight" : this._userSearch.minWeight,
                      "maxWeight" : this._userSearch.maxWeight
                    },SetOptions(merge: true)).then((value) {
                      print("user search updated");
                    }).catchError((error) {
                      print("user search update error");
                    });
                  }

                  Navigator.pop(context,this._userSearch);
                },
                //   color: AppColors.red1,
                child: Text(getTranslated(context, "save"),
                  style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                    color: AppColors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
           // SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

          ]
      ),
    );
  }
}