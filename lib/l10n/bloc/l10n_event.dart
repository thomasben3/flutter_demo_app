part of 'l10n_bloc.dart';

sealed class L10nEvent extends Equatable {
  const L10nEvent();

  @override
  List<Object> get props => [];
}

/*
  Used to init the current locale
*/
class InitLocaleEvent extends L10nEvent {
  const InitLocaleEvent();
}

/*
  Used to (try to) replace the current locale by newLocale
*/
class ChangeLocaleEvent extends L10nEvent {
  const ChangeLocaleEvent(this.newLocale);

  final Locale newLocale;

  @override
  List<Object> get props => [newLocale];
}
