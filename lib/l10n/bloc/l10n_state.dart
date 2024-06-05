part of 'l10n_bloc.dart';

sealed class L10nState extends Equatable {
  const L10nState(this.currentLocale);

  final Locale currentLocale;
  
  static const supportedLocales = [
    Locale('en'),
    Locale('fr'),
  ];

  @override
  List<Object> get props => [currentLocale];
}

final class L10nInitialState extends L10nState {
  const L10nInitialState(super.locale);
}
