/// Main entry point for the Customer Management application.
///
/// Initializes the application database and localization settings before
/// running the app. Uses changenotifierprovider  to provide the localprovider
/// throughout the widget tree.
///
/// The initialization process:
/// 1. Ensures Flutter binding is initialized
/// 2. Builds the application database using Floor
/// 3. Loads the saved locale preferences
/// 4. Runs the app with the initialized dependencies
///

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'customer_app_database.dart';
import 'customer_dao.dart';
import 'customer_list_page.dart';
import 'customr_AppLocalizations.dart';
import 'customer_locale_provider.dart';

void main() async {
  /// Ensure Flutter binding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize the application database using Floor ORM
  final database = await $FloorAppDatabase
      .databaseBuilder('customer_database.db')
      .build();
  final customerDao = database.customerDao;

  /// Initialize and load the locale preferences
  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();
  /// Run the application with the initialized dependencies
  runApp(
    ChangeNotifierProvider.value(
      value: localeProvider,
      child: MyApp(customerDao: customerDao),
    ),
  );
}

/// The root widget of the Customer Management application.
///
/// Configures the MaterialApp with:
/// - Localization support
/// - Theme settings
/// - Provider state management
/// - Database access
///
/// Uses [Consumer] to rebuild when locale changes occur.
///
class MyApp extends StatelessWidget {
  /// The [CustomerDao] instance for database operations.
  final CustomerDao customerDao;

  /// Creates a [MyApp] widget with the given [customerDao].
  ///
  /// The [customerDao] must not be null as it provides database access
  /// throughout the application.

  const MyApp({super.key, required this.customerDao});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Customer Management',
          /// Localization configuration
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,

          /// Theme configuration
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          // The home page of the application
          home: CustomerListPage(customerDao: customerDao),
        );
      },
    );
  }
}

/// Initializes the application dependencies for testing or deferred loading.
///
/// Performs the same initialization as [main] but returns a [Future<Widget>]
/// instead of running the app directly. This is useful for:
/// - Integration testing
/// - Deferred app loading
/// - Splash screen scenarios
///
/// Returns a [ChangeNotifierProvider] widget with initialized dependencies.

Future<Widget> initializeCustomerApp() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
 // Initialize database

  final database = await $FloorAppDatabase
      .databaseBuilder('customer_database.db')
      .build();
  // Initialize and load locale preferences

  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  // Return the provider widget with initialized dependencies

  return ChangeNotifierProvider.value(
    value: localeProvider,
    child: MyApp(customerDao: database.customerDao),
  );
}