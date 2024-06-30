part of 'meet_cubit.dart';

abstract class MeetStates {}

class MeetInitialState extends MeetStates {}

class MeetLoadingState extends MeetStates {}

class MeetRequestedPermissionState extends MeetStates {}

class MeetCheckedUserState extends MeetStates {}

class MeetUserCallingState extends MeetStates {}

class MeetUserRefusedState extends MeetStates {}

class MeetUserClosedState extends MeetStates {}

class MeetUserTimeOutState extends MeetStates {}

class MeetUserInCallState extends MeetStates {}

class MeetUserInAnotherState extends MeetStates {}

class MeetUserIncomingCallState extends MeetStates {}

class MeetConnectionErrorState extends MeetStates {}

class MeetErrorState extends MeetStates {}

class MeetEndingCallState extends MeetStates {}

class MeetErrorFindingToken extends MeetStates {}
