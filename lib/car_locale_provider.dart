import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class CarLocaleProvider {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  CarLocaleProvider(this.locale);

  static const LocalizationsDelegate<CarLocaleProvider> delegate = _CarLocaleDelegate();

  static const supportedLocales = [
    Locale('en'),
    Locale('vi'),
  ];

  static Future<CarLocaleProvider> load(Locale locale) async {
    CarLocaleProvider provider = CarLocaleProvider(locale);
    String jsonString = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    provider._localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return provider;
  }

  String get(String key) => _localizedStrings[key] ?? key;
}

class _CarLocaleDelegate extends LocalizationsDelegate<CarLocaleProvider> {
  const _CarLocaleDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'vi'].contains(locale.languageCode);
  @override
  Future<CarLocaleProvider> load(Locale locale) => CarLocaleProvider.load(locale);
  @override
  bool shouldReload(_CarLocaleDelegate old) => false;
}
