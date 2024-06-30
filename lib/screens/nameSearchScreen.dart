
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/screens/techUserDetails/userDetailsScreen.dart';
import '../FireStorePagnation/paginate_firestore.dart';import '../config/colorsFile.dart';
class NameSearchScreen extends StatefulWidget {
  final GroceryUser loggedUser;

  const NameSearchScreen({Key? key, required this.loggedUser}) : super(key: key);
  @override
  _NameSearchScreenState createState() => _NameSearchScreenState();
}

class _NameSearchScreenState extends State<NameSearchScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = new TextEditingController();
  bool load=false;
  String name ="";
  late Query filterQuery;
  late Size size;
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
     size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key:_scaffoldKey,
      body: Column(
          children: <Widget>[
            Container(
                width: size.width,
                child: SafeArea(
                    child: Padding( padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 0.0, bottom: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 35,
                                width: 35,

                                child: Center(
                                  child: IconButton(
                                    onPressed: () {

                                      Navigator.pop(context);
                                    },
                                    icon: Image.asset(
                                      getTranslated(context, "back"),
                                      width: 20,
                                      height: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                getTranslated(context, "nameSearch"),
                                textAlign:TextAlign.left,
                                style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),fontSize: 17.0,color:AppColors.balck2,fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                         SizedBox()

                        ],
                      ),
                    ))),
            Center(
                child: Container(
                    color: AppColors.white3, height: 1, width: size.width )),
            SizedBox(height: 25,),
            Center(child: Container(height: 50,width: size.width*.9,child:
              Container(

              padding: const EdgeInsets.symmetric( horizontal: 1.0, vertical: 0.0),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(10.0),

              ),
              child: TextField(
                onChanged: (val) => initiateSearch(val),
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
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                    size: 25.0,
                  ),
                  border: InputBorder.none,
                  hintText: getTranslated(context, "nameSearch"),
                  hintStyle: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                    fontSize: 14.5,
                    color: Theme.of(context).primaryColor,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            ),),
            SizedBox(height: 15,),
            name==""?Expanded(
              child: Center(
                  child: SizedBox()
              ),
            ):Expanded(
              child: PaginateFirestore(
                key: ValueKey(filterQuery),
                itemBuilderType: PaginateBuilderType.listView,
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),//Change types accordingly
                itemBuilder: ( context, documentSnapshot,index) {
                  return  NameWidget( GroceryUser.fromMap(documentSnapshot[index].data() as Map),size );
                },
                separator: Center( child: Container(  color: AppColors.white3, height: 1, width: size.width )),

                query:filterQuery,
                isLive: true,
              ),
            )


          ],
        ),
    );
  }

  void initiateSearch(String val) {
    setState(() {
      name = val.toLowerCase();//.trim();
      filterQuery=FirebaseFirestore.instance.collection(Paths.usersPath)
          .where('searchIndex', arrayContains: name)
          .orderBy('name', descending: true);
    });
  }
  Widget NameWidget(GroceryUser user,size){
    return InkWell(onTap: (){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailsScreen(
            user: user,
            loggedUser: widget.loggedUser,
          ),
        ),
      );
    },
      child: Container(
        width: size.width,
        padding: const EdgeInsets.only( left: 5.0, right: 5.0, bottom: 10.0, top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.white,width: 0),
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
              child: user.photoUrl!.isEmpty ?Image.asset('assets/applicationIcons/whiteLogo.png',width: 50,height: 50,fit:BoxFit.fill,)
                  :ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: FadeInImage.assetNetwork(
                  placeholder:'assets/icons/icon/load.gif',
                  placeholderScale: 0.5,
                  imageErrorBuilder:(context, error, stackTrace) => Image.asset('assets/applicationIcons/whiteLogo.png',width: 50,height: 50,fit:BoxFit.fill),
                  image: user.photoUrl!,
                  fit: BoxFit.cover,
                  fadeInDuration:
                  Duration(milliseconds: 250),
                  fadeInCurve: Curves.easeInOut,
                  fadeOutDuration:
                  Duration(milliseconds: 150),
                  fadeOutCurve: Curves.easeInOut,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Text(user.name =="null"?".":user.name!,
                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),fontWeight: FontWeight.w100,
                  fontSize: 12,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
