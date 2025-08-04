/// customr_AppLocalizations.dart
/// Provides localized strings for the Customer Management application.
///
/// Supports multiple languages using JSON files for translations.
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// A class that loads and provides localized strings for the app.
///
/// It reads JSON translation files from `assets/lang/CustomerListPage/`
/// based on the current [locale], and exposes the translated strings via [translate].
class CustomrApplocalizations {
  /// The current locale used for translations.
  final Locale locale;
  /// A map of localized key-value string pairs.
  late Map<String, String> _localizedStrings;

  /// Creates an instance of [CustomrApplocalizations] for the specified [locale].
  CustomrApplocalizations(this.locale);

  /// Provides access to the [CustomrApplocalizations] instance from the widget tree.
  static CustomrApplocalizations? of(BuildContext context) {
    return Localizations.of<CustomrApplocalizations>(context, CustomrApplocalizations);
  }

  /// A delegate that allows Flutter to load the localization data.
  static const LocalizationsDelegate<CustomrApplocalizations> delegate =
  _CustomrApplocalizationsDelegate();

  /// Loads the JSON translation file for the current locale.
  ///
  /// Returns `true` if loading was successful, otherwise `false`.
  Future<bool> load() async {
    try {
      String jsonString = await rootBundle.loadString(
        'assets/lang/CustomerListPage/${locale.languageCode}.json',
      );
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
      return true;
    } catch (e) {
      print("Error loading translations: $e");
      _localizedStrings = {};
      return false;
    }
  }

  /// Returns the translated string for the given [key].
  ///
  /// If the key is not found in the loaded translations, returns the key itself.
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  static List<Locale> get supportedLocales {
    return const [
      Locale('en'),
      Locale('zh'),
    ];
  }
}

/// A [LocalizationsDelegate] that loads [CustomrApplocalizations] for a given locale.
class _CustomrApplocalizationsDelegate
    extends LocalizationsDelegate<CustomrApplocalizations> {
  const _CustomrApplocalizationsDelegate();

  /// Whether the delegate supports the specified [locale].
  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  /// Loads the localization resources for the specified [locale].
  @override
  Future<CustomrApplocalizations> load(Locale locale) async {
    CustomrApplocalizations localizations = CustomrApplocalizations(locale);
    await localizations.load();
    return localizations;
  }

  /// Whether the delegate should reload when the old delegate changes.
  ///
  /// This implementation always returns false for performance reasons.
  @override
  bool shouldReload(_CustomrApplocalizationsDelegate old) => false;
}