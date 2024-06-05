import 'package:benebono_technical_ex/counter/bloc/counter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Counter extends StatelessWidget {
  const Counter({
    super.key,
    this.value,
    this.min,
    this.colorWhen0
  });

  final int?    value;
  final int?    min;
  final Color?  colorWhen0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          style: IconButton.styleFrom(backgroundColor: Colors.white),
          onPressed: () => context.read<CounterBloc>().add(CounterDecrementEvent(min: min)),
          icon: const Icon(Icons.remove_rounded)
        ),
        BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) => Text(
            state.count.toString(),
            style: colorWhen0 != null && state.count == 0 ?
              TextStyle(color: colorWhen0)
              : null
          ),
        ),
        IconButton(
          style: IconButton.styleFrom(backgroundColor: Colors.white),
          onPressed: () => context.read<CounterBloc>().add(const CounterIncrementEvent()),
          icon: const Icon(Icons.add_rounded)
        )
      ],
    );
  }
}
