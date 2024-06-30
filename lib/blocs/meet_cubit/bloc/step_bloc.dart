import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'step_event.dart';
part 'step_state.dart';

class StepBloc extends Bloc<StepEvent, StepState> {
  StepBloc() : super(StepInitial()) {
    on<StepEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
