import 'package:benebono_technical_ex/l10n/bloc/l10n_bloc.dart';
import 'package:benebono_technical_ex/login/view/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
      ? HydratedStorage.webStorageDirectory
      : await getApplicationDocumentsDirectory(),
  );
  
  runApp(BlocProvider(
    create: (context) => L10nBloc()..add(const InitLocaleEvent()),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    this.navigatorKey
  });

  // Used to access AppLocalizations.of(context) in integration tests.
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
