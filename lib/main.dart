import 'package:benebono_technical_ex/l10n/bloc/l10n_bloc.dart';
import 'package:benebono_technical_ex/login/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => L10nBloc(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Technical sample',
      locale: context.watch<L10nBloc>().state.currentLocale,
      supportedLocales: L10nState.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 220, 110, 57),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 220, 110, 57)),
        useMaterial3: true,
      ),
      home: const LoginView(),
    );
  }
}
