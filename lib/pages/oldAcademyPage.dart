/*

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/Influencer.dart';
import 'package:grocery_store/models/appReview.dart';
import 'package:grocery_store/models/courses.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/YoutubePlayerDemoScreen.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:shimmer/shimmer.dart';

import '../config/colorsFile.dart';
import '../models/banner.dart';
import '../models/userReview.dart';
import '../models/videos.dart';
import '../widget/UserReviewItem.dart';
import '../widget/academyReviewItem.dart';
import '../widget/courseListWidget.dart';
import '../widget/influencerItem.dart';

class oldAcademyPage extends StatefulWidget {
  @override
  _oldAcademyPageState createState() => _oldAcademyPageState();
}

class _oldAcademyPageState extends State<oldAcademyPage>
    with AutomaticKeepAliveClientMixin<oldAcademyPage> {

  late AccountBloc accountBloc;
  GroceryUser? user;
  bool load = true, loadBanner = true;
  late Query query;
  List<banner> AcademyBannerList = [];
  banner? bannerItem ;

  List<AppReviews> appReviews = [];
  List<UserReviews> userReviews = [];

  bool appReviewLoad = false;
  bool userReviewLoad = false;
  Size? size;
  @override
  void initState() {
    super.initState();

    getImageSlider();
    accountBloc = BlocProvider.of<AccountBloc>(context);
    accountBloc.add(GetLoggedUserEvent());
  }
  getImageSlider() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Banners')
          .where('type', isEqualTo: "Academy")
          .where('status', isEqualTo: true)
          .get();

      var _bannerList = List<banner>.from(
        querySnapshot.docs.map(
              (snapshot) => banner.fromMap(snapshot.data() as Map),
        ),
      );

      setState(() {
        AcademyBannerList = _bannerList;
        loadBanner = false;
      });
    } catch (e) {
      setState(() {
        loadBanner = false;
        print("kkkksssasaswwwww");
        print(e.toString());
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder(
        bloc: accountBloc,
        builder: (context, state) {
          print("Account state");
          print(state);
          if (state is GetLoggedUserInProgressState) {
            return Center(child: loadWidget());
          }
          else if (state is GetLoggedUserCompletedState) {
            user=state.user;
            return  body();
          }
          else {
            return body();
          }
        },
      ),);

  }
  Widget body(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                imageSlider(size!),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated(context, "reviewTxt"),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          color: AppColors.balck2,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: size!.height * 0.27,
                  width: size!.width,
                  child: PaginateFirestore(
                    separator: SizedBox(
                      width: 10,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilderType: PaginateBuilderType.listView,
                    itemBuilder: (context, documentSnapshot, index) {
                      return AcademyReviewItem(
                          appReview: AppReviews.fromMap(
                              documentSnapshot[index].data() as Map));
                    },
                    query: FirebaseFirestore.instance
                        .collection('appReviews')
                        .orderBy('order', descending: false),
                    isLive: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated(context, "learnTxt"),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          color: AppColors.balck2,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: size!.height * .17,
                  width: size!.width,
                  child: PaginateFirestore(
                    separator: SizedBox(
                      width: 10,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilderType: PaginateBuilderType.listView,
                    itemBuilder: (context, documentSnapshot, index) {
                      return courseListWidget(
                        course:
                        Courses.fromMap(documentSnapshot[index].data() as Map),
                        loggedUser: user,
                      );
                    },
                    query: FirebaseFirestore.instance
                        .collection(Paths.CoursesPath)
                        .where('active', isEqualTo: true)
                        .orderBy('order', descending: false),
                    isLive: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated(context, "userReview"),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          color: AppColors.balck2,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: size!.height * .14,
                  width: size!.width,
                  child: PaginateFirestore(
                    separator: SizedBox(
                      width: 10,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilderType: PaginateBuilderType.listView,
                    itemBuilder: (context, documentSnapshot, index) {
                      return UserReviewItem(UserReviews.fromMap(
                          documentSnapshot[index].data() as Map));
                    },
                    query: FirebaseFirestore.instance
                        .collection('userReviews')
                        .orderBy('order', descending: false),
                    isLive: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated(context, "courses"),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          color: AppColors.balck2,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                        ),
                      ),
                      Text(
                        getTranslated(context, "all"),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          color: AppColors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: size!.height * 0.24,
                  width: size!.width,
                  child: PaginateFirestore(
                    separator: SizedBox(
                      width: 5,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilderType: PaginateBuilderType.listView,
                    itemBuilder: (context, documentSnapshot, index) {
                      return InfluencerItem(
                          influencer: Influencer.fromMap( documentSnapshot[index].data() as Map),
                          loggedUserId: user==null?"":user!.uid);
                    },
                    query: FirebaseFirestore.instance
                        .collection('Influencer')
                        .where('active', isEqualTo: true)
                        .orderBy('order', descending: false),
                    isLive: true,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ],
          // ,
        ),
      ),
    );
  }
  Widget loadWidget() {
    return Center(child: CircularProgressIndicator(color: AppColors.pink,),);
    Shimmer.fromColors(
        period: Duration(milliseconds: 800),
        baseColor: Colors.grey.withOpacity(0.6),
        highlightColor: Colors.black.withOpacity(0.6),
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size!.width * .9,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(0.0),
          ),
        ));
  }
  Widget imageSlider(Size size) {
    return AcademyBannerList.length==0?SizedBox( width: size.width * .8,
      height: size.height * 0.18,child: Center(child: CircularProgressIndicator(),),):ImageSlideshow(
      width: size.width * .8,
      height: size.height * 0.18,
      initialPage: 0,
      indicatorColor: AppColors.reddark2,
      indicatorBackgroundColor: AppColors.grey2,
      onPageChanged: (value) {},
      autoPlayInterval: 4000,
      isLoop: true,
      children: [
        for (var slideUser in AcademyBannerList)
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      YoutubePlayerDemoScreen(
                        link: slideUser.link.toString(),
                        desc: slideUser.name.toString(),
                      ),
                ),
              );
            },
            child: CachedNetworkImage(
              imageUrl: slideUser.image.toString(),
              width: size!.width * .75,
              height: size!.height * 0.18,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      AppColors.lightPink,
                      BlendMode.colorBurn,
                    ),
                  ),
                ),
              ),
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Image.asset(
                'assets/icons/icon/load.gif',
                width: 80,
                height: 80,
                //fit: BoxFit.fill,
              ),
            ),
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
*/
