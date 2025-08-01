/**
 * The main page that displays and manages the list of dealerships.
 * Handles CRUD operations and provides UI for dealership management.
 */
import 'package:flutter/material.dart';
import 'car_dealership.dart';
import 'dealership_dao.dart';
import 'dealership_repository.dart';
import 'app_localizations.dart';
import 'main.dart';

/// Displays a list of dealerships and handles their management
class DealershipListPage extends StatefulWidget {
  final DealershipDao dealershipDao;
  final bool isMaster;

  const DealershipListPage({
    super.key,
    required this.dealershipDao,
    this.isMaster = false,
  });

  @override
  State<DealershipListPage> createState() => _DealershipListPageState();
}

class _DealershipListPageState extends State<DealershipListPage> {
  final DealershipRepository _dealershipRepo = DealershipRepository();
  final List<Dealership> _dealerships = [];
  bool _hasLastDealership = false;
  Dealership? _selectedDealership;

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _postalCodeController = TextEditingController();
    _loadDealerships();
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

  /// Loads all dealerships from the database
  Future<void> _loadDealerships() async {
    final dealerships = await widget.dealershipDao.findAllDealerships();
    setState(() {
      _dealerships.clear();
      _dealerships.addAll(dealerships);
    });

    final maxId = await widget.dealershipDao.findMaxId();
    if (maxId != null) {
      Dealership.currentId = maxId + 1;
    } else {
      Dealership.currentId = 1;
    }
  }

  /// Checks if there's a previously saved dealership
  Future<void> _checkLastDealership() async {
    await _dealershipRepo.loadData();
    setState(() {
      _hasLastDealership = _dealershipRepo.name.isNotEmpty &&
          _dealershipRepo.address.isNotEmpty;
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
        title: Text(AppLocalizations.of(context)!.translate('add_new_dealership')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('dealership_name'),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('address'),
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
                  labelText: AppLocalizations.of(context)!.translate('postal_code'),
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

              if (name.isEmpty || address.isEmpty || city.isEmpty || postalCode.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.translate('required_fields'),
                    ),
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
                    content: Text(
                      AppLocalizations.of(context)!.translate(
                        'added_success',
                        params: {'name': name},
                      ),
                    ),
                  ),
                );
                _loadDealerships();
                _checkLastDealership();
              }
            },
            child: Text(AppLocalizations.of(context)!.translate('add')),
          ),
        ],
      ),
    );
  }

  /// Shows a read-only dialog with dealership details (for phone layout)
  void _showDealershipDialog(Dealership dealership) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('dealership_details')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: dealership.name),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('dealership_name'),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: dealership.address),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('address'),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: dealership.city),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('city'),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: dealership.postalCode),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('postal_code'),
                ),
                readOnly: true,
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

  /// Handles showing dealership details based on screen size
  void _showDealershipDetails(Dealership dealership, BuildContext context) {
    if (widget.isMaster) {
      setState(() {
        _selectedDealership = dealership;
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DealershipDetailPage(
            dealership: dealership,
            onUpdate: _handleUpdate,
            onDelete: _handleDelete,
          ),
        ),
      );
    } else {
      _showDealershipDialog(dealership);
    }
  }

  /// Handles updating a dealership
  void _handleUpdate(Dealership updatedDealership) async {
    await widget.dealershipDao.updateDealership(updatedDealership);
    await _dealershipRepo.saveDealershipData(
      name: updatedDealership.name,
      address: updatedDealership.address,
      city: updatedDealership.city,
      postalCode: updatedDealership.postalCode,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate('updated_success'),
          ),
        ),
      );
      _loadDealerships();
      _checkLastDealership();
    }
  }

  /// Handles deleting a dealership
  void _handleDelete(Dealership dealership) async {
    await widget.dealershipDao.deleteDealership(dealership);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate(
              'deleted_success',
              params: {'name': dealership.name},
            ),
          ),
        ),
      );
      _loadDealerships();
      _checkLastDealership();
    }
  }

  /// Shows application instructions
  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('instructions')),
        content: Text(
          AppLocalizations.of(context)!.translate('instructions_content'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.translate('ok')),
          ),
        ],
      ),
    );
  }

  /// Shows language selection dialog
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('select_language')),
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
        title: Text(AppLocalizations.of(context)!.translate('dealership_management')),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: _showInstructions,
            tooltip: AppLocalizations.of(context)!.translate('instructions'),
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageDialog(context),
            tooltip: AppLocalizations.of(context)!.translate('change_language'),
          ),
        ],
      ),
      body: _dealerships.isEmpty
          ? Center(
        child: Text(
          AppLocalizations.of(context)!.translate('no_dealerships'),
        ),
      )
          : ListView.builder(
        itemCount: _dealerships.length,
        itemBuilder: (context, index) {
          final dealership = _dealerships[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(dealership.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dealership.address),
                  Text('${dealership.city}, ${dealership.postalCode}'),
                ],
              ),
              onTap: () => _showDealershipDetails(dealership, context),
              selected: widget.isMaster && _selectedDealership == dealership,
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
            tooltip: AppLocalizations.of(context)!.translate('add_dealership'),
          ),
          if (_hasLastDealership) ...[
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'copy_last',
              onPressed: () => _showAddDealershipDialog(useLastDealership: true),
              child: const Icon(Icons.content_copy),
              tooltip: AppLocalizations.of(context)!.translate('use_last_data'),
            ),
          ],
        ],
      ),
    );
  }
}

/**
 * Displays detailed information about a single dealership.
 * Provides options to edit or delete the dealership.
 */
class DealershipDetailPage extends StatelessWidget {
  final Dealership dealership;
  final Function(Dealership) onUpdate;
  final Function(Dealership) onDelete;

  const DealershipDetailPage({
    super.key,
    required this.dealership,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('dealership_details')),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDelete(dealership),
            tooltip: AppLocalizations.of(context)!.translate('delete'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dealership.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              dealership.address,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${dealership.city}, ${dealership.postalCode}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _showEditDialog(context),
              child: Text(AppLocalizations.of(context)!.translate('edit')),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows a dialog for editing dealership details
  void _showEditDialog(BuildContext context) {
    final nameController = TextEditingController(text: dealership.name);
    final addressController = TextEditingController(text: dealership.address);
    final cityController = TextEditingController(text: dealership.city);
    final postalCodeController = TextEditingController(text: dealership.postalCode);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('edit_dealership')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('dealership_name'),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('address'),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('city'),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: postalCodeController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('postal_code'),
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
            onPressed: () {
              final updatedDealership = Dealership(
                id: dealership.id,
                name: nameController.text.trim(),
                address: addressController.text.trim(),
                city: cityController.text.trim(),
                postalCode: postalCodeController.text.trim(),
              );
              onUpdate(updatedDealership);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.translate('update')),
          ),
        ],
      ),
    );
  }
}