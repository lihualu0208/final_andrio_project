/// customer_dao.dart
/// Data Access Object (DAO) for Customer operations.
///
/// This abstract class defines the database operations that can be performed
/// on the Customer entity, including CRUD operations and ID management.

import 'package:floor/floor.dart';
import 'customer.dart';

@dao
abstract class CustomerDao {
  /// Retrieves all customers from the database, ordered by ID in ascending order.
  @Query('SELECT * FROM customers ORDER BY id ASC')
  Future<List<Customer>> findAllCustomers();

  /// Finds the maximum ID value in the customers table.
  @Query('SELECT MAX(id) FROM customers')
  Future<int?> findMaxId();

  /// Inserts a new customer into the database.
  @insert
  Future<void> insertCustomer(Customer customer);

  /// Updates an existing customer in the database.
  @update
  Future<void> updateCustomer(Customer customer);

  /// Delete an existing customer in the database.
  @delete
  Future<void> deleteCustomer(Customer customer);
}