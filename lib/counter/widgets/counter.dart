import 'package:benebono_technical_ex/counter/cubit/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Counter extends StatelessWidget {
  const Counter({
    super.key,
    this.min,
    this.max,
    this.colorWhen0
  });

  final int?    min;
  final int?    max;
  final Color?  colorWhen0;

  static const int _defaultMin = -999;
  static const int _defaultMax = 999;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          style: IconButton.styleFrom(backgroundColor: Colors.white),
          onPressed: context.read<CounterCubit>().state > (min ?? _defaultMin) ? () => context.read<CounterCubit>().decrement() : null,
          icon: const Icon(Icons.remove_rounded)
        ),
        BlocBuilder<CounterCubit, int>(
          builder: (context, state) => Text(
            state.toString(),
            style: colorWhen0 != null && state == 0 ?
              TextStyle(color: colorWhen0)
              : null
          ),
        ),
        IconButton(
          style: IconButton.styleFrom(backgroundColor: Colors.white),
          onPressed: context.read<CounterCubit>().state < (max ?? _defaultMax) ? () => context.read<CounterCubit>().increment() : null,
          icon: const Icon(Icons.add_rounded)
        )
      ],
    );
  }
}
