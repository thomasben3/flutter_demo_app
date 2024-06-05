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
      // get the last locale stored, if none then get the locale from the device.
      String languageCode = (await L10nService.getLocale()) ?? Platform.localeName.split('_').first;
      
      // if the locale found above is not present in the supportedLocales list, then we use english as default language
      if (L10nState.supportedLocales.any((e) => e.languageCode == languageCode) == false) languageCode = 'en';

      emit(L10nInitialState(Locale(languageCode)));
    });

    on<ChangeLocaleEvent>((event, emit) async {
      if (L10nState.supportedLocales.contains(event.newLocale) == false) return ;

      await L10nService.setLocale(event.newLocale.languageCode);

      emit(L10nInitialState(event.newLocale));
    });
  }
}
