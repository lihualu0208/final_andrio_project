import 'package:flutter/material.dart';
import 'app_database.dart';
import 'customer_dao.dart';
import 'customer_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase
      .databaseBuilder('customer_database.db')
      .build();

  final customerDao = database.customerDao;

  runApp(MyApp(customerDao: customerDao));
}

class MyApp extends StatelessWidget {
  final CustomerDao customerDao;

  const MyApp({super.key, required this.customerDao});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: CustomerListPage(customerDao: customerDao),
    );
  }
}