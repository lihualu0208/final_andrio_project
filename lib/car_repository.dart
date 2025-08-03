/*
 * Student Name: Viet-Quynh Nguyen
 * Lab Professor: Professor Fedor Ilitchev
 * Due Date: 08/04/2025
 * Description: 25S_CST2335_022 Final Project
 */

import 'car.dart';
import 'car_dao.dart';

/// A repository class that provides an abstraction layer between the database DAO and UI.
///
/// This class acts as an intermediary between the [CarDao] and the rest of the app.
/// It is used to simplify access to CRUD operations for `Car` objects.
class CarRepository {
  /// The Data Access Object for performing database operations.
  final CarDao _dao;

  /// Creates a [CarRepository] with the given [CarDao].
  CarRepository(this._dao);

  /// Retrieves all cars from the database.
  ///
  /// Returns a [Future] containing a list of [Car] objects.
  Future<List<Car>> getAllCars() => _dao.getAllCars();

  /// Inserts a new [car] into the database.
  ///
  /// Returns a [Future] that completes when the operation is done.
  Future<void> insertCar(Car car) => _dao.insertCar(car);

  /// Updates an existing [car] in the database.
  ///
  /// Returns a [Future] that completes when the operation is done.
  Future<void> updateCar(Car car) => _dao.updateCar(car);

  /// Deletes a [car] from the database.
  ///
  /// Returns a [Future] that completes when the operation is done.
  Future<void> deleteCar(Car car) => _dao.deleteCar(car);
}
