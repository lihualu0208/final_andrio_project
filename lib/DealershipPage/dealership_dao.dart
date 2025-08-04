/**
 * Data Access Object for dealership operations.
 * Defines all database operations related to dealerships.
 */
import 'package:floor/floor.dart';
import 'car_dealership.dart';

/// Provides access to dealership database operations
@dao
abstract class DealershipDao {
  /// Retrieves all dealerships ordered by ID
  ///
  /// Returns a list of all dealerships in ascending order by ID
  @Query('SELECT * FROM dealerships ORDER BY id ASC')
  Future<List<Dealership>> findAllDealerships();

  /// Finds the maximum ID in the dealerships table
  ///
  /// Returns the highest ID value, or null if table is empty
  @Query('SELECT MAX(id) FROM dealerships')
  Future<int?> findMaxId();

  /// Inserts a new dealership into the database
  ///
  /// @param dealership The dealership to insert
  @insert
  Future<void> insertDealership(Dealership dealership);

  /// Updates an existing dealership in the database
  ///
  /// @param dealership The dealership to update
  @update
  Future<void> updateDealership(Dealership dealership);

  /// Deletes a dealership from the database
  ///
  /// @param dealership The dealership to delete
  @delete
  Future<void> deleteDealership(Dealership dealership);
}