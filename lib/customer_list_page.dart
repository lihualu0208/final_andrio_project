import 'package:flutter/material.dart';
import 'customer.dart';
import 'customer_dao.dart';
import 'customer_repository.dart';

class CustomerListPage extends StatefulWidget {
  final CustomerDao customerDao;
  const CustomerListPage({super.key, required this.customerDao});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final CustomerRepository _customerRepo = CustomerRepository();
  final List<Customer> _customers = [];
  bool _hasLastCustomer = false;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _checkLastCustomer();
  }

  Future<void> _loadCustomers() async {
    final customers = await widget.customerDao.findAllCustomers();
    setState(() {
      _customers.clear();
      _customers.addAll(customers);
    });

    final maxId = await widget.customerDao.findMaxId();
    if (maxId != null) {
      Customer.currentId = maxId + 1;
    } else {
      Customer.currentId = 1;
    }
  }

  Future<void> _checkLastCustomer() async {
    await _customerRepo.loadData();
    setState(() {
      _hasLastCustomer = _customerRepo.firstName.isNotEmpty &&
          _customerRepo.lastName.isNotEmpty;
    });
  }

  void _showAddCustomerDialog({bool useLastCustomer = false}) {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController birthdayController = TextEditingController();

    if (useLastCustomer && _hasLastCustomer) {
      firstNameController.text = _customerRepo.firstName;
      lastNameController.text = _customerRepo.lastName;
      addressController.text = _customerRepo.address;
      birthdayController.text = _customerRepo.birthday;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Customer'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: birthdayController,
                decoration: const InputDecoration(labelText: 'Birthday (YYYY-MM-DD)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final firstName = firstNameController.text.trim();
              final lastName = lastNameController.text.trim();
              final address = addressController.text.trim();
              final birthday = birthdayController.text.trim();

              if (firstName.isEmpty || lastName.isEmpty || address.isEmpty || birthday.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All fields are required')),
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
                  SnackBar(content: Text('$firstName $lastName added successfully')),
                );
                _loadCustomers();
                _checkLastCustomer();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showCustomerDetails(Customer customer) {
    final TextEditingController firstNameController = TextEditingController(text: customer.firstName);
    final TextEditingController lastNameController = TextEditingController(text: customer.lastName);
    final TextEditingController addressController = TextEditingController(text: customer.address);
    final TextEditingController birthdayController = TextEditingController(text: customer.birthday);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Customer Details'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: birthdayController,
                decoration: const InputDecoration(labelText: 'Birthday (YYYY-MM-DD)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
                  const SnackBar(content: Text('Customer updated successfully')),
                );
                _loadCustomers();
                _checkLastCustomer();
              }
            },
            child: const Text('Update'),
          ),
          ElevatedButton(
            onPressed: () async {
              await widget.customerDao.deleteCustomer(customer);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${customer.firstName} ${customer.lastName} deleted')),
                );
                _loadCustomers();
                _checkLastCustomer();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Instructions'),
        content: const Text(
          '1. Tap "Add Customer" to add a new customer\n'
              '2. Select a customer from the list to view/edit details\n'
              '3. Use the update button to save changes\n'
              '4. Use the delete button to remove a customer\n'
              '5. Use the copy button to copy last customer details',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: _showInstructions,
          ),
        ],
      ),
      body: _customers.isEmpty
          ? const Center(child: Text('No customers found'))
          : ListView.builder(
        itemCount: _customers.length,
        itemBuilder: (context, index) {
          final customer = _customers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('${customer.firstName} ${customer.lastName}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customer.address),
                  Text('Birthday: ${customer.birthday}'),
                ],
              ),
              onTap: () => _showCustomerDetails(customer),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add_customer',
            onPressed: () => _showAddCustomerDialog(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          if (_hasLastCustomer)
            FloatingActionButton(
              heroTag: 'copy_last',
              onPressed: () => _showAddCustomerDialog(useLastCustomer: true),
              child: const Icon(Icons.content_copy),
              tooltip: 'Use last customer data',
            ),
        ],
      ),
    );
  }
}