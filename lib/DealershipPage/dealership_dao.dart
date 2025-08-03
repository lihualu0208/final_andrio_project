/**
 * Data Access Object for dealership operations.
 * Defines all database operations related to dealerships.
 */
// dealership_dao.dart
import 'package:floor/floor.dart';
import 'car_dealership.dart';

/// Provides access to dealership database operations
@dao
abstract class DealershipDao {
  /// Retrieves all dealerships ordered by ID
  @Query('SELECT * FROM dealerships ORDER BY id ASC')
  Future<List<Dealership>> findAllDealerships();

  /// Finds the maximum ID in the dealerships table
  @Query('SELECT MAX(id) FROM dealerships')
  Future<int?> findMaxId();

  /// Inserts a new dealership
  @insert
  Future<void> insertDealership(Dealership dealership);

  /// Updates an existing dealership
  @update
  Future<void> updateDealership(Dealership dealership);

  /// Deletes a dealership
  @delete
  Future<void> deleteDealership(Dealership dealership);
}