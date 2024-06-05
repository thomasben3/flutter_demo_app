import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc(int? initialValue) : super(CounterInitialState(initialValue ?? 0)) {
    on<CounterIncrementEvent>((event, emit) {
      emit(CounterInitialState(state.count + 1));
    });

    on<CounterDecrementEvent>((event, emit) {
      if (event.min != null) {
        emit(CounterInitialState(max(event.min!, state.count - 1)));
      } else {
        emit(CounterInitialState(state.count - 1));
      }
    });
  }
}
