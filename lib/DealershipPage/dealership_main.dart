import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_database.dart';
import 'dealership_dao.dart';
import 'dealership_list_page.dart';
import 'app_localizations.dart';

/**
 * Main entry point for the Car Dealership Management application.
 * Initializes the database and runs the app.
 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase
      .databaseBuilder('dealership_database.db')
      .build();

  final dealershipDao = database.dealershipDao;

  runApp(MyApp(dealershipDao: dealershipDao));
}

/**
 * The root widget of the application.
 * Manages language localization and provides the main app structure.
 */
class MyApp extends StatefulWidget {
  final DealershipDao dealershipDao;

  const MyApp({super.key, required this.dealershipDao});

  /// Changes the app's locale/language
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLanguage(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  /// Updates the current locale and triggers a rebuild
  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Dealership Management',
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: DealershipMasterDetailPage(dealershipDao: widget.dealershipDao),
    );
  }
}

/**
 * A page that displays dealerships in a master-detail layout on large screens
 * or a list-only layout on small screens.
 */
class DealershipMasterDetailPage extends StatelessWidget {
  final DealershipDao dealershipDao;

  const DealershipMasterDetailPage({super.key, required this.dealershipDao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Tablet/Desktop layout - side by side
            return Row(
              children: [
                Flexible(
                  flex: 1,
                  child: DealershipListPage(
                    dealershipDao: dealershipDao,
                    isMaster: true,
                  ),
                ),
                const VerticalDivider(width: 1),
                Flexible(
                  flex: 2,
                  child: Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.translate('select_to_view_details'),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Phone layout - full screen
            return DealershipListPage(
              dealershipDao: dealershipDao,
              isMaster: false,
            );
          }
        },
      ),
    );
  }
}