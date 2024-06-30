import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/models/userDetails.dart';
import 'package:grocery_store/screens/bioDetailsScreen.dart';

import 'girl_info_read_more.dart';

class GirlLookingForWidget extends StatelessWidget {
  const GirlLookingForWidget({
    super.key,
    required this.loadData,
    required this.userDetails,
    required this.consultant,
    this.loggedUser,
  });

  final bool loadData;
  final GroceryUser consultant;
  final GroceryUser? loggedUser;
  final UserDetail userDetails;

  @override
  Widget build(BuildContext context) {
    return GirlInfoReadMore(
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
                screen: 2,
              ),
            ),
          );
      },
      title: getTranslated(context, "aboutLife"),
      summry: consultant.partnerSpecifications!.length > 165
          ? consultant.partnerSpecifications!.substring(0, 165)
          : consultant.partnerSpecifications!,
    );
  }
}
