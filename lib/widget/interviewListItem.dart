import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/colorsFile.dart';
import '../screens/interviewsScreen.dart';

class InterviewListItem extends StatelessWidget {
  final Size size;
  final GroceryUser user;
  final GroceryUser loggedUser;

  const InterviewListItem({
    required this.size,
    required this.user,
    required this.loggedUser,
  });

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd/MM/yy');
    String? photoUrl;
    if (user.userType == "CONSULTANT")
      photoUrl = user.photoUrl!;
    // else
    //   photoUrl=item.user.image;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InterviewScreen(
              user: user,
              loggedUser: loggedUser,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: size.width,
            padding: const EdgeInsets.only(
                left: 5.0, right: 5.0, bottom: 10.0, top: 10.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.white, width: 0),
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                  child: photoUrl!.isEmpty
                      ? Center(
                          child: Image.asset(
                          'assets/icons/icon/Mask Group 47.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.fill,
                        ))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/icons/icon/load.gif',
                            placeholderScale: 0.5,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                Image.asset('assets/icons/icon/Mask Group 47.png',
                                    width: 30, height: 30, fit: BoxFit.fill),
                            image: photoUrl,
                            fit: BoxFit.cover,
                            fadeInDuration: Duration(milliseconds: 250),
                            fadeInCurve: Curves.easeInOut,
                            fadeOutDuration: Duration(milliseconds: 150),
                            fadeOutCurve: Curves.easeInOut,
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: size.width * .5,
                                child: Text(
                                  user.name == ' '  ? '.....' : user.name!,
                                  style: TextStyle(
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    fontWeight: FontWeight.w100,
                                    fontSize: 15,
                                    color: AppColors.reddark,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: size.width * .5,
                                child: Text(
                                  user.phoneNumber!,
                                  textAlign: TextAlign.start,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    fontSize: 10.0,
                                    color: AppColors.grey,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Container(
                      //       width: size.width * .6,
                      //       child: item.lastMessage == null
                      //           ? SizedBox()
                      //           : (item.lastMessage != "imageFile" &&
                      //           item.lastMessage != "voiceFile")
                      //           ? Text(
                      //         item.lastMessage,
                      //         maxLines: 1,
                      //         overflow: TextOverflow.ellipsis,
                      //         style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      //             fontSize: 10.0,
                      //             color: AppColors.grey,
                      //             fontWeight: FontWeight.normal
                      //         ),
                      //       )
                      //           : Row(
                      //         children: [
                      //           Icon(
                      //               Icons.file_copy_outlined,
                      //               size: 15,
                      //               color: Colors.white.withOpacity(0.6)
                      //           ),
                      //           Text(
                      //             getTranslated(
                      //                 context, "attatchment"),
                      //             style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      //               fontSize: 10.0,
                      //               color:  Colors.white,
                      //               fontWeight: FontWeight.normal,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 2,
                      //     ),
                      //     (user.userType == "CONSULTANT" &&
                      //         item.consultMessageNum > 0)
                      //         ? Container(
                      //       height: 20,
                      //       width: 20,
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: Colors.green,
                      //         //border: Border.all(width: 1, color: Colors.red)
                      //       ),
                      //       child: Center(
                      //         child: Text(
                      //           user.userType == "CONSULTANT"
                      //               ? '${item.consultMessageNum.toString()}'
                      //               : '${item.userMessageNum.toString()}',
                      //           style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      //             fontSize: 10.0,
                      //             color:Colors.white,
                      //             fontWeight: FontWeight.normal,
                      //           ),
                      //         ),
                      //       ),
                      //     )
                      //         : (user.userType != "CONSULTANT" &&
                      //         item.userMessageNum > 0)
                      //         ? Container(
                      //       height: 20,
                      //       width: 20,
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: Colors.green,
                      //         //border: Border.all(width: 1, color: Colors.red)
                      //       ),
                      //       child: Center(
                      //         child: Text(
                      //           user.userType == "CONSULTANT"
                      //               ? '${item.consultMessageNum.toString()}'
                      //               : '${item.userMessageNum.toString()}',
                      //           style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      //             fontSize: 10.0,
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.normal,
                      //             letterSpacing: 0.3,
                      //           ),
                      //         ),
                      //       ),
                      //     )
                      //         : SizedBox(),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                Text(
                  // date,
                  dateFormat.format(user.createdDate!.toDate()),
                  style: TextStyle(
                    fontFamily: getTranslated(context, "fontFamily"),
                    fontSize: 12.0,
                    color: AppColors.black2,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: size.width * 0.8,
            height: 0.5,
            color: AppColors.grey2,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
