import 'package:benebono_technical_ex/l10n/bloc/l10n_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/*
  Drawer of the App
*/
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // list of locales without the curent one. Used to display childrens of _LanguageSelector
    final List<Locale> localeChildrens = L10nState.supportedLocales.where((e) => e != context.read<L10nBloc>().state.currentLocale).toList();

    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      surfaceTintColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            right: MediaQuery.of(context).padding.right + 10,
            bottom: MediaQuery.of(context).padding.bottom + 10,
            left: 10
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, color: Colors.white)
              ),
              _LanguageSelector(localeChildrens: localeChildrens)
            ],
          ),
        ),
      ),
    );
  }
}

/*
  ExpansionTile used to select language.
*/
class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({
    required this.localeChildrens,
  });

  final List<Locale> localeChildrens;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      title: Text(AppLocalizations.of(context)!.language, style: const TextStyle(color: Colors.white, fontSize: 18)),
      leading: Image.asset('assets/images/flags/${context.read<L10nBloc>().state.currentLocale.languageCode}.png', height: 40),
      children: List.generate(localeChildrens.length, (index) =>
        ListTile(
          title: Text(lookupAppLocalizations(localeChildrens[index]).language, style: const TextStyle(color: Colors.white)),
          leading: Image.asset('assets/images/flags/${localeChildrens[index].languageCode}.png', height: 35),
          onTap: () => context.read<L10nBloc>().add(ChangeLocaleEvent(localeChildrens[index])),
        )
      ),
    );
  }
}
