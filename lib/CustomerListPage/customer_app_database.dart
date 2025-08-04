/// customer_app_database.dart
/// The main database class for the Customer Management application.
///
/// This abstract class extends `FloorDatabase` and defines the database version
/// and entities. It provides access to the DAO (Data Access Object) for
/// customer operations.
///
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'customer_dao.dart';
import 'customer.dart';

part 'customer_app_database.g.dart';

@Database(version: 1, entities: [Customer])
abstract class CustomerAppDatabase extends FloorDatabase {
  /// Provides access to the Customer Data Access Object (DAO).
  CustomerDao get customerDao;
}