import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Provides localized strings for the SalesPage of the application.
///
/// Loads translations from JSON files located in `assets/lang/SalesPage/`
/// based on the user's [locale].
class AppLocalizations {
  /// Creates an instance for the given [locale].
  ///
  /// Initializes an empty [_localizedStrings] map.
  AppLocalizations(this.locale){
    _localizedStrings = <String, String>{ };
  }

  /// Retrieves the current [AppLocalizations] instance from the widget tree.
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// A delegate that loads localization resources for [AppLocalizations].
  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  /// The current locale of the app (e.g., 'en', 'fr').
  final Locale locale;
  /// The map holding all translated key-value string pairs.
  late Map<String, String> _localizedStrings;

  /// Loads the localized strings from the appropriate JSON file.
  ///
  /// This should be called before accessing [translate].
  Future<void> load() async {
    String jsonString = await rootBundle.loadString('assets/lang/SalesPage/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  /// Returns the translated string for the given [key].
  ///
  /// Returns `null` if the key is not found.
  String? translate(String key) {
    return _localizedStrings[key];
  }
}

/// The delegate class for [AppLocalizations].
///
/// Used by the Flutter localization system to load and support translations.
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  /// Returns `true` if the given [locale] is supported.
  ///
  /// Currently supports 'en' (English) and 'fr' (French).
  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr'].contains(locale.languageCode);
  }

  /// Loads and returns an [AppLocalizations] instance for the given [locale].
  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  /// Returns `true` to allow reloading of localizations when dependencies change.
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => true;
}
