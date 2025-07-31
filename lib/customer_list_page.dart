/// customer_list_page.dart
/// The main page of the Customer Management application.
///
/// This widget provides functionality to:
/// - View a list of all customers
/// - Add new customers
/// - Edit existing customers
/// - Delete customers
/// - View customer details in a responsive layout
/// - Switch between languages (English/Chinese)
///
/// The layout adapts to different screen sizes, showing a side-by-side view
/// on larger screens and a stacked view on smaller devices.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'customer.dart';
import 'customer_dao.dart';
import 'customer_repository.dart';
import 'customr_AppLocalizations.dart';
import 'customer_locale_provider.dart';

class CustomerListPage extends StatefulWidget {
  /// The [CustomerDao] instance used for database operations.
  final CustomerDao customerDao;
  /// Creates a [CustomerListPage] with the given [customerDao].
  ///
  /// The [customerDao] must not be null.
  const CustomerListPage({super.key, required this.customerDao});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}
/// The state class for [CustomerListPage].
///
/// Manages:
/// - The list of customers
/// - The currently selected customer
/// - The customer repository for temporary data storage
/// - The responsive layout state

class _CustomerListPageState extends State<CustomerListPage> {
  final CustomerRepository _customerRepo = CustomerRepository();
  final List<Customer> _customers = [];
  bool _hasPreviousCustomer = false;
  Customer? _selectedCustomer;

  /// Loads all customers from the database and updates the UI.
  ///
  /// Also sets the [Customer.currentId] to the next available ID.
  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _checkPreviousCustomer();
  }
  /// Loads all customers from the database and updates the UI.
  ///
  /// Also sets the [Customer.currentId] to the next available ID.
  Future<void> _loadCustomers() async {
    final customers = await widget.customerDao.findAllCustomers();
    setState(() {
      _customers.clear();
      _customers.addAll(customers);
    });

    final maxId = await widget.customerDao.findMaxId();
    Customer.currentId = (maxId ?? 0) + 1;
  }
  /// Checks if there's previous customer data available to reuse.
  Future<void> _checkPreviousCustomer() async {
    await _customerRepo.loadData();
    setState(() {
      _hasPreviousCustomer = _customerRepo.firstName.isNotEmpty;
    });
  }

  /// Builds a responsive layout based on screen size.
  ///
  /// On large screens (width > height and width > 720), shows a side-by-side
  /// view of the customer list and details. On smaller screens, shows either
  /// the list or details view.
  Widget _reactiveLayout() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    if ((width > height) && (width > 720)) {
      return Row(
        children: [
          Expanded(flex: 1, child: _buildCustomerList()),
          Expanded(
            flex: 1,
            child: _selectedCustomer == null
                ? Center(child: Text(AppLocalizations.of(context)!.translate('selectCustomer')))
                : _buildCustomerDetails(_selectedCustomer!),
          ),
        ],
      );
    } else {
      return _selectedCustomer == null
          ? _buildCustomerList()
          : _buildCustomerDetails(_selectedCustomer!);
    }
  }
  /// Builds a scrollable list of customers.
  ///
  /// Each customer is displayed in a [Card] with their name and address.
  /// Tapping a customer selects it for viewing/editing.

  Widget _buildCustomerList() {
    return ListView.builder(
      itemCount: _customers.length,
      itemBuilder: (context, index) {
        final customer = _customers[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text('${customer.firstName} ${customer.lastName}'),
            subtitle: Text(customer.address),
            onTap: () => setState(() => _selectedCustomer = customer),
          ),
        );
      },
    );
  }
  /// Builds a detailed view of a customer.
  ///
  /// Displays all customer information and provides buttons for:
  /// - Editing the customer
  /// - Deleting the customer
  /// - Returning to the list (on small screens)

  Widget _buildCustomerDetails(Customer customer) {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${loc.translate('firstName')}: ${customer.firstName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text('${loc.translate('lastName')}: ${customer.lastName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text('${loc.translate('address')}: ${customer.address}',
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          Text('${loc.translate('birthday')}: ${customer.birthday}',
              style: const TextStyle(fontSize: 16)),
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
                  await widget.customerDao.deleteCustomer(customer);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${loc.translate('customerDeleted')}: ${customer.firstName} ${customer.lastName}')),
                    );
                    _loadCustomers();
                    setState(() => _selectedCustomer = null);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(loc.translate('delete'),
                    style: const TextStyle(color: Colors.white)),
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

  /// Shows a dialog for selecting the application language.
  void _showLanguageDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(loc.translate('english')),
              onTap: () {
                Provider.of<LocaleProvider>(context, listen: false)
                    .setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(loc.translate('chinese')),
              onTap: () {
                Provider.of<LocaleProvider>(context, listen: false)
                    .setLocale(const Locale('zh'));
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
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('appTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _showLanguageDialog,
            tooltip: loc.translate('language'),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showInstructions,
            tooltip: loc.translate('instructionsTitle'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _reactiveLayout(),
      ),
      floatingActionButton: Column(
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
  }

  /// Shows a dialog for adding a new customer.
  ///
  /// If [usePrevious] is true, pre-fills the form with data from the last
  /// saved customer.

  void _showAddCustomerDialog({bool usePrevious = false}) {
    final loc = AppLocalizations.of(context)!;
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final addressController = TextEditingController();
    final birthdayController = TextEditingController();

    if (usePrevious && _hasPreviousCustomer) {
      firstNameController.text = _customerRepo.firstName;
      lastNameController.text = _customerRepo.lastName;
      addressController.text = _customerRepo.address;
      birthdayController.text = _customerRepo.birthday;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('addCustomer')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: loc.translate('firstName'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: loc.translate('lastName'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: loc.translate('address'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: birthdayController,
                decoration: InputDecoration(
                  labelText: loc.translate('birthday'),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              final firstName = firstNameController.text.trim();
              final lastName = lastNameController.text.trim();
              final address = addressController.text.trim();
              final birthday = birthdayController.text.trim();

              if (firstName.isEmpty || lastName.isEmpty || address.isEmpty || birthday.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.translate('allFieldsRequired'))),
                );
                return;
              }

              final newCustomer = Customer(
                id: Customer.currentId++,
                firstName: firstName,
                lastName: lastName,
                address: address,
                birthday: birthday,
              );

              await widget.customerDao.insertCustomer(newCustomer);
              await _customerRepo.saveCustomerData(
                firstName: firstName,
                lastName: lastName,
                address: address,
                birthday: birthday,
              );

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${loc.translate('customerAdded')}: $firstName $lastName')),
                );
                _loadCustomers();
                _checkPreviousCustomer();
              }
            },
            child: Text(loc.translate('save')),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog for editing an existing customer.

  void _showEditCustomerDialog(Customer customer) {
    final loc = AppLocalizations.of(context)!;
    final firstNameController = TextEditingController(text: customer.firstName);
    final lastNameController = TextEditingController(text: customer.lastName);
    final addressController = TextEditingController(text: customer.address);
    final birthdayController = TextEditingController(text: customer.birthday);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('editCustomer')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: loc.translate('firstName'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: loc.translate('lastName'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: loc.translate('address'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: birthdayController,
                decoration: InputDecoration(
                  labelText: loc.translate('birthday'),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedCustomer = Customer(
                id: customer.id,
                firstName: firstNameController.text.trim(),
                lastName: lastNameController.text.trim(),
                address: addressController.text.trim(),
                birthday: birthdayController.text.trim(),
              );

              await widget.customerDao.updateCustomer(updatedCustomer);
              await _customerRepo.saveCustomerData(
                firstName: updatedCustomer.firstName,
                lastName: updatedCustomer.lastName,
                address: updatedCustomer.address,
                birthday: updatedCustomer.birthday,
              );

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.translate('customerUpdated'))),
                );
                _loadCustomers();
                _checkPreviousCustomer();
                setState(() => _selectedCustomer = updatedCustomer);
              }
            },
            child: Text(loc.translate('update')),
          ),
        ],
      ),
    );
  }
  /// Shows application instructions in a dialog.
  void _showInstructions() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('instructionsTitle')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.translate('instructions')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.translate('gotIt')),
          ),
        ],
      ),
    );
  }
}