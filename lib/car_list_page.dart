import 'package:flutter/material.dart';
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
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  late Future<List<Car>> _carList;

  @override
  void initState() {
    super.initState();
    _refreshCars();
  }

  void _refreshCars() {
    setState(() {
      _carList = widget.repository.getAllCars();
    });
  }

  void _showAddForm(CarLocaleProvider loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.get('add_car')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _makeController, decoration: InputDecoration(labelText: loc.get('make'))),
            TextField(controller: _modelController, decoration: InputDecoration(labelText: loc.get('model'))),
            TextField(controller: _yearController, decoration: InputDecoration(labelText: loc.get('year'))),
            TextField(controller: _colorController, decoration: InputDecoration(labelText: loc.get('color'))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_makeController.text.isEmpty ||
                  _modelController.text.isEmpty ||
                  _yearController.text.isEmpty ||
                  _colorController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.get('fill_all_fields'))));
                return;
              }
              final car = Car(
                make: _makeController.text,
                model: _modelController.text,
                year: _yearController.text,
                color: _colorController.text,
              );
              await widget.repository.insertCar(car);
              _makeController.clear();
              _modelController.clear();
              _yearController.clear();
              _colorController.clear();
              _refreshCars();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.get('car_added'))));
            },
            child: Text(loc.get('add_car')),
          )
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

    return Scaffold(
      appBar: AppBar(title: Text(loc.get('app_title'))),
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
          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return ListTile(
                title: Text('${car.make} ${car.model}'),
                subtitle: Text('${car.year} • ${car.color}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteCar(car, loc),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => _showAddForm(loc),
            tooltip: loc.get('add_car'),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'lang',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: const Text('English'),
                        onTap: () {
                          widget.onLocaleChange(const Locale('en'));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: const Text('Tiếng Việt'),
                        onTap: () {
                          widget.onLocaleChange(const Locale('vi'));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            tooltip: 'Language',
            child: const Icon(Icons.language),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'help',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(loc.get('instructions')),
                  content: Text(
                    '• ${loc.get('make')} + ${loc.get('model')} → ${loc.get('add_car')}\n'
                        '• ${loc.get('fill_all_fields')}\n'
                        '• ${loc.get('car_deleted')} by tapping 🗑️',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Instructions',
            child: const Icon(Icons.help_outline),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    super.dispose();
  }
}
