import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/FireStorePagnation/paginate_firestore.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/userAppointmentWiget.dart';

//import 'package:paginate_firestore/paginate_firestore.dart';
import '../config/app_fonts.dart';
import '../config/app_values.dart';
import '../config/colorsFile.dart';
import '../widget/tab_bar_widget.dart';
import '../widget/tab_button.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage>
    with AutomaticKeepAliveClientMixin<AppointmentsPage> {
  final TextEditingController searchController = new TextEditingController();

  late AccountBloc accountBloc;
  GroceryUser? user;
  bool load = true;
  bool fixed = true, closed = false;
  bool active = false;

  @override
  void initState() {
    super.initState();
    accountBloc = BlocProvider.of<AccountBloc>(context);
    accountBloc.add(GetLoggedUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder(
        bloc: accountBloc,
        builder: (context, state) {
          print("Account state");
          print(state);
          if (state is GetLoggedUserInProgressState) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.reddark2,
            ));
          } else if (state is GetLoggedUserCompletedState) {
            user = state.user;
            return Column(
              children: <Widget>[
                SizedBox(
                  height: AppSize.h32.h,
                ),

                /// -TAP BAR WIDGET- ///
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.p32.w
                    ),
                    width: size.width,
                    height: AppSize.h72.h,
                    child: TabBarWidget(
                       width: size.width,
                    height: AppSize.h72.h,
                        radius: AppRadius.r16.r,
                        buttons: [
                          //button x
                          TabButton(
                            onPress: () {
                              setState(() {
                                fixed = true;
                                closed = false;
                              });
                            },
                            Height: AppSize.h53_3.h,
                            Width: AppSize.w176.w,
                            ButtonRadius: AppRadius.r10_6.r,
                            ButtonColor:
                                fixed ? AppColors.pink2 : Colors.transparent,
                            Title: getTranslated(context, "fixed"),
                            TextFont:
                                getTranslated(context, "Montserratsemibold"),
                            TextSize: AppFontsSizeManager.s21_3.sp,
                            TextColor:
                                fixed ? AppColors.white : AppColors.darkGrey,
                          ),
                          //button y
                          Spacer(),
                          TabButton(
                            onPress: () {
                              setState(() {
                                fixed = false;
                                closed = true;
                              });
                            },
                            Height: AppSize.h53_3.h,
                            Width: AppSize.w176.w,
                            ButtonRadius: AppRadius.r10_6.r,
                            ButtonColor:
                                closed ? AppColors.pink2 :
                                 Colors.transparent,
                            Title: getTranslated(context, "closed"),
                            TextFont:
                                getTranslated(context, "Montserratsemibold"),
                            TextSize: AppFontsSizeManager.s21_3.sp,
                            TextColor:
                                closed ? AppColors.white 
                                : AppColors.darkGrey,
                          ),
                        ],
                        padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.p32.w
                    ,vertical:AppPadding.p9_3.r)),
                  ),
                ),
                SizedBox(
                  height: AppSize.h32.h,
                ),
                fixed
                    ? Expanded(
                        child: PaginateFirestore(
                          separator: SizedBox(
                           height: AppSize.h32.h,
                          ),
                          itemBuilderType: PaginateBuilderType.listView,
                          padding: EdgeInsets.only(
                              left:AppSize.w53_3.w,
                              right: AppSize.w53_3.w,
                             
                              ),
                          itemBuilder: (context, documentSnapshot, index) {
                            return UserAppointmentWiget(
                              appointment: AppAppointments.fromMap(
                                  documentSnapshot[index].data() as Map),
                              loggedUser: user!,
                            );
                          },
                          query: FirebaseFirestore.instance
                              .collection(Paths.appAppointments)
                              .where('user.uid', isEqualTo: user!.uid)
                              .where('appointmentStatus', isEqualTo: "open")
                              .orderBy('secondValue', descending: true),
                          isLive: true,
                        ),
                      )
                    : SizedBox(),
                closed
                    ? Expanded(
                        child: PaginateFirestore(
                          separator: SizedBox(
                            height: AppSize.h32.h,
                          ),
                          itemBuilderType: PaginateBuilderType.listView,
                          padding: EdgeInsets.only(
                              left:AppSize.w53_3.w,
                              right: AppSize.w53_3.w,),
                          itemBuilder: (context, documentSnapshot, index) {
                            return UserAppointmentWiget(
                              appointment: AppAppointments.fromMap(
                                  documentSnapshot[index].data() as Map),
                              loggedUser: user!,
                            );
                          },
                          query: FirebaseFirestore.instance
                              .collection(Paths.appAppointments)
                              .where('user.uid', isEqualTo: user!.uid)
                              .where('appointmentStatus', isEqualTo: "closed")
                              .orderBy('secondValue', descending: true),
                          isLive: true,
                        ),
                      )
                    : SizedBox(),
              ],
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.reddark2,
            ));
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
