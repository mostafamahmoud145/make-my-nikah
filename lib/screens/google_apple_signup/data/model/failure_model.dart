
import 'package:grocery_store/screens/google_apple_signup/services/enum/http_response_status.dart';


class FailureModel{
  String? message;
  HttpResponseStatus responseStatus;
  FailureModel({required this.responseStatus, this.message});
}