/// customer_locale_provider.dart
/// A ChangeNotifier class that manages the application's locale settings.
///
/// This class handles language preference persistence using SharedPreferences
/// and notifies listeners when the locale changes.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customr_AppLocalizations.dart';

class LocaleProvider with ChangeNotifier {

  Locale? _locale;
  final String _prefKey = 'languageCode';
  /// The current locale of the application
  Locale? get locale => _locale;

  /// Loads the saved locale preference from SharedPreferences.
  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_prefKey);
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  /// Sets a new locale for the application and saves it to SharedPreferences.
  ///
  /// Only changes the locale if it's one of the supported locales.
  Future<void> setLocale(Locale locale) async {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;

    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
    notifyListeners();
  }
  /// Clears the saved locale preference.
  Future<void> clearLocale() async {
    _locale = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
    notifyListeners();
  }
}