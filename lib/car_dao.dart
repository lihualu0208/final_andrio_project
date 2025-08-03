/*
 * Student Name: Viet-Quynh Nguyen
 * Lab Professor: Professor Fedor Ilitchev
 * Due Date: 08/04/2025
 * Description: 25S_CST2335_022 Final Project
 */

import 'package:floor/floor.dart';
import 'car.dart';

/// Data Access Object (DAO) for managing Car-related database operations.
@dao
abstract class CarDao {
  /// Retrieves all cars stored in the database.
  ///
  /// Returns a [Future] that completes with a list of [Car] objects.
  @Query('SELECT * FROM cars')
  Future<List<Car>> getAllCars();

  /// Inserts a new car into the database.
  ///
  /// Takes a [Car] object and inserts it into the `cars` table.
  @insert
  Future<void> insertCar(Car car);

  /// Updates an existing car in the database.
  ///
  /// Takes a [Car] object and updates its data in the `cars` table.
  @update
  Future<void> updateCar(Car car);

  /// Deletes a car from the database.
  ///
  /// Takes a [Car] object and removes it from the `cars` table.
  @delete
  Future<void> deleteCar(Car car);
}
