import 'AppAppointments.dart';
import 'user.dart';

class MeetModel {
  bool isVideoCall;
  bool? normalCall = true;
  bool? iscaller = false;
  String callerId;
  String receiverId;
  String appointmentId;
  GroceryUser? loggedUser;
  AppAppointments? appointment;
  final String host;
  MeetModel(this.host,
      {required this.isVideoCall,
      required this.callerId,
      required this.receiverId,
      required this.appointmentId,
      this.loggedUser,
      this.appointment,
      this.iscaller,
      this.normalCall});
}
