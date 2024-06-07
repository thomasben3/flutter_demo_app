import 'package:benebono_technical_ex/counter/cubit/counter_cubit.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('counter_cubit', () {
    late CounterCubit counterCubit;

    setUp(() => counterCubit = CounterCubit());

    tearDown(() => counterCubit.close());

    test('Default value is 0', () {
      expect(counterCubit.state, 0);
    });

    test('Can choose default value', () {
      counterCubit.close();
      counterCubit = CounterCubit(defaultValue: 16983);
      expect(counterCubit.state, 16983);

      counterCubit.close();
      counterCubit = CounterCubit(defaultValue: -233);
      expect(counterCubit.state, -233);
      
      counterCubit.close();
      counterCubit = CounterCubit(defaultValue: 0);
      expect(counterCubit.state, 0);
    });

    test('Increment', () {
      for (int i = 0; i < 1000; i++) {
        counterCubit.increment();
      }
      expect(counterCubit.state, 1000);
    });

    test('Decrement', () {
      for (int i = 0; i > -1000; i--) {
        counterCubit.decrement();
      }
      expect(counterCubit.state, -1000);
    });
  });
}