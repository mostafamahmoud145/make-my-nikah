import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/models/userDetails.dart';

Future<Map<dynamic, dynamic>> getuserDetails(
    {GroceryUser? loggedUser, userID}) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(Paths.userDetail)
        .doc(userID)
        .get();
    var details = UserDetail.fromMap(snapshot.data() as Map);
    bool check = false;
    if (loggedUser != null) {
      check = details.partnerOrigin != null &&
          (details.partnerOrigin == "notinterest" ||
              details.partnerOrigin == loggedUser.origin) &&
          details.partnerDoctrine != null &&
          (details.partnerDoctrine == "notinterest" ||
              details.partnerDoctrine == loggedUser.doctrine) &&
          details.partnerEducationalLevel != null &&
          (details.partnerEducationalLevel == "notinterest" ||
              details.partnerEducationalLevel == loggedUser.education) &&
          details.partnerEmploymentStatus != null &&
          (details.partnerEmploymentStatus == "notinterest" ||
              details.partnerEmploymentStatus == loggedUser.employment) &&
          details.partnerLivingStander != null &&
          (details.partnerLivingStander == "notinterest" ||
              details.partnerLivingStander == loggedUser.living) &&
          details.partnerMaritalState != null &&
          (details.partnerMaritalState == "notinterest" ||
              details.partnerMaritalState == loggedUser.maritalStatus) &&
          details.partnerSpecialization != null &&
          (details.partnerSpecialization == "notinterest" ||
              details.partnerSpecialization == loggedUser.specialization) &&
          details.partnerSmoking != null &&
          (details.partnerSmoking == "notinterest" ||
              details.partnerSmoking == loggedUser.smooking) &&
              details.partnerTribal!=null&&
          (details.partnerTribal == "notinterest" ||
              details.partnerTribal == loggedUser.tribal) &&
          details.partnerMinAge != null &&
          details.partnerMaxAge != null &&
          loggedUser.age! >= details.partnerMinAge! &&
          loggedUser.age! <= details.partnerMaxAge! &&
          details.partnerMinHeight != null &&
          details.partnerMaxHeight != null &&
          loggedUser.length! >= details.partnerMinHeight! &&
          loggedUser.length! <= details.partnerMaxHeight! &&
          details.partnerMinWeight != null &&
          details.partnerMaxWeight != null &&
          loggedUser.weight! >= details.partnerMinWeight! &&
          loggedUser.weight! <= details.partnerMaxWeight!;
          print("///////////////////////////////");
          print(details);
    }
    return {"userDetails": details, "loadData": false, "validPartner": check};
  } catch (e) {
    print("jjjjjjjj");
    print(e.toString());
    return {"userDetails": null, "loadData": false, "validPartner": false};
  }
}
