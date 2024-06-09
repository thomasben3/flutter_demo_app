import 'package:benebono_technical_ex/products/widgets/cart_floating_button.dart';
import 'package:benebono_technical_ex/products/widgets/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeRobot {
  final WidgetTester tester;
  final BuildContext context;

  const HomeRobot({
    required this.tester,
    required this.context
  });

  Future<void> tapAddToCartButton() async {
    final Finder addToCartButton = find.byIcon(ProductWidget.addToCartIcon);
    
    expect(addToCartButton, findsAny);

    await tester.tap(addToCartButton.first);
    await tester.pumpAndSettle();
    
    // We want to find exactly 2 rather than 1 because there is also the total quantity in the cart shown on the ElevatedButton.
    expect(find.text('1'), findsExactly(2));
  }

  Future<void> tapAddAndRemoveButton() async {
    final Finder addButton = find.byIcon(Icons.add_rounded);
    final Finder removeButton = find.byIcon(Icons.remove_rounded);
    
    expect(addButton, findsOneWidget);
    expect(removeButton, findsOneWidget);

    await tester.tap(addButton);
    await tester.pumpAndSettle();
    expect(find.text('2'), findsExactly(2)); 

    await tester.tap(removeButton);
    await tester.pumpAndSettle();
    expect(find.text('1'), findsExactly(2));

    await tester.tap(removeButton);
    await tester.pumpAndSettle();
    expect(find.text('1'), findsNothing);
  }

  Future<void> addItemsFromBottomSheet({final int nbItem = 1}) async {
    /*
      In order to work, this function needs to be called with no first product of the list in the cart.
    */
    assert(nbItem > 0, 'nbItem must be greater than 0');

    await tester.tap(find.byType(ProductWidget).first);
    await tester.pumpAndSettle();
    
    final Finder addButton = find.byIcon(Icons.add_rounded);

    for (int i = 0; i < nbItem - 1; i++) {
      await tester.tap(addButton.first);
      await tester.pumpAndSettle();
    }

    await tester.pumpAndSettle();
    expect(find.text(nbItem.toString()), findsOneWidget); 

    final Finder addToCartButton = find.byType(ElevatedButton);

    await tester.tap(addToCartButton.first);
    await tester.pumpAndSettle();
    expect(find.text(nbItem.toString()), findsExactly(2));
  }

  Future<void> pushToCartView() async {
    final Finder cartButton = find.byType(CartFloatingButton);
    expect(cartButton, findsOneWidget);

    await tester.tap(cartButton);
    await tester.pumpAndSettle();

    expect(find.text(AppLocalizations.of(context)!.myCart), findsOneWidget);
  }
}