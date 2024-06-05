part of 'counter_bloc.dart';

sealed class CounterState extends Equatable {
  const CounterState(int count) : _count = count;
  
  final int _count;

  int get count => _count;

  @override
  List<Object> get props => [];
}

final class CounterInitialState extends CounterState {
  const CounterInitialState(super.count);
  
  @override
  List<Object> get props => [count];
}
