import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'l10n_event.dart';
part 'l10n_state.dart';

class L10nBloc extends Bloc<L10nEvent, L10nState> {
  L10nBloc() : super(const L10nInitialState(Locale('en'))) {
    on<ChangeLocaleEvent>((event, emit) {
      if (L10nState.supportedLocales.contains(event.newLocale) == false) return ;
      emit(L10nInitialState(event.newLocale));
    });
  }
}
