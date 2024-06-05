part of 'l10n_bloc.dart';

sealed class L10nEvent extends Equatable {
  const L10nEvent();

  @override
  List<Object> get props => [];
}

class InitLocaleEvent extends L10nEvent {
  const InitLocaleEvent();
}

class ChangeLocaleEvent extends L10nEvent {
  const ChangeLocaleEvent(this.newLocale);

  final Locale newLocale;

  @override
  List<Object> get props => [newLocale];
}
