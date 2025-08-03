/**
 * Represents a car dealership entity with all its properties.
 * This class is used for both business logic and database storage.
 */
// car_dealership.dart
import 'package:floor/floor.dart';

/// A dealership entity that maps to the 'dealerships' table
@Entity(tableName: 'dealerships')
class Dealership {
  @primaryKey final int id;
  final String name;
  final String address;
  final String city;
  final String postalCode;

  /// Creates a new Dealership instance
  Dealership({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.postalCode,
  });

  /// The current ID counter for new dealerships
  static int currentId = 1;

  @override
  String toString() {
    return 'Dealership{id: $id, name: $name, address: $address, city: $city, postalCode: $postalCode}';
  }
}