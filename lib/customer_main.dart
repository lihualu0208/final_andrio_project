/// customer_main.dart
/// The main entry point for the Customer Management application.
///
/// Initializes the database, sets up localization, and configures the
/// MaterialApp with the appropriate providers and settings.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Essential import
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart'; // For SynchronousFuture
import 'customer_app_database.dart';
import 'customer_dao.dart';
import 'customer_list_page.dart';
import 'customr_AppLocalizations.dart';
import 'customer_locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  final database = await $FloorAppDatabase
      .databaseBuilder('customer_database.db')
      .build();
  final customerDao = database.customerDao;

  // Initialize locale provider
  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  runApp(
    ChangeNotifierProvider.value(
      value: localeProvider,
      child: MyApp(customerDao: customerDao),
    ),
  );
}

/// The root widget of the Customer Management application.
///
/// Configures the MaterialApp with localization support and theme settings,
/// and sets the CustomerListPage as the home screen.

class MyApp extends StatelessWidget {
  /// The CustomerDao instance for database operations.
  final CustomerDao customerDao;
  /// Creates the root application widget.
  const MyApp({super.key, required this.customerDao});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          title: 'Customer Management',
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate, // Your custom delegate
            GlobalMaterialLocalizations.delegate, // Required for Material widgets
            GlobalWidgetsLocalizations.delegate,  // Required for default text direction
            GlobalCupertinoLocalizations.delegate, // Required for Cupertino widgets
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: CustomerListPage(customerDao: customerDao),
        );
      },
    );
  }
}