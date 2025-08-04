/**
 * Provides internationalization support for the app.
 * Loads translations from JSON files based on the current locale.
 */
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Handles loading and accessing localized strings for the dealership management app.
class AppLocalizations {
  /// The current locale for translations
  final Locale locale;

  /// Map storing all localized strings for the current locale
  late Map<String, String> _localizedStrings;

  /// Creates an instance of AppLocalizations for the given locale
  AppLocalizations(this.locale);

  /// Retrieves the AppLocalizations instance for the current context
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// The delegate for this localization class
  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  /// Loads translations from JSON file for the current locale
  ///
  /// Returns `true` if loading was successful, `false` otherwise
  Future<bool> load() async {
    try {
      final jsonString = await rootBundle
          .loadString('assets/lang/Dealership/${locale.languageCode}.json');
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;

      _localizedStrings = jsonMap.map((key, value) =>
          MapEntry(key, value.toString()));
      return true;
    } catch (e) {
      _localizedStrings = {};
      return false;
    }
  }

  /**
   * Translates a key to the current locale's string.
   *
   * Optionally replaces placeholders with provided parameters.
   *
   * @param key The translation key to look up
   * @param params Optional map of parameters to replace in the translated string
   * @return The translated string with parameters replaced, or the key if no translation found
   */
  String translate(String key, {Map<String, String> params = const {}}) {
    var translation = _localizedStrings[key] ?? key;
    params.forEach((paramKey, paramValue) {
      translation = translation.replaceAll('{$paramKey}', paramValue);
    });
    return translation;
  }

  /// Checks if a translation key exists in the current locale
  bool containsKey(String key) => _localizedStrings.containsKey(key);
}

/// The delegate for loading AppLocalizations
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}