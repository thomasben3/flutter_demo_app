import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class LoginRobot {
  final WidgetTester tester;

  LoginRobot({required this.tester});

  Future<void> tapLoginButton() async {
    final Finder loginButton = find.byType(FilledButton);
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
  }
}