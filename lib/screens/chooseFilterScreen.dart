

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/models/userSearch.dart';

import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';
import '../widget/chooseItem.dart';


class ChooseFilterScreen extends StatefulWidget {
  final int screen;
  final String userId;
  const ChooseFilterScreen({Key? key, required this.screen, required this.userId}) : super(key: key);

  @override
  State<ChooseFilterScreen> createState() => _ChooseFilterScreenState();
}

class _ChooseFilterScreenState extends State<ChooseFilterScreen> {

  late UserSearch _userSearch;
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
      body: this.isloading ? Center(child: CircularProgressIndicator(),) : Column(
        children: [
          SafeArea(child: Padding(
            padding: EdgeInsets.only(
                left: 30.0, right: 30.0, top: 40.0, bottom: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               /* InkWell(
                  child: Container(width: 20, height: 20,
                    child: Image.asset(
                      getTranslated(context, "back",), width: 10, height: 20,),
                  ),
                  onTap: ()
                  {
                    Navigator.pop(context, this._userSearch);
                  },
                ),*/
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, this._userSearch);
                  },
                  icon: Image.asset(
                    getTranslated(context, "back"),
                    width: 30,
                    height: 30,
                  ),
                ),
                Container(width: size.width*.4,
                  child: Text(
                    widget.screen == 0?getTranslated(context, "hijab"):
                    widget.screen == 1?getTranslated(context, "skincolor"):
                    widget.screen == 2?getTranslated(context, "maritalstate"):
                    widget.screen == 3?getTranslated(context, "religion"):
                    widget.screen == 4?getTranslated(context, "marriageType"):
                    widget.screen == 5?getTranslated(context, "education"):
                    getTranslated(context, "employmentStatus"),
                    softWrap: true,maxLines: 2,overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.reddark2,
                        fontFamily: getTranslated(context, "fontFamily"),
                        fontSize: 18),),
                ),
                InkWell(onTap: (){
                  if(widget.screen == 0)
                  {
                    FirebaseFirestore.instance.collection(Paths.userSearch).doc(widget.userId).set({
                      "hijab" : ""
                    },SetOptions(merge: true));
                    setState(() {
                      this._userSearch.hijab= "";
                    });
                  }
                  if(widget.screen == 1)
                  {
                    FirebaseFirestore.instance.collection(Paths.userSearch).doc(widget.userId).set({
                      "skinColor" : []
                    },SetOptions(merge: true));
                    setState(() {
                      this._userSearch.skinColor=[];
                    });
                  }
                  else if(widget.screen == 2)
                  {
                    FirebaseFirestore.instance.collection(Paths.userSearch).doc(widget.userId).set({
                      "maritalstate" : ""
                    },SetOptions(merge: true));
                    setState(() {
                      this._userSearch.maritalState="";
                    });
                  }
                  else if(widget.screen == 3)
                  {
                    FirebaseFirestore.instance.collection(Paths.userSearch).doc(widget.userId).set({
                      "religion" : ""
                    },SetOptions(merge: true));
                    setState(() {
                      this._userSearch.religion="";
                    });
                  }
                  else if(widget.screen == 4)
                  {
                    FirebaseFirestore.instance.collection(Paths.userSearch).doc(widget.userId).set({
                      "marriageType" : ""
                    },SetOptions(merge: true));
                  }
                  else if(widget.screen == 5)
                  {
                    FirebaseFirestore.instance.collection(Paths.userSearch).doc(widget.userId).set({
                      "education" : ""
                    },SetOptions(merge: true));
                    setState(() {
                      this._userSearch.education="";
                    });
                  }
                  else if(widget.screen == 6)
                  {
                    FirebaseFirestore.instance.collection(Paths.userSearch).doc(widget.userId).set({
                      "employmentStatus" : ""
                    },SetOptions(merge: true));
                    setState(() {
                      this._userSearch.employment="";
                    });
                  }

                },
                  child: Container(
                    width: 70,
                    height: 25,
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
          SizedBox(height: 30,),
          if(widget.screen == 0)
            Column(
              children: [
                InkWell(
                  child: ChooseWidget(ischecked: this._userSearch.hijab == "niqab"? true:false,title: getTranslated(context, "niqab"),),
                  onTap: (){
                    setState(() {
                      this._userSearch.hijab = "niqab";
                    });
                  },
                ),
                SizedBox(height: 15,),
                InkWell(
                  child: ChooseWidget(ischecked: this._userSearch.hijab == "jilbab"?true:false,title: getTranslated(context, "jilbab"),),
                  onTap: (){
                    setState(() {
                      this._userSearch.hijab = "jilbab";
                    });
                  },
                ),
                SizedBox(height: 15,),
                InkWell(
                  child: ChooseWidget(ischecked: this._userSearch.hijab == "veil"?true:false,title: getTranslated(context, "veil"),),
                  onTap: (){
                    setState(() {
                      this._userSearch.hijab = "veil";
                    });
                  },
                ),
                SizedBox(height: 15,),
                InkWell(
                  child: ChooseWidget(ischecked: this._userSearch.hijab == "nonVeiled"? true:false,title: getTranslated(context, "nonVeiled"),),
                  onTap: (){
                    setState(() {
                      this._userSearch.hijab = "nonVeiled";
                    });
                  },
                ),
              ],
            )
          else if(widget.screen == 1)
          Column(
            children: [

                  InkWell(
                    child: ChooseWidget(ischecked: this._userSearch.skinColor!.contains("white") ?true:false,title: getTranslated(context, "white"),),
                    onTap: (){
                      setState(() {
                        this._userSearch.skinColor!.contains("white") ?this._userSearch.skinColor!.remove("white"):
                        this._userSearch.skinColor!.add("white");
                      });
                    },
                  ),
                  SizedBox(height: 15,),
              InkWell(
                child: ChooseWidget(ischecked: this._userSearch.skinColor!.contains("wheatishlight")?true:false,title: getTranslated(context, "wheatishlight"),),
                onTap: (){
                  setState(() {
                    this._userSearch.skinColor!.contains("wheatishlight") ?this._userSearch.skinColor!.remove("wheatishlight"):
                    this._userSearch.skinColor!.add("wheatishlight");
                  });
                },
              ),
                  SizedBox(height: 15,),
              InkWell(
                child: ChooseWidget(ischecked: this._userSearch.skinColor!.contains("bronze")?true:false,title: getTranslated(context, "bronze"),),
                onTap: (){
                  setState(() {
                    this._userSearch.skinColor!.contains("bronze") ?this._userSearch.skinColor!.remove("bronze"):
                    this._userSearch.skinColor!.add("bronze");
                  });
                },
              ),
                  SizedBox(height: 15,),
              InkWell(
                child: ChooseWidget(ischecked: this._userSearch.skinColor!.contains("wheatish")?true:false,title: getTranslated(context, "wheatish"),),
                onTap: (){
                  setState(() {
                    this._userSearch.skinColor!.contains("wheatish") ?this._userSearch.skinColor!.remove("wheatish"):
                    this._userSearch.skinColor!.add("wheatish");
                  });
                },
              ),

                  SizedBox(height: 15,),
              InkWell(
                child: ChooseWidget(ischecked: this._userSearch.skinColor!.contains("lightblack")?true:false,title: getTranslated(context, "lightblack"),),
                onTap: (){
                  setState(() {
                    this._userSearch.skinColor!.contains("lightblack") ?this._userSearch.skinColor!.remove("lightblack"):
                    this._userSearch.skinColor!.add("lightblack");
                  });
                },
              ),
                  SizedBox(height: 15,),
              InkWell(
                child: ChooseWidget(ischecked: this._userSearch.skinColor!.contains("darkblack")?true:false,title: getTranslated(context, "darkblack"),),
                onTap: (){
                  setState(() {
                    this._userSearch.skinColor!.contains("darkblack") ?this._userSearch.skinColor!.remove("darkblack"):
                    this._userSearch.skinColor!.add("darkblack");
                  });
                },
              )

            ],
          )

          else if(widget.screen == 2)
            Column(
              children: [
                InkWell(
                  child: ChooseWidget(ischecked: this._userSearch.maritalState == "single"? true:false,title: getTranslated(context, "single"),),
                  onTap: (){
                    setState(() {
                      this._userSearch.maritalState = "single";
                    });
                  },
                ),
                SizedBox(height: 15,),
                InkWell(
                  child: ChooseWidget(ischecked: this._userSearch.maritalState == "divorced"?true:false,title: getTranslated(context, "divorced"),),
                  onTap: (){
                    setState(() {
                      this._userSearch.maritalState = "divorced";
                    });
                  },
                ),
                SizedBox(height: 15,),
                InkWell(
                  child: ChooseWidget(ischecked: this._userSearch.maritalState == "married"?true:false,title: getTranslated(context, "married"),),
                  onTap: (){
                    setState(() {
                      this._userSearch.maritalState = "married";
                    });
                  },
                ),
                SizedBox(height: 15,),
                InkWell(
                  child: ChooseWidget(ischecked: this._userSearch.maritalState == "anotherwife"? true:false,title: getTranslated(context, "anotherwife"),),
                  onTap: (){
                    setState(() {
                      this._userSearch.maritalState = "anotherwife";
                    });
                  },
                ),
              ],
            )

          else if(widget.screen == 3)
              Column(
                children: [

                  InkWell(
                    child: ChooseWidget(ischecked: this._userSearch.religion == "sunni"?true:false,title: getTranslated(context, "sunni"),),
                    onTap: (){
                      setState(() {
                        this._userSearch.religion = "sunni";
                      });
                    },
                  ),
                  SizedBox(height: 15,),
                  InkWell(
                    child: ChooseWidget(ischecked: this._userSearch.religion == "shiite"?true:false,title: getTranslated(context, "shiite"),),
                    onTap: (){
                      setState(() {
                        this._userSearch.religion = "shiite";
                      });
                    },
                  ),
                  SizedBox(height: 15,),
                  InkWell(
                    child: ChooseWidget(ischecked: this._userSearch.religion == "convert"?true:false,title: getTranslated(context, "convert"),),
                    onTap: (){
                      setState(() {
                        this._userSearch.religion = "convert";
                      });
                    },
                  ),
                ],
              )
            else if(widget.screen == 4)
                Column(
                  children: [

                    InkWell(
                      child: ChooseWidget(ischecked: this._userSearch.marriageType == "normal"?true:false,title: getTranslated(context, "normal"),),
                      onTap: (){
                        setState(() {
                          this._userSearch.marriageType = "normal";
                        });
                      },
                    ),
                    SizedBox(height: 15,),
                    InkWell(
                      child: ChooseWidget(ischecked: this._userSearch.marriageType == "polygamy"?true:false,title: getTranslated(context, "polygamy"),),
                      onTap: (){
                        setState(() {
                          this._userSearch.marriageType = "polygamy";
                        });
                      },
                    ),
                    // SizedBox(height: 15,),
                    // InkWell(
                    //   child: ChooseWidget(ischecked: this._userSearch.marriageType == "misyar"?true:false,title: getTranslated(context, "misyar"),),
                    //   onTap: (){
                    //     setState(() {
                    //       this._userSearch.marriageType = "misyar";
                    //     });
                    //   },
                    // ),
                  ],
                )

              else if(widget.screen == 5)
                  Column(
                    children: [

                      InkWell(
                        child: ChooseWidget(ischecked: this._userSearch.education == "master"?true:false,title: getTranslated(context, "master"),),
                        onTap: (){
                          setState(() {
                            this._userSearch.education = "master";
                          });
                        },
                      ),
                      SizedBox(height: 15,),
                      InkWell(
                        child: ChooseWidget(ischecked: this._userSearch.education == "phd"?true:false,title: getTranslated(context, "phd"),),
                        onTap: (){
                          setState(() {
                            this._userSearch.education = "phd";
                          });
                        },
                      ),
                      SizedBox(height: 15,),
                      InkWell(
                        child: ChooseWidget(ischecked: this._userSearch.education == "highschool"?true:false,title: getTranslated(context, "highschool"),),
                        onTap: (){
                          setState(() {
                            this._userSearch.education = "highschool";
                          });
                        },
                      ),
                      SizedBox(height: 15,),
                      InkWell(
                        child: ChooseWidget(ischecked: this._userSearch.education == "bachelor"?true:false,title: getTranslated(context, "bachelor"),),
                        onTap: (){
                          setState(() {
                            this._userSearch.education = "bachelor";
                          });
                        },
                      ),
                      SizedBox(height: 15,),
                      InkWell(
                        child: ChooseWidget(ischecked: this._userSearch.education == "uneducated"?true:false,title: getTranslated(context, "uneducated"),),
                        onTap: (){
                          setState(() {
                            this._userSearch.education = "uneducated";
                          });
                        },
                      ),
                    ],
                  )

                else if(widget.screen == 6)
                    Column(
                      children: [

                        InkWell(
                          child: ChooseWidget(ischecked: this._userSearch.employment =="employee"?true:false,title: getTranslated(context, "employee"),),
                          onTap: (){
                            setState(() {
                              this._userSearch.employment = "employee";
                            });
                          },
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          child: ChooseWidget(ischecked: this._userSearch.employment == "manager"?true:false,title: getTranslated(context, "manager"),),
                          onTap: (){
                            setState(() {
                              this._userSearch.employment = "manager";
                            });
                          },
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          child: ChooseWidget(ischecked: this._userSearch.employment == "worker"?true:false,title: getTranslated(context, "worker"),),
                          onTap: (){
                            setState(() {
                              this._userSearch.employment = "worker";
                            });
                          },
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          child: ChooseWidget(ischecked: this._userSearch.employment == "unemployed"?true:false,title: getTranslated(context, "unemployed"),),
                          onTap: (){
                            setState(() {
                              this._userSearch.employment = "unemployed";
                            });
                          },
                        ),
                      ],
                    ),

          SizedBox(height: size.height * 0.12,),

          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.greendark2,
                      AppColors.red1
                    ]
                )
            ),
            height: 47,
            child: MaterialButton(
              onPressed: () async {
                if(widget.screen == 1)
                  {
                    await FirebaseFirestore.instance
                        .collection(Paths.userSearch)
                        .doc(widget.userId).set({
                      "skinColor" : this._userSearch.skinColor,
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
                    "maritalState" : this._userSearch.maritalState,
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
                    "religion" : this._userSearch.religion,
                  },SetOptions(merge: true)).then((value) {
                    print("user search updated");
                  }).catchError((error) {
                    print("user search update error");
                  });
                }

                if(widget.screen == 4)
                {
                  await FirebaseFirestore.instance
                      .collection(Paths.userSearch)
                      .doc(widget.userId).set({
                    "marriageType" : this._userSearch.marriageType,
                  },SetOptions(merge: true)).then((value) {
                    print("user search updated");
                  }).catchError((error) {
                    print("user search update error");
                  });
                }

                if(widget.screen == 5)
                {
                  await FirebaseFirestore.instance
                      .collection(Paths.userSearch)
                      .doc(widget.userId).set({
                    "education" : this._userSearch.education,
                  },SetOptions(merge: true)).then((value) {
                    print("user search updated");
                  }).catchError((error) {
                    print("user search update error");
                  });
                }

                if(widget.screen == 6)
                {
                  await FirebaseFirestore.instance
                      .collection(Paths.userSearch)
                      .doc(widget.userId).set({
                    "employment" : this._userSearch.employment,
                  },SetOptions(merge: true)).then((value) {
                    print("user search updated");
                  }).catchError((error) {
                    print("user search update error");
                  });
                }

                //Navigator.pop(context);
                print("kkkkkkkkkkk");
                print(this._userSearch.maritalState);
                Navigator.pop(context, this._userSearch);
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

        ]
      ),
    );
  }
}
