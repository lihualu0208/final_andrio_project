import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customr_AppLocalizations.dart';

/// A provider that manages the user's selected locale for the customer module.
///
/// It uses [SharedPreferences] to persist the selected locale across app restarts,
/// and notifies listeners when the locale changes.
class CustomerLocaleProvider with ChangeNotifier {
  Locale? _locale;
  final String _prefKey = 'languageCode';

  /// Gets the currently selected locale, or null if not set.
  Locale? get locale => _locale;

  /// Loads the saved locale from shared preferences, if available.
  ///
  /// If the stored language code is valid, it updates [_locale] and
  /// notifies listeners. Falls back to `'en'` if loading fails.
  Future<void> loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_prefKey);

      if (languageCode != null && languageCode.isNotEmpty) {
        _locale = Locale(languageCode);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading locale: $e');
      // Fallback to default locale if loading fails
      _locale = const Locale('en');
      notifyListeners();
    }
  }

  /// Sets a new locale and persists it using shared preferences.
  ///
  /// Returns `true` if successful, `false` if the locale is not supported
  /// or an error occurs.
  Future<bool> setLocale(Locale locale) async {
    try {
      if (!CustomrApplocalizations.supportedLocales.contains(locale)) {
        return false;
      }

      _locale = locale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, locale.languageCode);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error setting locale: $e');
      return false;
    }
  }

  /// Clears the saved locale from preferences and resets [_locale] to null.
  ///
  /// Returns `true` if successful, or `false` if an error occurs.
  Future<bool> clearLocale() async {
    try {
      _locale = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefKey);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error clearing locale: $e');
      return false;
    }
  }
}