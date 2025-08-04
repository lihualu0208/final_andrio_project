/**
 * The floor database definition for the dealership management app.
 * Defines the database version and entities.
 */
// dealership_database.dart
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dealership_dao.dart';
import 'car_dealership.dart';

part 'app_database.g.dart';

/// The main database class annotated with @Database
@Database(version: 1, entities: [Dealership])
abstract class AppDatabase extends FloorDatabase {
  /// Provides access to the dealership DAO
  DealershipDao get dealershipDao;
}