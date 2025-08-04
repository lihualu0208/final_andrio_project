import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

///SalesPage
import 'SalesPage/AppLocalizations.dart';
import 'SalesPage/SalesPage.dart';

//CarListPage
import 'CarListPage/car_repository.dart';
import 'CarListPage/car_list_page.dart';
import 'CarListPage/car_database.dart';
import 'CarListPage/car_locale_provider.dart';

//DealershipPage
import 'DealershipPage/dealership_list_page.dart';
import 'DealershipPage/dealership_database.dart';
import 'DealershipPage/dealership_localizations.dart';
import 'DealershipPage/dealership_dao.dart';
import 'DealershipPage/dealership_detail_page.dart';

//CustomerListPage
import 'CustomerListPage/customer_app_database.dart';
import 'CustomerListPage/customer_dao.dart';
import 'CustomerListPage/customer_list_page.dart';
import 'CustomerListPage/customr_AppLocalizations.dart';
import 'CustomerListPage/customer_locale_provider.dart';
import 'CustomerListPage/customer_repository.dart';

/// Entry point of the Group Project App.
///
/// Initializes all Floor databases (Car, Dealership, Customer),
/// creates corresponding repositories/DAOs, and runs the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize both databases
  final carDatabase = await $FloorCarDatabase.databaseBuilder('car_database.db').build();
  final dealershipDatabase = await $FloorDealershipDatabase.databaseBuilder('dealership_database.db').build();
  final customerDatabase = await $FloorCustomerAppDatabase.databaseBuilder('customer_app_database.db').build();


  final customerRepository = CustomerRepository(customerDatabase.customerDao);
  final carRepository = CarRepository(carDatabase.carDao);
  final dealershipDao = dealershipDatabase.dealershipDao;

  runApp(MyApp(
    carRepository: carRepository,
    dealershipDao: dealershipDao,
    customerRepository: customerRepository,
  ));
}

/// The root widget of the app.
///
/// Sets up localization, theming, and provides access to repositories and DAOs
/// needed by feature pages like Car, Dealership, Sales, and Customer.
class MyApp extends StatefulWidget {
  final CarRepository carRepository;
  final DealershipDao dealershipDao;
  final CustomerRepository customerRepository;

  const MyApp({
    super.key,
    required this.carRepository,
    required this.dealershipDao,
    required this.customerRepository,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

/// State class for [MyApp].
///
/// Manages the current app-wide locale and provides locale switching logic.
class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale("en");
  Locale _dealershipLocale = const Locale('en');


  void _changeLanguage(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale("en"),
        Locale("fr"),
        Locale("vi"),
        Locale("de"),
        Locale("zh"),
      ],
      localizationsDelegates: const [
        CarLocaleProvider.delegate,
        AppLocalizations.delegate,
        DealershipLocalizations.delegate,
        CustomrApplocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      debugShowCheckedModeBanner: false,
      localeResolutionCallback: (locale, supportedLocales) {
        return locale; // ensures proper matching
      },
      title: 'Group Project App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPage(
        onLocaleChange: _changeLanguage,
        carRepository: widget.carRepository,
        dealershipDao: widget.dealershipDao,
        dealershipLocale: _dealershipLocale,
        customerRepository: widget.customerRepository,
        onDealershipLocaleChange: (newLocale) {
          setState(() {
            _dealershipLocale = newLocale;
          });
        },
      ),
    );
  }
}

/// A wrapper for the Customer List Page with independent locale management.
///
/// Receives initial locale and updates it internally without affecting the app-wide locale.
class CustomerPageWrapper extends StatefulWidget {
  final Locale initialLocale;
  final CustomerRepository customerRepository;
  final void Function(Locale) onLocaleChange;

  const CustomerPageWrapper({
    super.key,
    required this.initialLocale,
    required this.customerRepository,
    required this.onLocaleChange,
  });

  @override
  State<CustomerPageWrapper> createState() => _CustomerPageWrapperState();
}

class _CustomerPageWrapperState extends State<CustomerPageWrapper> {
  late Locale _currentLocale;

  @override
  void initState() {
    super.initState();
    _currentLocale = _sanitizeLocale(widget.initialLocale);
  }

  void _updateLocale(Locale newLocale) {
    final sanitized = _sanitizeLocale(newLocale);
    setState(() {
      _currentLocale = sanitized;
    });
    widget.onLocaleChange(sanitized);
  }

  Locale _sanitizeLocale(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode)
        ? locale
        : const Locale('en');
  }

  @override
  Widget build(BuildContext context) {
    return CustomerListPage(
      forcedLocale: _currentLocale,
      repository: widget.customerRepository,
      onLocaleChange: _updateLocale,
    );
  }
}

/// A wrapper for the Dealership Page with independent locale handling.
///
/// Passes DAO and locale to [DealershipListPage].
class DealershipPageWrapper extends StatefulWidget {
  final Locale initialLocale;
  final DealershipDao dealershipDao;
  final void Function(Locale)? onLocaleChange;

  const DealershipPageWrapper({
    super.key,
    required this.initialLocale,
    required this.dealershipDao,
    this.onLocaleChange,
  });

  @override
  State<DealershipPageWrapper> createState() => _DealershipPageWrapperState();
}

class _DealershipPageWrapperState extends State<DealershipPageWrapper> {
  late Locale _currentLocale;

  @override
  void initState() {
    super.initState();
    _currentLocale = widget.initialLocale;
  }

  void _updateLocale(Locale newLocale) {
    setState(() {
      _currentLocale = newLocale;
    });
    widget.onLocaleChange?.call(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return DealershipListPage(
      dealershipDao: widget.dealershipDao,
      forcedLocale: _currentLocale,
      onLocaleChange: _updateLocale,
    );
  }
}


/// A wrapper for the Sales Page that maintains its own locale state.
///
/// Handles internal switching between English and French and notifies the parent.
class SalesPageWrapper extends StatefulWidget {
  final Locale initialLocale;
  final void Function(Locale) onLocaleChange;

  const SalesPageWrapper({
    super.key,
    required this.initialLocale,
    required this.onLocaleChange,
  });

  @override
  State<SalesPageWrapper> createState() => _SalesPageWrapperState();
}

class _SalesPageWrapperState extends State<SalesPageWrapper> {
  late Locale _currentLocale;

  @override
  void initState() {
    super.initState();
    _currentLocale = widget.initialLocale;
  }

  void _updateLocale(Locale newLocale) {
    setState(() {
      _currentLocale = newLocale;
    });
    widget.onLocaleChange(newLocale); // Notify MainPage
  }

  @override
  Widget build(BuildContext context) {
    return SalesPage(
      forcedLocale: _currentLocale,
      onLocaleChange: _updateLocale,
    );
  }
}

/// The main landing screen of the app with navigation to feature pages.
///
/// Contains buttons to navigate to:
/// - Customer Page
/// - Car Page
/// - Sales Page
/// - Dealership Page
///
/// Also provides a help dialog in the AppBar.
class MainPage extends StatefulWidget {
  final void Function(Locale) onLocaleChange;
  final void Function(Locale) onDealershipLocaleChange;
  final Locale dealershipLocale;
  final CarRepository carRepository;
  final DealershipDao dealershipDao;
  final CustomerRepository customerRepository;


  const MainPage({
    super.key,
    required this.onLocaleChange,
    required this.carRepository,
    required this.dealershipDao,
    required this.dealershipLocale,
    required this.onDealershipLocaleChange,
    required this.customerRepository,

  });

  @override
  State<MainPage> createState() => _MainPageState();
}

/// State class for [MainPage].
///
/// Tracks and manages separate locales for Sales and Customer modules.
class _MainPageState extends State<MainPage> {
  Locale _salesLocale = const Locale("en");
  Locale _customerLocale = const Locale("en");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDFDFE4),
        title: const Text('Group Project App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('App Instructions'),
                  backgroundColor: const Color(0xFFE4E7ED),
                  content: const Text(
                    'Welcome to our group project app! Select one of the features below to get started.\n\n'
                        'Customer Page: Manage customer records\n'
                        'Car Page: Manage car inventory\n'
                        'Dealership Page: Manage dealership locations\n'
                        'Sales Page: Track car sales',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerPageWrapper(
                      initialLocale: _customerLocale,
                      customerRepository: widget.customerRepository,
                      onLocaleChange: (newLocale) {
                        setState(() {
                          _customerLocale = newLocale;
                        });
                      },
                    ),
                  ),
                );
              },
              child: const Text('Customer List Page'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarListPage(
                      repository: widget.carRepository,
                      onLocaleChange: widget.onLocaleChange,
                    ),
                  ),
                );
              },
              child: const Text('Car List Page'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SalesPageWrapper(
                      initialLocale: _salesLocale,
                      onLocaleChange: (newLocale) {
                        setState(() {
                          _salesLocale = newLocale;
                        });
                      },
                    ),
                  ),
                );
              },
              child: const Text('Sales List Page'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DealershipPageWrapper(
                      initialLocale: widget.dealershipLocale,
                      dealershipDao: widget.dealershipDao,
                      onLocaleChange: widget.onDealershipLocaleChange,
                    ),
                  ),
                );
              },
              child: const Text('Dealership Page'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
