import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'car.dart';
import 'car_dao.dart';
import 'car_database.dart';
import 'car_repository.dart';
import 'car_list_page.dart';
import 'car_locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorCarDatabase.databaseBuilder('car_database.db').build();
  final repository = CarRepository(database.carDao);
  runApp(CarApp(repository: repository));
}

class CarApp extends StatefulWidget {
  final CarRepository repository;
  const CarApp({Key? key, required this.repository}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    final state = context.findAncestorStateOfType<_CarAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<CarApp> createState() => _CarAppState();
}

class _CarAppState extends State<CarApp> {
  Locale _locale = const Locale('en');

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
