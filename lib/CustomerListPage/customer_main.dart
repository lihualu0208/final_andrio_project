import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'customer_app_database.dart';
import 'customer_dao.dart';
import 'customer_list_page.dart';
import 'customr_AppLocalizations.dart';
import 'customer_locale_provider.dart';

/// The main entry point of the Customer app.
///
/// Initializes the database and locale preferences,
/// then runs the [MyApp] widget wrapped with [ChangeNotifierProvider].
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

/// Root widget of the Customer Management app.
///
/// Builds a [MaterialApp] with localization and theme settings,
/// and injects the customer list screen as the home widget.
class MyApp extends StatelessWidget {
  final CustomerDao customerDao;

  const MyApp({super.key, required this.customerDao});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Customer Management',
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
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

/// Initializes and returns the [MyApp] widget with providers and database.
///
/// This function is useful for modular apps or when this module is integrated
/// into a larger Flutter project.
Future<Widget> initializeCustomerApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase
      .databaseBuilder('customer_database.db')
      .build();
  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  return ChangeNotifierProvider.value(
    value: localeProvider,
    child: MyApp(customerDao: database.customerDao),
  );
}