/*
 * Student Name: Viet-Quynh Nguyen
 * Lab Professor: Professor Fedor Ilitchev
 * Due Date: 08/04/2025
 * Description: 25S_CST2335_022 Final Project
 */

import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'car.dart';
import 'car_dao.dart';

part 'car_database.g.dart';

/// The database class for managing car records using the Floor ORM.
///
/// This class defines the schema version and the list of entities used.
/// It also provides an instance of [CarDao] to interact with the database.
@Database(version: 1, entities: [Car])
abstract class CarDatabase extends FloorDatabase {
  /// Returns an instance of the [CarDao] to perform CRUD operations.
  CarDao get carDao;
}
