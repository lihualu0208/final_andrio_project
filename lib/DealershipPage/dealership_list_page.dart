import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'car_dealership.dart';
import 'dealership_dao.dart';
import 'dealership_repository.dart';
import 'dealership_localizations.dart';
import 'dealership_detail_page.dart';

/// A page that displays and manages a list of car dealerships.
///
/// Includes add/edit/delete functionality, localization support,
/// and a split-view layout for large screens.
class DealershipListPage extends StatefulWidget {
  /// The DAO for performing database operations on dealerships.
  final DealershipDao dealershipDao;
  /// The locale to override localization with.
  final Locale? forcedLocale;
  /// Callback to notify the app of a locale change.
  final void Function(Locale) onLocaleChange;

  const DealershipListPage({
    super.key,
    required this.dealershipDao,
    this.forcedLocale,
    required this.onLocaleChange,
  });

  @override
  State<DealershipListPage> createState() => _DealershipListPageState();
}

class _DealershipListPageState extends State<DealershipListPage> {
  final DealershipRepository _dealershipRepo = DealershipRepository();
  final List<Dealership> _dealerships = [];
  Dealership? _selected;
  Locale? _currentLocale;
  bool _hasLastDealership = false;

  @override
  void initState() {
    super.initState();
    _currentLocale = widget.forcedLocale;
    loadDealerships();
    _checkLastDealership();
  }

  /// Loads all dealerships from the database and sets the current max ID.
  Future<void> loadDealerships() async {
    setState(() {
      _dealerships.clear();
    });

    final dealerships = await widget.dealershipDao.findAllDealerships();
    final maxId = await widget.dealershipDao.findMaxId();

    setState(() {
      _dealerships.addAll(dealerships);
      Dealership.currentId = (maxId ?? 0) + 1;
    });
  }

  /// Checks whether previous dealership data is saved in storage.
  Future<void> _checkLastDealership() async {
    await _dealershipRepo.loadData();
    setState(() {
      _hasLastDealership = _dealershipRepo.name.isNotEmpty;
    });
  }

  /// Opens a dialog to add a new dealership, optionally using the last saved data.
  void _onAddDealership({bool useLast = false}) {
    final name = useLast ? _dealershipRepo.name : '';
    final address = useLast ? _dealershipRepo.address : '';
    final city = useLast ? _dealershipRepo.city : '';
    final postal = useLast ? _dealershipRepo.postalCode : '';

    final controllerName = TextEditingController(text: name);
    final controllerAddress = TextEditingController(text: address);
    final controllerCity = TextEditingController(text: city);
    final controllerPostal = TextEditingController(text: postal);

    showDialog(
      context: context,
      builder: (ctx) {
        return Localizations.override(
          context: ctx,
          locale: widget.forcedLocale,
          delegates: const [
            DealershipLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          child: Builder(
            builder: (context) {
              final dialogLoc = DealershipLocalizations.of(context)!;

              return AlertDialog(
                title: Text(dialogLoc.translate('add_new_dealership') ?? 'Add New Dealership'),
                backgroundColor: const Color(0xFFE4E7ED),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: controllerName,
                        decoration: InputDecoration(
                          labelText: dialogLoc.translate('dealership_name') ?? 'Name',
                        ),
                      ),
                      TextField(
                        controller: controllerAddress,
                        decoration: InputDecoration(
                          labelText: dialogLoc.translate('address') ?? 'Address',
                        ),
                      ),
                      TextField(
                        controller: controllerCity,
                        decoration: InputDecoration(
                          labelText: dialogLoc.translate('city') ?? 'City',
                        ),
                      ),
                      TextField(
                        controller: controllerPostal,
                        decoration: InputDecoration(
                          labelText: dialogLoc.translate('postal_code') ?? 'Postal Code',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(dialogLoc.translate('cancel') ?? 'Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final newDealership = Dealership(
                        id: Dealership.currentId++,
                        name: controllerName.text.trim(),
                        address: controllerAddress.text.trim(),
                        city: controllerCity.text.trim(),
                        postalCode: controllerPostal.text.trim(),
                      );

                      await widget.dealershipDao.insertDealership(newDealership);
                      await _dealershipRepo.saveDealershipData(
                        name: newDealership.name,
                        address: newDealership.address,
                        city: newDealership.city,
                        postalCode: newDealership.postalCode,
                      );

                      Navigator.pop(ctx);
                      await loadDealerships();
                      await _checkLastDealership();
                    },
                    child: Text(dialogLoc.translate('add') ?? 'Add'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  /// Displays a help dialog with usage instructions.
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Localizations.override(
          context: ctx,
          locale: _currentLocale,
          delegates: const [
            DealershipLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          child: Builder(
            builder: (context) {
              final loc = DealershipLocalizations.of(context)!;
              return AlertDialog(
                title: Text(loc.translate('instructions') ?? 'Instructions'),
                backgroundColor: const Color(0xFFE4E7ED),
                content: Text(loc.translate('instructions_content') ?? 'Tap a dealership to edit, or add a new one with +.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(loc.translate('ok') ?? 'OK'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  /// Displays a dialog for selecting the app language.
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Localizations.override(
          context: ctx,
          locale: _currentLocale,
          delegates: const [
            DealershipLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          child: Builder(
            builder: (context) {
              final loc = DealershipLocalizations.of(context)!;
              return AlertDialog(
                title: Text(loc.translate('change_language') ?? 'Change Language'),
                backgroundColor: const Color(0xFFE4E7ED),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('English'),
                      onTap: () {
                        setState(() {
                          _currentLocale = const Locale('en');
                        });
                        widget.onLocaleChange(_currentLocale!);
                        Navigator.pop(ctx);
                      },
                    ),
                    ListTile(
                      title: const Text('Deutsch'),
                      onTap: () {
                        setState(() {
                          _currentLocale = const Locale('de');
                        });
                        widget.onLocaleChange(_currentLocale!);
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Builds the UI of the dealership list page, including localization.
  @override
  Widget build(BuildContext context) {
    final locale = _currentLocale ?? widget.forcedLocale ?? Localizations.localeOf(context);
    return Localizations.override(
      context: context,
      locale: locale,
      delegates: const [
        DealershipLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: Builder(builder: (context) {
        final loc = DealershipLocalizations.of(context)!;

        return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFDFDFE4),
              title: Text(
                loc.translate('dealership_management') ?? 'Dealership Management',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(icon: const Icon(Icons.help), onPressed: _showHelpDialog),
                IconButton(icon: const Icon(Icons.language), onPressed: _showLanguageDialog),
              ],
            ),
          body: Row(
            children: [
              // Left panel
              Container(
                width: 400,
                color: const Color(0xFFF3F6FA),
                child: Column(
                  children: [
                    Expanded(
                      child: _dealerships.isEmpty
                          ? Center(
                        child: Text(
                          loc.translate('no_dealerships'),
                          textAlign: TextAlign.center,
                        ),
                      )
                          : ListView.builder(
                        itemCount: _dealerships.length,
                        itemBuilder: (ctx, i) {
                          final d = _dealerships[i];
                          return Card(
                            child: ListTile(
                              title: Text(d.name),
                              subtitle: Text('${d.address}\n${d.city}, ${d.postalCode}'),
                              isThreeLine: true,
                              selected: _selected?.id == d.id,
                              onTap: () {
                                setState(() {
                                  _selected = d;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton.small(
                          backgroundColor: const Color(0xFFD8E7FF),
                          onPressed: _onAddDealership,
                          tooltip: loc.translate('add_dealership') ?? 'Add Dealership',
                          foregroundColor: Colors.black,
                          child: const Icon(Icons.add),
                        ),
                        if (_hasLastDealership) ...[
                          const SizedBox(width: 10),
                          FloatingActionButton.small(
                            backgroundColor: const Color(0xFFD8E7FF),
                            foregroundColor: Colors.black,
                            onPressed: () => _onAddDealership(useLast: true),
                            tooltip: loc.translate('use_last_data') ?? 'Use Last',
                            child: const Icon(Icons.history),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Right panel
              Expanded(
                child: Container(
                  color: const Color(0xFFE4E7ED), // Light brown background
                  child: _selected == null
                      ? Center(
                    child: Text(
                      loc.translate('select_to_view_details') ??
                          "Select a dealership to view details",
                      style: const TextStyle(color: Colors.black),
                    ),
                  )
                      : DealershipDetailPage(
                    dealership: _selected!,
                    onUpdate: (updated) async {
                      await widget.dealershipDao.updateDealership(updated);
                      await loadDealerships();
                      setState(() => _selected = updated);
                    },
                    onDelete: (deleted) async {
                      setState(() => _selected = null);
                      await widget.dealershipDao.deleteDealership(deleted);
                      await loadDealerships();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
