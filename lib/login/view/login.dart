import 'package:benebono_technical_ex/l10n/bloc/l10n_bloc.dart';
import 'package:benebono_technical_ex/products/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    Text(AppLocalizations.of(context)!.flutterDemoApplication, style: const TextStyle(fontSize: 22)),
                    SizedBox(width: 250, child: Divider(color: Theme.of(context).primaryColor)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${AppLocalizations.of(context)!.practicalTestFor} ', style: const TextStyle(fontSize: 18)),
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
              const Column(
                children: [
                  _LanguageButton(),
                  Text('© 2024 Thomas Bensemhoun'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton();

  List<Locale> get _localeList => L10nState.supportedLocales;

  @override
  Widget build(BuildContext context) {
    Locale getCurrentLocale() => context.watch<L10nBloc>().state.currentLocale;

    return PopupMenuButton(
      color: const Color.fromARGB(255, 245, 245, 245),
      offset: const Offset(-60, 0),
      initialValue: getCurrentLocale(),
      icon: Image.asset('assets/images/flags/${getCurrentLocale().languageCode}.png', height: 25),
      tooltip: '',
      itemBuilder: (context) => List.generate(_localeList.length, (index) => PopupMenuItem(value: _localeList[index], child: SizedBox(
        width: 130,
        child: Row(
          children: [
            Image.asset('assets/images/flags/${_localeList[index].languageCode}.png', height: 35),
            const SizedBox(width: 10),
            Text(lookupAppLocalizations(_localeList[index]).language, softWrap: true,),
          ],
        ),
      ))),
      onSelected: (value) => context.read<L10nBloc>().add(ChangeLocaleEvent(value)),
    );
  }
}