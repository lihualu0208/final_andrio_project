import 'package:flutter/material.dart';
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

  void _showAddDialog(CarLocaleProvider loc) {
    final makeController = TextEditingController();
    final modelController = TextEditingController();
    final yearController = TextEditingController();
    final colorController = TextEditingController();
    String? imagePath;

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
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() {
                      imagePath = picked.path;
                    });
                  }
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
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

  void _deleteCar(Car car, CarLocaleProvider loc) async {
    await widget.repository.deleteCar(car);
    _refreshCars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.get('car_deleted'))));
  }

  void _updateCar(Car updatedCar) async {
    await widget.repository.updateCar(updatedCar);
    _refreshCars();
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
                      ListTile(
                        title: const Text('English'),
                        onTap: () {
                          widget.onLocaleChange(const Locale('en'));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Tiếng Việt'),
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
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(loc.get('instructions')),
                content: Text('• ${loc.get('add_car')} → with image\n• ${loc.get('fill_all_fields')}\n• Tap car to edit/delete'),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder<List<Car>>(
        future: _carList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(loc.get('no_cars')));
          }

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
                    ? Center(child: Text('Select a car'))
                    : CarDetailView(
                  car: _selectedCar!,
                  onDelete: () => _deleteCar(_selectedCar!, loc),
                  onUpdate: _updateCar,
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
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(title: Text('${car.make} ${car.model}')),
                      body: CarDetailView(
                        car: car,
                        onDelete: () => _deleteCar(car, loc),
                        onUpdate: _updateCar,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(loc),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CarDetailView extends StatelessWidget {
  final Car car;
  final VoidCallback onDelete;
  final Function(Car) onUpdate;

  const CarDetailView({super.key, required this.car, required this.onDelete, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final makeCtrl = TextEditingController(text: car.make);
    final modelCtrl = TextEditingController(text: car.model);
    final yearCtrl = TextEditingController(text: car.year);
    final colorCtrl = TextEditingController(text: car.color);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(File(car.imagePath), height: 120),
          TextField(controller: makeCtrl),
          TextField(controller: modelCtrl),
          TextField(controller: yearCtrl),
          TextField(controller: colorCtrl),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => onUpdate(Car(
                  id: car.id,
                  make: makeCtrl.text,
                  model: modelCtrl.text,
                  year: yearCtrl.text,
                  color: colorCtrl.text,
                  imagePath: car.imagePath,
                )),
                child: const Text('Update'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          )
        ],
      ),
    );
  }
}