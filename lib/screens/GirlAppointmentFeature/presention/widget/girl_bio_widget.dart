import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/models/userDetails.dart';
import 'package:grocery_store/screens/bioDetailsScreen.dart';

import 'girl_info_read_more.dart';

class GirlBioWidget extends StatelessWidget {
  const GirlBioWidget({
    super.key,
    required this.loadData,
    required this.userDetails,
    required this.consultant,
    this.loggedUser,
  });

  // final GirlDetailsView widget;
  final GroceryUser consultant;
  final GroceryUser? loggedUser;
  final bool loadData;
  final UserDetail userDetails;

  @override
  Widget build(BuildContext context) {
    return GirlInfoReadMore(
      summry: consultant.bio!.length > 165
          ? consultant.bio!.substring(0, 165)
          : consultant.bio!,
      title: getTranslated(context, "bio2"),
      onTapreadMore: () {
        if (loadData) {
        } else
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BioDetailsScreen(
                consult: consultant,
                consultDetails: userDetails,
                loggedUser: loggedUser,
                screen: 1,
              ),
            ),
          );
      },
    );
  }
}
