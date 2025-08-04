/**
 * Provides internationalization support for the app.
 * Loads translations from JSON files based on the current locale.
 */
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Handles loading and accessing localized strings
class DealershipLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  DealershipLocalizations(this.locale);

  /// Retrieves the AppLocalizations instance for the current context
  static DealershipLocalizations? of(BuildContext context) {
    return Localizations.of<DealershipLocalizations>(context, DealershipLocalizations);
  }

  /// The delegate for this localization class
  static const LocalizationsDelegate<DealershipLocalizations> delegate =
  _DealershipLocalizationsDelegate();

  /// Loads translations from JSON file for the current locale
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
   * Optionally replaces placeholders with provided parameters.
   */
  String translate(String key, {Map<String, String> params = const {}}) {
    var translation = _localizedStrings[key] ?? key;
    params.forEach((paramKey, paramValue) {
      translation = translation.replaceAll('{$paramKey}', paramValue);
    });
    return translation;
  }

  /// Checks if a translation key exists
  bool containsKey(String key) => _localizedStrings.containsKey(key);
}

/// The delegate for loading AppLocalizations
class _DealershipLocalizationsDelegate
    extends LocalizationsDelegate<DealershipLocalizations> {
  const _DealershipLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);


  @override
  Future<DealershipLocalizations> load(Locale locale) async {
    final localizations = DealershipLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_DealershipLocalizationsDelegate old) => false;
}