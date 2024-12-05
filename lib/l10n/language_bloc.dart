import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// MARK: LanguageState

class LanguageState {
  const LanguageState({required this.locale});
  final Locale locale;

  LanguageState copyWith({Locale? locale}) =>
      LanguageState(locale: locale ?? this.locale);
}

/// MARK: LocaleSupport
class LocaleSupport {
  static List<Locale> localeSupport = [const Locale('vi'), const Locale('en')];
}

/// MARK: Language Bloc
class LanguageBloc extends Cubit<LanguageState> {
  LanguageBloc() : super(const LanguageState(locale: Locale('en'))) {
    _loadLanguage();
  }

  _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    emit(state.copyWith(locale: Locale(languageCode)));
  }

  Future<void> changeLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final currentLocale = state.locale;

    final newLocale = (currentLocale == LocaleSupport.localeSupport.first)
        ? LocaleSupport.localeSupport.last
        : LocaleSupport.localeSupport.first;

    await prefs.setString('language_code', newLocale.languageCode);

    emit(state.copyWith(locale: newLocale));
  }
}
