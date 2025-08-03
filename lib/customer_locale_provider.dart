// customer_locale_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customr_AppLocalizations.dart'; // Note: Fixed filename casing to match your actual file

class LocaleProvider with ChangeNotifier {
  Locale? _locale;
  final String _prefKey = 'languageCode';

  Locale? get locale => _locale;

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

  Future<bool> setLocale(Locale locale) async {
    try {
      if (!AppLocalizations.supportedLocales.contains(locale)) {
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