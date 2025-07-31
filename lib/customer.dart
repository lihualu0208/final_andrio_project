/// customer.dart
/// A data model class representing a Customer entity.
///
/// This class is annotated with Floor's `@Entity` to map it to a database table
/// named 'customers'. It contains fields for customer information including
/// ID, name, address, and birthday.

import 'package:floor/floor.dart';

@Entity(tableName: 'customers')
class Customer {
  /// The unique identifier for the customer.
  @primaryKey final int id;
  final String firstName;
  final String lastName;
  final String address;
  final String birthday;

  /// Creates a new Customer instance.
  ///
  /// All parameters are required:
  /// - [id]: The unique identifier for the customer
  /// - [firstName]: The customer's first name
  /// - [lastName]: The customer's last name
  /// - [address]: The customer's physical address
  /// - [birthday]: The customer's date of birth

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.birthday,
  });
  /// Static counter to track the next available ID for new customers.
  static int currentId = 1;

  @override
  String toString() {
    return 'Customer{id: $id, firstName: $firstName, lastName: $lastName, address: $address, birthday: $birthday}';
  }
}