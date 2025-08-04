/**
 * Displays a list of dealerships and provides functionality to add, view, and manage them.
 */
import 'package:flutter/material.dart';
import 'car_dealership.dart';
import 'dealership_dao.dart';
import 'dealership_repository.dart';
import 'dealership_localizations.dart';
import 'dealership_main.dart';
import 'dealership_detail_page.dart';

/// A page that displays a list of dealerships and allows management operations
class DealershipListPage extends StatefulWidget {
  /// Data access object for dealership operations
  final DealershipDao dealershipDao;

  /// Whether this page is in master-detail mode
  final bool isMaster;

  /// Callback when a dealership is selected (used in master-detail mode)
  final Function(Dealership)? onDealershipSelected;

  /// The currently selected dealership (used in master-detail mode)
  final Dealership? selectedDealership;

  /// Creates a dealership list page with the required DAO
  const DealershipListPage({
    super.key,
    required this.dealershipDao,
    this.isMaster = false,
    this.onDealershipSelected,
    this.selectedDealership,
  });

  @override
  State<DealershipListPage> createState() => DealershipListPageState();
}

/// State for the dealership list page, manages dealership data and UI
class DealershipListPageState extends State<DealershipListPage> {
  /// Repository for managing last used dealership data
  final DealershipRepository _dealershipRepo = DealershipRepository();

  /// List of dealerships to display
  final List<Dealership> _dealerships = [];

  /// Whether there is last used dealership data available
  bool _hasLastDealership = false;

  /// Controller for dealership name input
  late TextEditingController _nameController;

  /// Controller for dealership address input
  late TextEditingController _addressController;

  /// Controller for dealership city input
  late TextEditingController _cityController;

  /// Controller for dealership postal code input
  late TextEditingController _postalCodeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _postalCodeController = TextEditingController();
    loadDealerships();
    _checkLastDealership();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  /// Loads all dealerships from the database and updates the list
  Future<void> loadDealerships() async {
    final dealerships = await widget.dealershipDao.findAllDealerships();
    setState(() {
      _dealerships.clear();
      _dealerships.addAll(dealerships);
    });

    final maxId = await widget.dealershipDao.findMaxId();
    Dealership.currentId = (maxId ?? 0) + 1;
  }

  /// Checks if there is last used dealership data available
  Future<void> _checkLastDealership() async {
    await _dealershipRepo.loadData();
    setState(() {
      _hasLastDealership =
          _dealershipRepo.name.isNotEmpty && _dealershipRepo.address.isNotEmpty;
    });
  }

  /// Shows a dialog for adding a new dealership
  void _showAddDealershipDialog({bool useLastDealership = false}) {
    _nameController.clear();
    _addressController.clear();
    _cityController.clear();
    _postalCodeController.clear();

    if (useLastDealership && _hasLastDealership) {
      _nameController.text = _dealershipRepo.name;
      _addressController.text = _dealershipRepo.address;
      _cityController.text = _dealershipRepo.city;
      _postalCodeController.text = _dealershipRepo.postalCode;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!
            .translate('add_new_dealership')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!
                      .translate('dealership_name'),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText:
                  AppLocalizations.of(context)!.translate('address'),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('city'),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _postalCodeController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!
                      .translate('postal_code'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = _nameController.text.trim();
              final address = _addressController.text.trim();
              final city = _cityController.text.trim();
              final postalCode = _postalCodeController.text.trim();

              if (name.isEmpty ||
                  address.isEmpty ||
                  city.isEmpty ||
                  postalCode.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!
                        .translate('required_fields')),
                  ),
                );
                return;
              }

              final newDealership = Dealership(
                id: Dealership.currentId++,
                name: name,
                address: address,
                city: city,
                postalCode: postalCode,
              );

              await widget.dealershipDao.insertDealership(newDealership);
              await _dealershipRepo.saveDealershipData(
                name: name,
                address: address,
                city: city,
                postalCode: postalCode,
              );

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.translate(
                      'added_success',
                      params: {'name': name},
                    )),
                  ),
                );
                loadDealerships();
                _checkLastDealership();
              }
            },
            child: Text(AppLocalizations.of(context)!.translate('add')),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog with dealership details
  void _showDealershipDialog(Dealership dealership) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!
            .translate('dealership_details')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: dealership.name),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!
                      .translate('dealership_name'),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: dealership.address),
                readOnly: true,
                decoration: InputDecoration(
                  labelText:
                  AppLocalizations.of(context)!.translate('address'),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: dealership.city),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('city'),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: dealership.postalCode),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!
                      .translate('postal_code'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.translate('close')),
          ),
        ],
      ),
    );
  }

  /// Handles showing dealership details based on the display mode
  void _showDealershipDetails(Dealership dealership, BuildContext context) {
    if (widget.isMaster) {
      widget.onDealershipSelected?.call(dealership);
    } else {
      _showDealershipDialog(dealership);
    }
  }

  /// Shows application instructions
  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
        Text(AppLocalizations.of(context)!.translate('instructions')),
        content: Text(AppLocalizations.of(context)!
            .translate('instructions_content')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.translate('ok')),
          ),
        ],
      ),
    );
  }

  /// Shows a language selection dialog
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            AppLocalizations.of(context)!.translate('select_language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                MyApp.setLocale(context, const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Deutsch'),
              onTap: () {
                MyApp.setLocale(context, const Locale('de'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!
            .translate('dealership_management')),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: _showInstructions,
            tooltip:
            AppLocalizations.of(context)!.translate('instructions'),
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageDialog(context),
            tooltip: AppLocalizations.of(context)!
                .translate('change_language'),
          ),
        ],
      ),
      body: _dealerships.isEmpty
          ? Center(
        child: Text(AppLocalizations.of(context)!
            .translate('no_dealerships')),
      )
          : ListView.builder(
        itemCount: _dealerships.length,
        itemBuilder: (context, index) {
          final dealership = _dealerships[index];
          return Card(
            margin:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(dealership.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dealership.address),
                  Text(
                      '${dealership.city}, ${dealership.postalCode}'),
                ],
              ),
              onTap: () =>
                  _showDealershipDetails(dealership, context),
              selected: widget.isMaster &&
                  widget.selectedDealership?.id == dealership.id,
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add_dealership',
            onPressed: () => _showAddDealershipDialog(),
            child: const Icon(Icons.add),
            tooltip: AppLocalizations.of(context)!
                .translate('add_dealership'),
          ),
          if (_hasLastDealership) ...[
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'copy_last',
              onPressed: () => _showAddDealershipDialog(
                  useLastDealership: true),
              child: const Icon(Icons.content_copy),
              tooltip: AppLocalizations.of(context)!
                  .translate('use_last_data'),
            ),
          ],
        ],
      ),
    );
  }
}