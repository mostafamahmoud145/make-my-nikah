import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/AskQusetions.dart';
import 'package:grocery_store/models/questions.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/questions/addQuestionScreen.dart';
import 'package:grocery_store/widget/TextButton.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../../../FireStorePagnation/paginate_firestore.dart';
import '../../../widget/questionListItem.dart';
import '../../widget/app_bar_widget.dart';
import '../../widget/repeated_question_listview.dart';
import '../../widget/text_form_field_widget.dart';

class QuestionScreen extends StatefulWidget {
   final GroceryUser user;

  const QuestionScreen({Key? key,
  required this.user
   }) : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
  {
      
  late List<AskQuestions> allQuestions;

  TextEditingController searchController = TextEditingController();
  bool load = false;
  String text = "";
  late Query QusetionQuery = FirebaseFirestore.instance
              .collection(Paths.questionPath2) ;
  late Query filterQuery ;
  late Size size;
  String lang="";
  List<AskQuestions> Fillter = [];

  @override
  void initState() {
    super.initState(); 
    setState(() {
      initiateSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    lang = getTranslated(context, "lang");
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  bottom: AppPadding.p21_3.h
                ),
                child: Row(
                  children: [
                    AppBarWidget2(
                      text: getTranslated(context, "repeatedQuestions") ,
                    ),
                    Spacer(),
                      (widget.user != null 
                      && widget.user.userType == "SUPPORT"
                      )
                          ? IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddQuestionScreen(

                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.post_add_outlined,
                                color: AppColors.pink,
                              ),
                            )
                          : SizedBox(),
                  ],
                ),
              ),
              Container(
                width: size.width,
                height: AppSize.h1.h,
                color: AppColors.white3,
              ),
              
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSize.h32.h,),
                      Padding(
                        padding:EdgeInsets.symmetric(
                          horizontal: AppPadding.p32.w
                          ),
                        child: Text(
                          getTranslated(context, "hello"),
                          style: TextStyle(
                              color: AppColors.pink2,
                              fontWeight: FontWeight.bold,
                              fontFamily: getTranslated(context, 'Montserratsemibold'),
                              fontStyle: FontStyle.normal,
                              fontSize: AppFontsSizeManager.s32.sp),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: AppSize.h14_6.h,),
                      Padding(
                        padding:EdgeInsets.symmetric(
                          horizontal: AppPadding.p32.w
                          ),
                        child: Text(
                          getTranslated(context, "howCanWeHelp"),
                          style:TextStyle(
                              color: AppColors.pink2,
                              fontWeight: FontWeight.bold,
                              fontFamily: getTranslated(context, 'Montserratsemibold'),
                              fontStyle: FontStyle.normal,
                              fontSize: AppFontsSizeManager.s32.sp),
                        ),
                      ),
                      SizedBox(height: AppSize.h32.h,),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.p32.w,
                        ),
                        child: Container(
                          width: AppSize.w506_6.w,
                          height: AppSize.h70_6.h,
                          padding: EdgeInsets.only(
                            right:lang=="ar"?
                            AppPadding.p21_3.w
                            :AppPadding.p32.w,
                            left: lang=="ar"?
                            AppPadding.p32.w:
                            AppPadding.p21_3.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white2,
                            borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                          ),
                          
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: size.width*.5,
                                child: 
                                 Center(
                                  child: TextFormFieldWidget(
                                    
                                  onchange:(value) =>initiateSearch(),
                                  //initiateSearch(text),
                                  hint: getTranslated(context, "askQuestion"),
                                  width: size.width *AppSize.w0_5,
                                  height: AppSize.h28,
                                  style:TextStyle(
                                    fontWeight: FontWeight.w500,
                                      color: AppColors.black,
                                      fontSize: AppFontsSizeManager.s21_3.sp,
                                      fontFamily: getTranslated(context, 'Montserratsemibold'),
                                  ),
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                      color: AppColors.black,
                                      fontSize: AppFontsSizeManager.s21_3.sp,
                                      fontFamily: getTranslated(context, 'Montserratmedium'),
                                  ),
                                  prefixIcon: Padding(
                                    padding:lang=="ar"?
                                     EdgeInsets.only(left: AppPadding.p21_3.w)
                                    : EdgeInsets.only(right: AppPadding.p21_3.w),
                                    child: SvgPicture.asset(AssetsManager.redSearchIconPath),
                                  ),
                                  controller: searchController,
                                  textInputAction: TextInputAction.search,
                                  borderColor:AppColors.white2 ,
                                 // enableInteractiveSelection: true,
                                //readOnly: false,
                                                    
                                ),
                              )),
                              TextButton1(
                                  onPress: () {
                                 initiateSearch();
                                  },
                                  Height: AppSize.h42_6.h,
                                  Width: AppSize.w100.w,
                                  Title:getTranslated(context,"askQst"),
                                  TextFont: getTranslated(context, "Montserratsemibold"),
                                  TextSize: AppFontsSizeManager.s18_6.sp,
                                  ButtonBackground:AppColors.pink2,
                                  TextColor:AppColors.white,
                                  ButtonRadius: AppRadius.r5_3.r,
                                  ),
                                  ],
                                  ),
                                 ),
                      ),
                                  Container(
                  height: AppSize.h710.h,
                   width: size.width,
                  // color: AppColors.red,
                  child:searchController.text==""?
                  PaginateFirestore(
                    key: ValueKey(QusetionQuery),
                    separator: Center(
                      child: Padding(
                        padding:EdgeInsets.only(
                          top: AppPadding.p36.h,
                        bottom:AppPadding.p32.h
                        ),
                        child: Container(
                            color: AppColors.lightGrey6,
                            height: AppSize.h1.h,
                            width: size.width),
                      ),
                    ),
                    itemBuilderType: PaginateBuilderType.listView,
                    padding:  EdgeInsets.only(
                        left:AppPadding.p32.h,
                        right: AppPadding.p32.h,
                        // bottom: AppPadding.p16,
                        top: AppPadding.p32.h
                    ),
                    // Change types accordingly
                    itemBuilder: (context, documentSnapshot, index) {
                      return RepeatedQuestionListItem(
                        question: AskQuestions.fromMap(
                            documentSnapshot[index].data() as Map),
                        user: widget.user
                      );
                    },
                    query:QusetionQuery
                                .where('status', isEqualTo: true),
                    // to fetch real-time data
                    isLive: true,
                  )
                  : PaginateFirestore(
                    key: ValueKey(filterQuery),
                    separator: Center(
                      child: Padding(
                        padding:EdgeInsets.only(
                          top: AppPadding.p36.h,
                        bottom:AppPadding.p32.h
                        ),
                        child: Container(
                            color: AppColors.lightGrey6,
                            height: AppSize.h1.h,
                            width: size.width),
                      ),
                    ),
                    itemBuilderType: PaginateBuilderType.listView,
                    padding:  EdgeInsets.only(
                        left:AppPadding.p32.h,
                        right: AppPadding.p32.h,
                        // bottom: AppPadding.p16,
                        top: AppPadding.p32.h
                    ),
                    // Change types accordingly
                    itemBuilder: (context, documentSnapshot, index) {
                      return RepeatedQuestionListItem(
                        question: AskQuestions.fromMap(
                            documentSnapshot[index].data() as Map),
                        user: widget.user
                      );
                    },
                    query:filterQuery,
                    // to fetch real-time data
                    isLive: true,
                  ),
                                  )
                          ],
                        ),
                ],
              ),
                ]
                ),
        ),
      ),


    );
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initiateSearch();
  }


    Future<void> initiateSearch() async{
      String name = searchController.text;
      text = "0";
       Query baseQuery = QusetionQuery
        .where('status', isEqualTo: true);

    QuerySnapshot querySnapshot = await baseQuery.get();
    List<AskQuestions> list = List<AskQuestions>.from(
      querySnapshot.docs.map(
        (snapshot) => AskQuestions.fromMap(snapshot.data() as Map),
      ),
    );

    for (int x = 0; x < list.length; x++) {
      
      if (lang=="ar"?
        list[x].searchIndexAr.contains(name):
        list[x].searchIndexEn.contains(name)) {
        Fillter.add(list[x]);
      }
    }

    Fillter = Fillter.toSet().toList();

    if (Fillter.isNotEmpty) {
      filterQuery = lang=="ar"?
      baseQuery.where('searchIndexAr', arrayContainsAny: [name])
      : baseQuery.where('searchIndexEn', arrayContainsAny: [name]);
    } else {
      filterQuery = lang=="ar"?
      baseQuery.where('searchIndexAr', arrayContainsAny: [name])
      : baseQuery.where('searchIndexEn', arrayContainsAny: [name]);
    }
    setState(() {});
    print("0000000000000000000000000000000000000000000000000000000");
    print(Fillter.length);
        
    }
  }


