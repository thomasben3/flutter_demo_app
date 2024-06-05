part of 'counter_bloc.dart';

sealed class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

class CounterIncrementEvent extends CounterEvent {
  const CounterIncrementEvent();
}

class CounterDecrementEvent extends CounterEvent {
  const CounterDecrementEvent({
    this.min
  });

  final int? min;
}