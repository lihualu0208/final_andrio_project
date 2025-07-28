import 'package:floor/floor.dart';

@Entity(tableName: 'customers')
class Customer {
  @primaryKey final int id;
  final String firstName;
  final String lastName;
  final String address;
  final String birthday;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.birthday,
  });

  static int currentId = 1;

  @override
  String toString() {
    return 'Customer{id: $id, firstName: $firstName, lastName: $lastName, address: $address, birthday: $birthday}';
  }
}