import 'dart:io';
import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'l10n_event.dart';
part 'l10n_state.dart';

class L10nBloc extends HydratedBloc<L10nEvent, L10nState> {
  L10nBloc() : super(const L10nInitialState(Locale('en'))) {
    on<InitLocaleEvent>((event, emit) async {
      if (state is L10nLoadedState) return ;

      // get the device current locale.
      String languageCode = Platform.localeName.split('_').first;

      // if the locale found above is not present in the supportedLocales list, then we use english as default language
      if (L10nState.supportedLocales.any((e) => e.languageCode == languageCode) == false) languageCode = 'en';

      // Emit new persistent state with updated locale
      emit(L10nLoadedState(Locale(languageCode)));
    });

    on<ChangeLocaleEvent>((event, emit) async {
      // Do nothing if try to change locale to an unsupported one
      if (L10nState.supportedLocales.contains(event.newLocale) == false) return ;

      emit(L10nLoadedState(event.newLocale));
    });
  }

  @override
  L10nState? fromJson(Map<String, dynamic> json) {
    switch (json['runtimeType'] as String) {
      case 'L10nInitialState':
        return L10nInitialState(Locale(json['currentLocale'] as String));
      case 'L10nLoadedState':
        return L10nLoadedState(Locale(json['currentLocale'] as String));
      default:
        return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(L10nState state) => {
    'runtimeType': state.runtimeType.toString(),
    'currentLocale': state.currentLocale.languageCode
  };
}
