import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/Utils/extensions/printing_extension.dart';

import 'package:meta/meta.dart';

part 'call_state.dart';

class CallCubit extends Cubit<CallStates> {
  static CallCubit get(context) => BlocProvider.of(context);

  StartCallStates callState = StartCallStates.loading;

  CallCubit() : super(CallInitialState());

  Future<void>? changeCallState(StartCallStates state) {
    callState = state;
    state.toString().logPrint();
    emit(CallChangeState());
    return null;
  }

  void emittingOnCancel() {
    emit(CallOnCanceledState());
  }

  @override
  void onChange(Change<CallStates> change) {
    change.toString().logPrint();
    super.onChange(change);
  }
}

enum StartCallStates {
  loading,
  inCall,
  permissionsNotAllowed,
  callEnded,
}
