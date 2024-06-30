import 'package:grocery_store/models/coursePackage.dart';
import 'package:grocery_store/models/user.dart';

bool checkBalance(
    {required CoursePackage package,
    price,
    required GroceryUser loggedUser,
    required discount}) {
  package.price = double.parse(price);
  if (double.parse(loggedUser.balance.toString()) >=
      package.price - ((discount * package.price) / 100)) {
    return true;
  }
  return false;
}
