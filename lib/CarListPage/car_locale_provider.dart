/*
 * Student Name: Viet-Quynh Nguyen
 * Lab Professor: Professor Fedor Ilitchev
 * Due Date: 08/04/2025
 * Description: 25S_CST2335_022 Final Project
 */

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

/// Provides localized strings for the Car List Page.
class CarLocaleProvider {
  /// The current locale.
  final Locale locale;

  /// Internal map storing localized key-value string pairs.
  late Map<String, String> _localizedStrings;

  /// Constructor for CarLocaleProvider.
  CarLocaleProvider(this.locale);

  /// The delegate for loading localized data.
  static const LocalizationsDelegate<CarLocaleProvider> delegate = _CarLocaleDelegate();

  /// List of supported locales.
  static const supportedLocales = [
    Locale('en'),
    Locale('vi'),
  ];

  /// Loads the localization file based on the current [locale].
  static Future<CarLocaleProvider> load(Locale locale) async {
    CarLocaleProvider provider = CarLocaleProvider(locale);
    String jsonString = await rootBundle.loadString('assets/lang/CarListPage/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    provider._localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return provider;
  }

  /// Retrieves the localized string for the given [key].
  ///
  /// Returns the key itself if the localized value is not found.
  String get(String key) => _localizedStrings[key] ?? key;
}

/// A delegate for [CarLocaleProvider] to load localizations.
class _CarLocaleDelegate extends LocalizationsDelegate<CarLocaleProvider> {
  /// Const constructor for the delegate.
  const _CarLocaleDelegate();

  /// Checks if the [locale] is supported.
  @override
  bool isSupported(Locale locale) => ['en', 'vi'].contains(locale.languageCode);

  /// Loads the localization for the given [locale].
  @override
  Future<CarLocaleProvider> load(Locale locale) => CarLocaleProvider.load(locale);

  /// Returns false as reloading is not necessary.
  @override
  bool shouldReload(_CarLocaleDelegate old) => false;
}
