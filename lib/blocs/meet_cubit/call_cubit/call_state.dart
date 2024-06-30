part of 'call_cubit.dart';

@immutable
abstract class CallStates {}

class CallInitialState extends CallStates {}

class CallChangeState extends CallStates {}

class CallOnCanceledState extends CallStates {}
