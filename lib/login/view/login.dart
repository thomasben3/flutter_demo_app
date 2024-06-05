import 'package:benebono_technical_ex/products/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  void _pushHome(BuildContext context) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeView()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white
            ),
            onPressed: () => _pushHome(context),
            child: Text(AppLocalizations.of(context)!.logIn)
          ),
        ),
      ),
    );
  }
}