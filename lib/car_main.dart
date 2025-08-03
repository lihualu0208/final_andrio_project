/*
 * Student Name: Viet-Quynh Nguyen
 * Lab Professor: Professor Fedor Ilitchev
 * Due Date: 08/04/2025
 * Description: 25S_CST2335_022 Final Project
 */

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'car.dart';
import 'car_dao.dart';
import 'car_database.dart';
import 'car_repository.dart';
import 'car_list_page.dart';
import 'car_locale_provider.dart';

/// The main entry point of the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes the local Floor database and repository.
  final database = await $FloorCarDatabase.databaseBuilder('car_database.db').build();
  final repository = CarRepository(database.carDao);

  // Runs the app with the initialized repository.
  runApp(CarApp(repository: repository));
}

/// The root widget of the application.
class CarApp extends StatefulWidget {
  /// The repository used to access the car database.
  final CarRepository repository;

  /// Creates a [CarApp] with a given [repository].
  const CarApp({Key? key, required this.repository}) : super(key: key);

  /// Allows changing the locale from any widget via context.
  static void setLocale(BuildContext context, Locale newLocale) {
    final state = context.findAncestorStateOfType<_CarAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<CarApp> createState() => _CarAppState();
}

/// The state class for [CarApp], handling locale changes.
class _CarAppState extends State<CarApp> {
  /// Current selected locale, default is English.
  Locale _locale = const Locale('en');

  /// Updates the current locale and rebuilds the UI.
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car List',
      locale: _locale,
      supportedLocales: CarLocaleProvider.supportedLocales,
      localizationsDelegates: const [
        CarLocaleProvider.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supported in supportedLocales) {
          if (supported.languageCode == locale?.languageCode) {
            return supported;
          }
        }
        return supportedLocales.first;
      },
      home: CarListPage(
        repository: widget.repository,
        onLocaleChange: setLocale,
      ),
    );
  }
}
