import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
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