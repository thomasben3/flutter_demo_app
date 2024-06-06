import 'package:benebono_technical_ex/products/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});


  @override
  Widget build(BuildContext context) {
    void pushHome() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeView()));

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
                child: Column(
                  children: [
                    Text('Flutter demo application', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 250, child: Divider(color: Theme.of(context).primaryColor)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Practical test for ', style: TextStyle(fontSize: 18)),
                        Image.asset('assets/images/benebono_logo.png', height: 40)
                      ],
                    )
                  ],
                )
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white
                ),
                onPressed: () => pushHome(),
                child: Text(AppLocalizations.of(context)!.logIn)
              ),
              const Text('© 2024 Thomas Bensemhoun'),
            ],
          ),
        ),
      ),
    );
  }
}