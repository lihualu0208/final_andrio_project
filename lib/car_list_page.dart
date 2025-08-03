import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'car.dart';
import 'car_repository.dart';
import 'car_locale_provider.dart';

class CarListPage extends StatefulWidget {
  final CarRepository repository;
  final void Function(Locale) onLocaleChange;

  const CarListPage({Key? key, required this.repository, required this.onLocaleChange}) : super(key: key);

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

  void _refreshCars() {
    setState(() {
      _carList = widget.repository.getAllCars();
      _selectedCar = null;
    });
  }

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
        title: Text(loc.get('add_car')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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



  void _showEditDialog(Car car, CarLocaleProvider loc) {
    final makeController = TextEditingController(text: car.make);
    final modelController = TextEditingController(text: car.model);
    final yearController = TextEditingController(text: car.year);
    final colorController = TextEditingController(text: car.color);
    String imagePath = car.imagePath;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.get('edit_car')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() => imagePath = picked.path);
                  }
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
      appBar: AppBar(
        title: Text(loc.get('app_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Language'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(title: const Text('English'), onTap: () { widget.onLocaleChange(const Locale('en')); Navigator.pop(context); }),
                      ListTile(title: const Text('Tiếng Việt'), onTap: () { widget.onLocaleChange(const Locale('vi')); Navigator.pop(context); }),
                    ],
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(loc.get('instructions')),
                content: Text('• ${loc.get('add_car')}${loc.get('with_images')} \n• ${loc.get('fill_all_fields')}\n• ${loc.get('tap_car')}'),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Car>>(
        future: _carList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text(loc.get('no_cars')));

          final cars = snapshot.data!;
          return isWide
              ? Row(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    final car = cars[index];
                    return ListTile(
                      leading: Image.file(File(car.imagePath), height: 40, width: 40, fit: BoxFit.cover),
                      title: Text('${car.make} ${car.model}'),
                      onTap: () => setState(() => _selectedCar = car),
                    );
                  },
                ),
              ),
              Expanded(
                child: _selectedCar == null
                    ? Center(child: Text(loc.get('select_car')))
                    : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.file(File(_selectedCar!.imagePath), height: 120),
                      const SizedBox(height: 12),
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
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _deleteCar(_selectedCar!, loc),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: Text(loc.get('delete'),
                            style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
              : ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return ListTile(
                leading: Image.file(File(car.imagePath), height: 40, width: 40, fit: BoxFit.cover),
                title: Text('${car.make} ${car.model}'),
                onTap: () => setState(() => _selectedCar = car),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _showAddDialog(loc),
            tooltip: loc.get('add_car'),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => _showAddDialog(loc, usePrevious: true),
            tooltip: loc.get('use_previous'),
            child: const Icon(Icons.restore),
          ),
        ],
      ),
    );
  }
}
