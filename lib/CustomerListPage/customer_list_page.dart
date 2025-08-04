import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'customer.dart';
import 'customer_repository.dart';
import 'customr_AppLocalizations.dart';

/// A page that displays a list of customers and their details.
///
/// This page supports localization, responsive layouts,
/// and the ability to add, edit, delete, and reuse customer data.
class CustomerListPage extends StatefulWidget {
  /// The customer repository to interact with the database and saved preferences.
  final CustomerRepository repository;
  /// The locale that should be forced for this page.
  final Locale forcedLocale;
  /// A callback to trigger locale changes externally.
  final void Function(Locale) onLocaleChange;

  const CustomerListPage({
    Key? key,
    required this.repository,
    required this.forcedLocale,
    required this.onLocaleChange,
  }) : super(key: key);

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final List<Customer> _customers = [];
  late CustomrApplocalizations loc;
  bool _hasPreviousCustomer = false;
  Customer? _selectedCustomer;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _checkPreviousCustomer();
  }

  /// Loads all customers from the database and updates the UI.
  Future<void> _loadCustomers() async {
    final customers = await widget.repository.dao.findAllCustomers();
    setState(() {
      _customers.clear();
      _customers.addAll(customers);
    });

    final maxId = await widget.repository.dao.findMaxId();
    Customer.currentId = (maxId ?? 0) + 1;
  }

  /// Checks if previously saved customer data exists.
  Future<void> _checkPreviousCustomer() async {
    await widget.repository.loadData();
    setState(() {
      _hasPreviousCustomer = widget.repository.firstName.isNotEmpty;
    });
  }

  /// Builds the responsive layout: split view on wide screens, single view on narrow.
  Widget _reactiveLayout() {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > size.height && size.width > 720;

    return Row(
      children: [
        // Left panel: Customer list and buttons
        Container(
          width: isWide ? 400 : size.width,
          color: const Color(0xFFF0F0F5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: _buildCustomerList(),
              ),
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'add_customer',
                      backgroundColor: const Color(0xFFDDE8FF),
                      foregroundColor: Colors.black,
                      onPressed: () => _showAddCustomerDialog(),
                      child: const Icon(Icons.add),
                    ),
                    if (_hasPreviousCustomer) ...[
                      const SizedBox(width: 7),
                      FloatingActionButton.small(
                        heroTag: 'copy_previous',
                        backgroundColor: const Color(0xFFDDE8FF),
                        foregroundColor: Colors.black,
                        onPressed: () => _showAddCustomerDialog(usePrevious: true),
                        tooltip: loc.translate('usePrevious'),
                        child: const Icon(Icons.content_copy),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        // Right: Detail
        if (isWide)
          Expanded(
            child: Container(
              color: const Color(0xFFE1E2E7),
              child: _selectedCustomer == null
                  ? Center(
                child: Text(
                  loc.translate('selectCustomer'),
                  style: const TextStyle(color: Colors.black54),
                ),
              )
                  : _buildCustomerDetails(_selectedCustomer!),
            ),
          ),
      ],
    );
  }

  /// Builds the scrollable list of customer cards.
  Widget _buildCustomerList() {
    if (_customers.isEmpty) {
      return Center(
        child: Text(
          loc.translate('noCustomers'),
          style: const TextStyle(
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _customers.length,
      itemBuilder: (context, index) {
        final customer = _customers[index];
        return GestureDetector(
          onTap: () => setState(() => _selectedCustomer = customer),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${customer.firstName} ${customer.lastName}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(customer.address, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  /// Builds a panel showing detailed information for a selected customer.
  Widget _buildCustomerDetails(Customer customer) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${loc.translate('firstName')}: ${customer.firstName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text('${loc.translate('lastName')}: ${customer.lastName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text('${loc.translate('address')}: ${customer.address}', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          Text('${loc.translate('birthday')}: ${customer.birthday}', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _showEditCustomerDialog(customer),
                child: Text(loc.translate('update')),
              ),
              ElevatedButton(
                onPressed: () async {
                  await widget.repository.dao.deleteCustomer(customer);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${loc.translate('customerDeleted')}: ${customer.firstName} ${customer.lastName}')),
                    );
                    _loadCustomers();
                    setState(() => _selectedCustomer = null);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(loc.translate('delete'), style: const TextStyle(color: Colors.white)),
              ),
              if (!(MediaQuery.of(context).size.width > 720))
                ElevatedButton(
                  onPressed: () => setState(() => _selectedCustomer = null),
                  child: Text(loc.translate('back')),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Shows a dialog allowing the user to choose between supported languages.
  ///
  /// Updates the locale by calling [widget.onLocaleChange] and closes the dialog.
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('language')),
        backgroundColor: const Color(0xFFDFDFE4),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(loc.translate('english')),
              onTap: () {
                widget.onLocaleChange(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(loc.translate('chinese')),
              onTap: () {
                widget.onLocaleChange(const Locale('zh'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Shows a dialog to add a new customer.
  ///
  /// If [usePrevious] is true and previous data exists, pre-fills the form with that data.
  /// Saves the new customer to the database and updates the UI.
  void _showAddCustomerDialog({bool usePrevious = false}) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final addressController = TextEditingController();
    final birthdayController = TextEditingController();

    if (usePrevious && _hasPreviousCustomer) {
      firstNameController.text = widget.repository.firstName;
      lastNameController.text = widget.repository.lastName;
      addressController.text = widget.repository.address;
      birthdayController.text = widget.repository.birthday;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('addCustomer')),
        backgroundColor: const Color(0xFFDFDFE4),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: firstNameController, decoration: InputDecoration(labelText: loc.translate('firstName'))),
              const SizedBox(height: 16),
              TextField(controller: lastNameController, decoration: InputDecoration(labelText: loc.translate('lastName'))),
              const SizedBox(height: 16),
              TextField(controller: addressController, decoration: InputDecoration(labelText: loc.translate('address'))),
              const SizedBox(height: 16),
              TextField(controller: birthdayController, decoration: InputDecoration(labelText: loc.translate('birthday'))),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(loc.translate('cancel'))),
          ElevatedButton(
            onPressed: () async {
              final newCustomer = Customer(
                id: Customer.currentId++,
                firstName: firstNameController.text.trim(),
                lastName: lastNameController.text.trim(),
                address: addressController.text.trim(),
                birthday: birthdayController.text.trim(),
              );
              await widget.repository.dao.insertCustomer(newCustomer);
              await widget.repository.saveCustomerData(
                firstName: newCustomer.firstName,
                lastName: newCustomer.lastName,
                address: newCustomer.address,
                birthday: newCustomer.birthday,
              );
              if (mounted) {
                Navigator.pop(context);
                _loadCustomers();
                _checkPreviousCustomer();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${loc.translate('customerAdded')}: ${newCustomer.firstName} ${newCustomer.lastName}'),
                ));
              }
            },
            child: Text(loc.translate('save')),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to edit an existing [customer]'s details.
  ///
  /// Updates the customer in the database and refreshes the UI.
  void _showEditCustomerDialog(Customer customer) {
    final firstNameController = TextEditingController(text: customer.firstName);
    final lastNameController = TextEditingController(text: customer.lastName);
    final addressController = TextEditingController(text: customer.address);
    final birthdayController = TextEditingController(text: customer.birthday);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('editCustomer')),
        backgroundColor: const Color(0xFFDFDFE4),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: firstNameController, decoration: InputDecoration(labelText: loc.translate('firstName'))),
              const SizedBox(height: 16),
              TextField(controller: lastNameController, decoration: InputDecoration(labelText: loc.translate('lastName'))),
              const SizedBox(height: 16),
              TextField(controller: addressController, decoration: InputDecoration(labelText: loc.translate('address'))),
              const SizedBox(height: 16),
              TextField(controller: birthdayController, decoration: InputDecoration(labelText: loc.translate('birthday'))),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(loc.translate('cancel'))),
          ElevatedButton(
            onPressed: () async {
              final updated = Customer(
                id: customer.id,
                firstName: firstNameController.text.trim(),
                lastName: lastNameController.text.trim(),
                address: addressController.text.trim(),
                birthday: birthdayController.text.trim(),
              );
              await widget.repository.dao.updateCustomer(updated);
              await widget.repository.saveCustomerData(
                firstName: updated.firstName,
                lastName: updated.lastName,
                address: updated.address,
                birthday: updated.birthday,
              );
              if (mounted) {
                Navigator.pop(context);
                setState(() => _selectedCustomer = updated);
                _loadCustomers();
                _checkPreviousCustomer();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.translate('customerUpdated'))));
              }
            },
            child: Text(loc.translate('update')),
          ),
        ],
      ),
    );
  }

  /// Displays an instruction dialog with helpful information for users.
  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('instructionsTitle')),
          backgroundColor: const Color(0xFFDFDFE4),
        content: Text(loc.translate('instructions')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(loc.translate('gotIt'))),
        ],
      ),
    );
  }

  /// Builds the root UI for the page with localization override.
  ///
  /// This method injects localized strings using [CustomrApplocalizations].
  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: widget.forcedLocale,
      delegates: const [
        CustomrApplocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: Builder(
        builder: (overrideContext) {
          loc = CustomrApplocalizations.of(overrideContext)!;
          return Scaffold(
            backgroundColor: const Color(0xFFDFDFE4),
            appBar: AppBar(
              title: Text(loc.translate('appTitle')),
              backgroundColor: const Color(0xFFDFDFE4),
              actions: [
                IconButton(icon: const Icon(Icons.language), onPressed: _showLanguageDialog),
                IconButton(icon: const Icon(Icons.help_outline), onPressed: _showInstructions),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _reactiveLayout(),
            ),
            floatingActionButton: MediaQuery.of(context).size.width > 720
                ? null // FABs already shown in left panel for wide layout
                : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'add_customer',
                  onPressed: () => _showAddCustomerDialog(),
                  child: const Icon(Icons.add),
                ),
                if (_hasPreviousCustomer) ...[
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: 'copy_previous',
                    onPressed: () => _showAddCustomerDialog(usePrevious: true),
                    child: const Icon(Icons.content_copy),
                    tooltip: loc.translate('usePrevious'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
