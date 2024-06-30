
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/Influencer.dart';
import 'package:grocery_store/models/appReview.dart';
import 'package:grocery_store/models/courses.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/YoutubePlayerDemoScreen.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../FireStorePagnation/paginate_firestore.dart';import 'package:shimmer/shimmer.dart';

import '../config/app_values.dart';
import '../config/colorsFile.dart';
import '../models/banner.dart';
import '../models/userReview.dart';
import '../models/videos.dart';
import '../widget/CoachListItem.dart';
import '../widget/UserReviewItem.dart';
import '../widget/academyReviewItem.dart';
import '../widget/image_slider_widget.dart';
import '../widget/courseListWidget.dart';
import '../widget/influencerItem.dart';

class CoachesPage extends StatefulWidget {
  @override
  _CoachesPageState createState() => _CoachesPageState();
}

class _CoachesPageState extends State<CoachesPage>
    with AutomaticKeepAliveClientMixin<CoachesPage> {

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
          .where('type', isEqualTo: "Coaches")
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
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: convertPtToPx(AppSize.h25.h),),
        /// -SLIDER_WIDGET- ///
        ImageSliderWidget(AcademyBannerList:AcademyBannerList ,),
        SizedBox(height: convertPtToPx(AppSize.h25.h),),
        Expanded(
          child: PaginateFirestore(
            itemBuilderType: PaginateBuilderType.gridView,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSize.w21_3.w,
                mainAxisSpacing: AppSize.h32.h,
                mainAxisExtent:AppSize.h260.h,
                //childAspectRatio: .5
            ),
            padding: EdgeInsets.only(
                left: AppSize.w32.w,
                right: AppSize.w32.w,
                ),
            itemBuilder: (context, documentSnapshot, index) {
              return CoachListItem(
                  consult:  GroceryUser.fromMap(documentSnapshot[index].data() as Map),
                  loggedUser: user);
            },
            query: FirebaseFirestore.instance
                .collection('Users')
                .where('userType', isEqualTo: 'COACH')
                //.where('phoneNumber', isEqualTo: '+966333333333')
                .where('accountStatus', isEqualTo: "Active")
                .orderBy('order', descending: true),
            isLive: true,
          ),
        )
      ],
    );
  }
  Widget loadWidget() {
    return Center(child: CircularProgressIndicator(color: AppColors.pink,),);

  }

  Widget imageSlider2(Size size) {
    return AcademyBannerList.length==0?SizedBox( width: size.width * .85,
      height: size.height * 0.15,child: Center(child: CircularProgressIndicator(),),):ImageSlideshow(
      initialPage: 0,
      indicatorColor: Colors.transparent,
      indicatorBackgroundColor: Colors.transparent,
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
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
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
