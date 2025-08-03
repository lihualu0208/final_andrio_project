/*
 * Student Name: Viet-Quynh Nguyen
 * Lab Professor: Professor Fedor Ilitchev
 * Due Date: /04/2025
 * Description: 25S_CST2335_022 Final Project
 */

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'car.dart';
import 'car_repository.dart';
import 'car_locale_provider.dart';

/// The main page for managing car entries.
///
/// Displays a list of cars, allows adding, editing,
/// deleting, and viewing details. Supports localization and secure data persistence.
class CarListPage extends StatefulWidget {
  /// Repository for database operations.
  final CarRepository repository;
  /// Callback to change locale.
  final void Function(Locale) onLocaleChange;

  const CarListPage({
    Key? key,
    required this.repository,
    required this.onLocaleChange,
  }) : super(key: key);

  @override
  State<CarListPage> createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  final _secureStorage = const FlutterSecureStorage();
  late Future<List<Car>> _carList;
  Car? _selectedCar;

  @override
  void initState() {
    super.initState();
    _refreshCars();
  }

  /// Refreshes the list of cars from the database.
  void _refreshCars() {
    setState(() {
      _carList = widget.repository.getAllCars();
      _selectedCar = null;
    });
  }

  /// Displays a dialog to add a new car.
  ///
  /// [usePrevious] determines if stored values should prefill fields.
  void _showAddDialog(CarLocaleProvider loc, {bool usePrevious = false}) async {
    final makeController = TextEditingController();
    final modelController = TextEditingController();
    final yearController = TextEditingController();
    final colorController = TextEditingController();
    String? imagePath;

    if (usePrevious) {
      makeController.text = await _secureStorage.read(key: 'last_make') ?? '';
      modelController.text = await _secureStorage.read(key: 'last_model') ?? '';
      yearController.text = await _secureStorage.read(key: 'last_year') ?? '';
      colorController.text = await _secureStorage.read(key: 'last_color') ?? '';
    }

    makeController.addListener(() {
      _secureStorage.write(key: 'last_make', value: makeController.text);
    });
    modelController.addListener(() {
      _secureStorage.write(key: 'last_model', value: modelController.text);
    });
    yearController.addListener(() {
      _secureStorage.write(key: 'last_year', value: yearController.text);
    });
    colorController.addListener(() {
      _secureStorage.write(key: 'last_color', value: colorController.text);
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFE4E7ED),
        title: Text(loc.get('add_car')),
        content: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (picked != null) setState(() => imagePath = picked.path);
                },
                child: imagePath == null
                    ? Image.asset('assets/images/placeholder.png', height: 100)
                    : Image.file(File(imagePath!), height: 100),
              ),

              TextField(controller: makeController, decoration: InputDecoration(labelText: loc.get('make'))),
              TextField(controller: modelController, decoration: InputDecoration(labelText: loc.get('model'))),
              TextField(controller: yearController, decoration: InputDecoration(labelText: loc.get('year'))),
              TextField(controller: colorController, decoration: InputDecoration(labelText: loc.get('color'))),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(loc.get('cancel'))),
          ElevatedButton(
            onPressed: () async {
              if ([makeController.text, modelController.text, yearController.text, colorController.text, imagePath].any((e) => e == null || e.isEmpty)) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.get('fill_all_fields'))));
                return;
              }
              final car = Car(
                make: makeController.text,
                model: modelController.text,
                year: yearController.text,
                color: colorController.text,
                imagePath: imagePath!,
              );
              await widget.repository.insertCar(car);
              Navigator.pop(context);
              _refreshCars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.get('car_added'))));
            },
            child: Text(loc.get('add_car')),
          ),
        ],
      ),
    );
  }

  /// Displays a dialog to edit car.
  void _showEditDialog(Car car, CarLocaleProvider loc) {
    final makeController = TextEditingController(text: car.make);
    final modelController = TextEditingController(text: car.model);
    final yearController = TextEditingController(text: car.year);
    final colorController = TextEditingController(text: car.color);
    String imagePath = car.imagePath;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFE4E7ED),
        title: Text(loc.get('car_edit')),
        content: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (picked != null) setState(() => imagePath = picked.path);
                },
                child: imagePath.isEmpty
                    ? Image.asset('assets/images/placeholder.png', height: 100)
                    : Image.file(File(imagePath), height: 100),
              ),
              TextField(controller: makeController, decoration: InputDecoration(labelText: loc.get('make'))),
              TextField(controller: modelController, decoration: InputDecoration(labelText: loc.get('model'))),
              TextField(controller: yearController, decoration: InputDecoration(labelText: loc.get('year'))),
              TextField(controller: colorController, decoration: InputDecoration(labelText: loc.get('color'))),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(loc.get('cancel'))),
          ElevatedButton(
            onPressed: () async {
              if ([makeController.text, modelController.text, yearController.text, colorController.text, imagePath].any((e) => e.isEmpty)) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.get('fill_all_fields'))));
                return;
              }

              final updatedCar = Car(
                id: car.id,
                make: makeController.text,
                model: modelController.text,
                year: yearController.text,
                color: colorController.text,
                imagePath: imagePath,
              );

              await widget.repository.updateCar(updatedCar);
              Navigator.pop(context);
              _refreshCars();
              setState(() => _selectedCar = updatedCar);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.get('car_updated'))));
            },
            child: Text(loc.get('update')),
          ),
        ],
      ),
    );
  }

  /// Deletes a selected car and shows confirmation.
  void _deleteCar(Car car, CarLocaleProvider loc) async {
    await widget.repository.deleteCar(car);
    _refreshCars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.get('car_deleted'))));
  }

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<CarLocaleProvider>(context, CarLocaleProvider)!;
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      body: Row(
        children: [
          // Left side - Car list
          Container(
            width: isWide ? 400 : MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFF3F6FA),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App title and icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loc.get('app_title'),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.help_outline),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: const Color(0xFFE4E7ED),
                                    title: Text(loc.get('instructions')),
                                    content: Text('${loc.get('add_car')}${loc.get('with_images')}\n${loc.get('fill_all_fields')}\n${loc.get('tap_car')}'),
                                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.language),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: const Color(0xFFE4E7ED),
                                    title: const Text("Language"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: const Text("English"),
                                          onTap: () {
                                            widget.onLocaleChange(const Locale('en'));
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          title: const Text("Tiếng Việt"),
                                          onTap: () {
                                            widget.onLocaleChange(const Locale('vi'));
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Car list
                    Expanded(
                      child: FutureBuilder<List<Car>>(
                        future: _carList,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text(loc.get('no_cars')));
                          }

                          final cars = snapshot.data!;
                          return ListView.builder(
                            itemCount: cars.length,
                            itemBuilder: (_, index) {
                              final car = cars[index];
                              return GestureDetector(
                                onTap: () => setState(() => _selectedCar = car),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${car.make} ${car.model}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text('${car.year} - ${car.color}', style: const TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // Floating Action Buttons (Add & Use Previous)
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FloatingActionButton(
                        heroTag: 'add_car',
                        onPressed: () => _showAddDialog(loc),
                        backgroundColor: const Color(0xFFD8E7FF),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.add),
                        tooltip: loc.get('add_car'),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton(
                        heroTag: 'use_previous',
                        onPressed: () => _showAddDialog(loc, usePrevious: true),
                        backgroundColor: const Color(0xFFD8E7FF),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.restore),
                        tooltip: loc.get('use_previous'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Right side - Car details
          if (isWide)
            Expanded(
              child: Container(
                color: const Color(0xFFE4E7ED),
                child: _selectedCar == null
                    ? Center(child: Text(loc.get('select_car'), style: const TextStyle(color: Colors.black54)))
                    : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.file(File(_selectedCar!.imagePath), height: 120),
                      const SizedBox(height: 16),
                      Text('${loc.get('make')}: ${_selectedCar!.make}'),
                      Text('${loc.get('model')}: ${_selectedCar!.model}'),
                      Text('${loc.get('year')}: ${_selectedCar!.year}'),
                      Text('${loc.get('color')}: ${_selectedCar!.color}'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => _showEditDialog(_selectedCar!, loc),
                            child: Text(loc.get('update')),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _deleteCar(_selectedCar!, loc),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: Text(loc.get('delete'), style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
