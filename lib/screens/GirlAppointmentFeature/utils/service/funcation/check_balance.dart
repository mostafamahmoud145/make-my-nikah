import 'package:grocery_store/models/consultPackage.dart';
import 'package:grocery_store/models/user.dart';

bool checkBalanceGirlAppointment(
    {required consultPackage package,
    required GroceryUser consultant,
    required GroceryUser loggedUser,
    required discount}) {
  // package.price = 30;
  if (double.parse(loggedUser.balance.toString()) >=
      package.price - ((discount * package.price) / 100)) {
    return true;
  }
  return false;
}
