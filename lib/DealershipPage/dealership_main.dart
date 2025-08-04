import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dealership_database.dart';
import 'dealership_dao.dart';
import 'dealership_list_page.dart';
import 'dealership_localizations.dart';
import 'dealership_detail_page.dart';
import 'car_dealership.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase
      .databaseBuilder('dealership_database.db')
      .build();

  final dealershipDao = database.dealershipDao;

  runApp(MyApp(dealershipDao: dealershipDao));
}

class MyApp extends StatefulWidget {
  final DealershipDao dealershipDao;

  const MyApp({super.key, required this.dealershipDao});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLanguage(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

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

class DealershipMasterDetailPage extends StatefulWidget {
  final DealershipDao dealershipDao;

  const DealershipMasterDetailPage({super.key, required this.dealershipDao});

  @override
  State<DealershipMasterDetailPage> createState() => _DealershipMasterDetailPageState();
}

class _DealershipMasterDetailPageState extends State<DealershipMasterDetailPage> {
  Dealership? _selectedDealership;
  final GlobalKey<DealershipListPageState> _dealershipListPageKey = GlobalKey();

  void _handleDealershipSelected(Dealership dealership) {
    setState(() {
      _selectedDealership = dealership;
    });
  }

  void _handleUpdate(Dealership updatedDealership) async {
    await widget.dealershipDao.updateDealership(updatedDealership);
    await _dealershipListPageKey.currentState?.loadDealerships();
    setState(() {
      _selectedDealership = updatedDealership;
    });
  }


  void _handleDelete(Dealership dealership) async {
    await widget.dealershipDao.deleteDealership(dealership);
    await _dealershipListPageKey.currentState?.loadDealerships();


    final dealerships = await widget.dealershipDao.findAllDealerships();

    setState(() {
      if (dealerships.isEmpty) {
        _selectedDealership = null;
      } else if (_selectedDealership?.id == dealership.id) {
        _selectedDealership = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Row(
              children: [
                Flexible(
                  flex: 1,
                  child: DealershipListPage(
                    key: _dealershipListPageKey,
                    dealershipDao: widget.dealershipDao,
                    isMaster: true,
                    onDealershipSelected: _handleDealershipSelected,
                    selectedDealership: _selectedDealership,
                  ),
                ),
                const VerticalDivider(width: 1),
                Flexible(
                  flex: 2,
                  child: Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: _selectedDealership != null
                        ? DealershipDetailPage(
                      dealership: _selectedDealership!,
                      onUpdate: _handleUpdate,
                      onDelete: _handleDelete,
                    )
                        : Center(
                      child: Text(
                        AppLocalizations.of(context)!.translate('select_to_view_details'),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return DealershipListPage(
              dealershipDao: widget.dealershipDao,
              isMaster: false,
            );
          }
        },
      ),
    );
  }
}
