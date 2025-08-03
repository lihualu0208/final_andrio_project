
/// Manages application locale settings with encrypted persistent storage.
///
/// This ChangeNotifier implementation handles:
/// - Loading and saving the user's language preference
/// - Encrypting stored preferences for security
/// - Providing locale information to the application
/// - Supporting locale change notifications
///
/// Uses [EncryptedSharedPreferences] to securely store the language preference.

import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'customr_AppLocalizations.dart'; // Note: Fixed filename casing to match your actual file

/// Provides localized settings management with encrypted storage.
///
/// Notifies listeners when the locale changes to allow widgets to rebuild.
/// All storage operations use encryption for security.
class LocaleProvider with ChangeNotifier {
  /// The current locale, or null if using system default
  Locale? _locale;

  /// Key used for storing the language preference in encrypted storage
  final String _prefKey = 'languageCode';

  /// Encrypted storage instance for language preferences
  late EncryptedSharedPreferences _encryptedPrefs;

  /// Creates a new LocaleProvider with initialized encrypted storage.
  LocaleProvider() {
    _encryptedPrefs = EncryptedSharedPreferences();
  }

  /// Gets the current locale setting.
  ///
  /// Returns null if using system default language.
  Locale? get locale => _locale;

  /// Loads the saved locale from encrypted storage.
  ///
  /// If loading fails, falls back to English ('en') locale.
  /// Notifies listeners after loading completes.
  Future<void> loadLocale() async {
    try {
      // Initialize encrypted preferences if not already done
      final languageCode = await _encryptedPrefs.getString(_prefKey);

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

  /// Changes the application locale and saves it to encrypted storage.
  ///
  /// [locale]: The new locale to set
  /// Returns true if successful, false if locale is not supported or saving fails
  Future<bool> setLocale(Locale locale) async {
    try {
      if (!AppLocalizations.supportedLocales.contains(locale)) {
        return false;
      }

      _locale = locale;
      await _encryptedPrefs.setString(_prefKey, locale.languageCode);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error setting locale: $e');
      return false;
    }
  }

  /// Clears the saved locale preference and resets to system default.
  ///
  /// Returns true if successful, false if clearing fails
  Future<bool> clearLocale() async {
    try {
      _locale = null;
      await _encryptedPrefs.remove(_prefKey);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error clearing locale: $e');
      return false;
    }
  }
}