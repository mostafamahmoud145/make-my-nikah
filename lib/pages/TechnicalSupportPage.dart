
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/SupportList.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/screens/nameSearchScreen.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/supportListItem.dart';
//import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import '../FireStorePagnation/bloc/pagination_listeners.dart';
import '../FireStorePagnation/paginate_firestore.dart';
class TechnicalSupportPage extends StatefulWidget {
  @override
  _TechnicalSupportPageState createState() => _TechnicalSupportPageState();
}

class _TechnicalSupportPageState extends State<TechnicalSupportPage> with AutomaticKeepAliveClientMixin<TechnicalSupportPage> {
  final TextEditingController searchController = new TextEditingController();
  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();

  late AccountBloc accountBloc;
  GroceryUser? user;
  late bool load;
  bool avaliable=false;
  DateTime _now = DateTime.now();
  String name ="";
  late Query filterQuery;

  @override
  void initState() {
    super.initState();
    accountBloc = BlocProvider.of<AccountBloc>(context);
    accountBloc.add(GetLoggedUserEvent());
    load=true; 

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder(
        bloc: accountBloc,
        builder: (context, state) {
          print("Account state");
          print(state);
          if (state is GetLoggedUserInProgressState) {
            return Center(child: CircularProgressIndicator());
          }
          else if (state is GetLoggedUserCompletedState) {
            user=state.user;
            initiateSearch("");
            return  Stack(children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 5,),
                  user!.userType=="SUPPORT"?  Center(child: Container(height: 50,width: size.width*.9,child:
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Container(height: 40,width: size.width*.7,
                        padding: const EdgeInsets.symmetric( horizontal: 1.0, vertical: 0.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grey,
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(0.0, 1.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Center(
                          child: TextField(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NameSearchScreen(loggedUser: user!,),
                                ),
                              );
                            },
                            keyboardType: TextInputType.text,
                            controller: searchController,
                            textInputAction: TextInputAction.search,
                            enableInteractiveSelection: true,
                            readOnly:false,
                            style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                              fontSize: 14.5,
                              color: Colors.black87,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                              prefixIcon:Icon(Icons.search, size: 14,color:AppColors.pink),
                              suffixIcon: InkWell(
                                  child: Icon(Icons.send_rounded, size: 14), onTap: () {
                                //initiateSearch(searchController.text);
                              }),
                              border: InputBorder.none,
                              hintText: getTranslated(context, "name"),
                              hintStyle: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                fontSize: 14.5,
                                color: Theme.of(context).primaryColor,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(height: 40,width: size.width*.15,
                        decoration: new BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,),
                        child: InkWell(
                            child: Icon(Icons.wifi_protected_setup, size: 18,color: AppColors.pink,), onTap: () {
                          closeAll();
                        }),
                      ),
                    ],
                  ),
                  ),):SizedBox(),
                  SizedBox(height: AppSize.h10_6.h,),
                  Expanded(
                    child: RefreshIndicator(
                      child: PaginateFirestore(
                        key: ValueKey(filterQuery),
                        itemBuilderType: PaginateBuilderType.listView,
                        padding:EdgeInsets.symmetric(horizontal: AppPadding.p32.w),//Change types accordingly
                        itemBuilder: ( context, documentSnapshot,index) {
                          return  SupportListItem(
                            size:size,
                            item: SupportList.fromMap(documentSnapshot[index].data() as Map),
                            user:user!,
                          );

                        },
                        query: filterQuery,
                        listeners: [
                          refreshChangeListener,
                        ],
                        isLive: true,
                      ),
                      onRefresh: () async {
                        refreshChangeListener.refreshed = true;
                      },
                    ),
                  )
                ],
              ),

            ]);
          }
          else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),

    );
  }
  closeAll() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection(Paths.supportListPath)
          .where('openingStatus', isEqualTo: true)
          .get();
      for (var doc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection(Paths.supportListPath)
            .doc(doc.id)
            .update({
          'openingStatus': false,
        });
      }
    } catch (e) {
      print("jjjjjjjkkkk" + e.toString());
    }
  }
  void initiateSearch(String val) {
    if( user!.userType=="SUPPORT"&&val=="")
      filterQuery=FirebaseFirestore.instance.collection('SupportList')
          .orderBy('messageTime', descending: true);
    else if( user!.userType=="SUPPORT"&&val!="")
      filterQuery=FirebaseFirestore.instance.collection('SupportList')
          .where('userName', isEqualTo: val)
          .orderBy('messageTime', descending: true);
    else
      filterQuery= FirebaseFirestore.instance.collection('SupportList')
          .where('userUid', isEqualTo: user!.uid)
          .orderBy('messageTime', descending: true);


  }

  checkAvaliable() async {

    if(user!=null&&user!.userType=="CONSULTANT"&&user!.profileCompleted==true)
    {
      String dayNow=_now.weekday.toString();
      int timeNow=_now.hour;
      if(user!.workDays!.contains(dayNow))
      {
        if (int.parse(user!.workTimes![0].from! )<=timeNow&&int.parse(user!.workTimes![0].to! )>timeNow) {
          avaliable=true;

        }
      }
    }

  }
  @override
  bool get wantKeepAlive => true;
}
