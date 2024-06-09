import 'package:benebono_technical_ex/l10n/bloc/l10n_bloc.dart';
import 'package:benebono_technical_ex/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'robots/cart.dart';
import 'robots/home.dart';
import 'robots/login.dart';

void main() {
  testWidgets('shop_integration_test', (tester) async {
    
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    
    // Here use the same BlocProvider as in the main.dart file.
    await tester.pumpWidget(BlocProvider(
      create: (context) => L10nBloc()..add(const InitLocaleEvent()),
      child: MyApp(navigatorKey: navigatorKey),
    ));

    final LoginRobot loginRobot = LoginRobot(tester: tester);

    await loginRobot.tapLoginButton();

    final HomeRobot homeRobot = HomeRobot(
      tester: tester,
      context: navigatorKey.currentContext!
    );

    await homeRobot.tapAddToCartButton();
    await homeRobot.tapAddAndRemoveButton();
    await homeRobot.addItemsFromBottomSheet(nbItem: 4);
    await homeRobot.pushToCartView();

    final CartRobot cartRobot = CartRobot(tester: tester);
    //delay to let the cartBloc init its state
    await Future.delayed(const Duration(milliseconds: 50));
    
    await cartRobot.tapAddAndRemoveButton();
    await cartRobot.updateItemsFromBottomSheet();
  });
}
