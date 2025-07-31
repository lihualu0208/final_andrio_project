import 'package:floor/floor.dart';
import 'customer.dart';

@dao
abstract class CustomerDao {
  @Query('SELECT * FROM customers ORDER BY id ASC')
  Future<List<Customer>> findAllCustomers();

  @Query('SELECT MAX(id) FROM customers')
  Future<int?> findMaxId();

  @insert
  Future<void> insertCustomer(Customer customer);

  @update
  Future<void> updateCustomer(Customer customer);

  @delete
  Future<void> deleteCustomer(Customer customer);
}