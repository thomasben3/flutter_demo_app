import 'package:benebono_technical_ex/cart/bloc/cart_bloc.dart';
import 'package:benebono_technical_ex/cart/widgets/cart_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class CartRobot {
  final WidgetTester tester;

  CartRobot({
    required this.tester
  });

  final CartBloc cartBloc = CartBloc()..add(const CartInitEvent());

  int get _initialFirstItemQuantity => cartBloc.state.products.first.quantity;

  /*
    To maintain these tests readable and scalable, they all end with the same state as the initial one.
  */

  Future<void> tapAddAndRemoveButton() async {
    final Finder addButton = find.byIcon(Icons.add_rounded);
    final Finder removeButton = find.byIcon(Icons.remove_rounded);
    
    expect(addButton, findsOneWidget);
    expect(removeButton, findsOneWidget);

    await tester.tap(addButton);
    await tester.pumpAndSettle();
    expect(find.text((_initialFirstItemQuantity + 1).toString()), findsOneWidget); 

    await tester.tap(removeButton);
    await tester.pumpAndSettle();
    expect(find.text((_initialFirstItemQuantity).toString()), findsOneWidget);
  }

  Future<void> updateItemsFromBottomSheet() async {

    /*
      In this function we always use the last item found because the last layer of the tree is the bottomSheet.
    */

    final Finder updateButton = find.byType(ElevatedButton);

    Future<void> openBottomSheet() async {
      await tester.tap(find.byType(CartProductWidget).first);
      await tester.pumpAndSettle();
    }

    await openBottomSheet();
    expect(find.text((_initialFirstItemQuantity).toString()), findsExactly(2)); // <-- 2 including the one behind the bottom sheet

    final Finder addButton = find.byIcon(Icons.add_rounded);

    await tester.tap(addButton.last);
    await tester.pumpAndSettle();
    expect(find.text((_initialFirstItemQuantity + 1).toString()), findsOneWidget);

    await tester.tap(updateButton.last);
    await tester.pumpAndSettle();
    expect(find.text((_initialFirstItemQuantity + 1).toString()), findsOneWidget);

    await openBottomSheet();

    final Finder removeButton = find.byIcon(Icons.remove_rounded);

    await tester.tap(removeButton.last);
    await tester.pumpAndSettle();
    expect(find.text((_initialFirstItemQuantity).toString()), findsOneWidget);

    await tester.tap(updateButton.last);
    await tester.pumpAndSettle();
    expect(find.text((_initialFirstItemQuantity).toString()), findsOneWidget);
  }
}