import 'dart:io';
import 'dart:ui';
import 'package:benebono_technical_ex/l10n/models/l10n_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'l10n_event.dart';
part 'l10n_state.dart';

class L10nBloc extends Bloc<L10nEvent, L10nState> {
  L10nBloc() : super(const L10nInitialState(Locale('en'))) {
    on<InitLocaleEvent>((event, emit) async {
      late String   languageCode;
      final String? languageCodeFromSP = await L10nService.getLocale();

      // get the last locale stored, if none then get the locale from the device.
      languageCode = languageCodeFromSP ?? Platform.localeName.split('_').first;

      // if the locale found above is not present in the supportedLocales list, then we use english as default language
      if (L10nState.supportedLocales.any((e) => e.languageCode == languageCode) == false) languageCode = 'en';

      // Store the locale in Shared Preferences if it didn't already exits.
      if (languageCodeFromSP == null) {
        await L10nService.setLocale(languageCode);
      }

      // Emit new state with updated locale
      emit(L10nInitialState(Locale(languageCode)));
    });

    on<ChangeLocaleEvent>((event, emit) async {
      // Do nothing if try to change locale to an unsupported one
      if (L10nState.supportedLocales.contains(event.newLocale) == false) return ;

      await L10nService.setLocale(event.newLocale.languageCode);
      emit(L10nInitialState(event.newLocale));
    });
  }
}
