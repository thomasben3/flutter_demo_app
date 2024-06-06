import 'package:benebono_technical_ex/cart/bloc/cart_bloc.dart';
import 'package:benebono_technical_ex/cart/models/cart_product.dart';
import 'package:benebono_technical_ex/cart/models/cart_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void cartBlocTests() {
  group('cart_bloc', () {
    late CartBloc cartBloc;

    setUp(() async {
      await (await initDatabase()).delete('cart_items');
      cartBloc = CartBloc();
    });

    tearDown(() => cartBloc.close());

    test('initial state is CartInitialState', () {
      expect(cartBloc.state, const CartInitialState());
    });

    blocTest<CartBloc, CartState>(
      'CartInitEvent',
      build: () => cartBloc,
      act: (bloc) => bloc.add(const CartInitEvent()),
      wait: const Duration(milliseconds: 50),
      expect: () => [
        const CartLoadedState([])
      ],
    );

    blocTest<CartBloc, CartState>(
      'AddProductToCartEvent',
      build: () => cartBloc,
      act: (bloc) async {
        bloc.add(const CartInitEvent());
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(const AddProductToCartEvent(1));
        bloc.add(const AddProductToCartEvent(2, quantity: 5));
        bloc.add(const AddProductToCartEvent(1));
      },
      expect: () => [
        const CartLoadedState([]),
        const CartLoadedState([CartProduct(id: 1, quantity: 1)]),
        const CartLoadedState([CartProduct(id: 1, quantity: 1), CartProduct(id: 2, quantity: 5)]),
        const CartLoadedState([CartProduct(id: 1, quantity: 2), CartProduct(id: 2, quantity: 5)]),
      ],
    );

    blocTest<CartBloc, CartState>(
      'SetProductQuantityEvent',
      build: () => cartBloc,
      act: (bloc) async {
        bloc.add(const CartInitEvent());
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(const SetProductQuantityEvent(1, 5));
        bloc.add(const SetProductQuantityEvent(1, 3));
        bloc.add(const SetProductQuantityEvent(1, 7));
        bloc.add(const SetProductQuantityEvent(1, 0));
      },
      expect: () => [
        const CartLoadedState([]),
        const CartLoadedState([CartProduct(id: 1, quantity: 5)]),
        const CartLoadedState([CartProduct(id: 1, quantity: 3)]),
        const CartLoadedState([CartProduct(id: 1, quantity: 7)]),
        const CartLoadedState([]),
      ],
    );

    blocTest<CartBloc, CartState>(
      'RemoveCartProductEvent',
      build: () => cartBloc,
      act: (bloc) async {
        bloc.add(const CartInitEvent());
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(const SetProductQuantityEvent(1, 2));
        bloc.add(const RemoveCartProductEvent(1));
        bloc.add(const RemoveCartProductEvent(1));
      },
      expect: () => [
        const CartLoadedState([]),
        const CartLoadedState([CartProduct(id: 1, quantity: 2)]),
        const CartLoadedState([CartProduct(id: 1, quantity: 1)]),
        const CartLoadedState([]),
      ],
    );
    
  });
}