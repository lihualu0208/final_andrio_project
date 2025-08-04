import 'package:floor/floor.dart';
import 'dart:async';
import 'SalesRecords.dart';
import 'SalesRecordsDAO.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


part 'SalesDatabase.g.dart';

/// The main database class for the Sales module.
///
/// This class defines the structure of the database using the `floor` package,
/// and exposes the DAO for performing CRUD operations on [SalesRecords].
///
/// The `SalesDatabase` is built using `FloorDatabase`, and includes a
/// single table defined by the [SalesRecords] entity.
@Database(version: 1, entities: [SalesRecords])
abstract class SalesDatabase extends FloorDatabase{
  /// Provides access to [SalesRecordsDAO] for interacting with the sales records table.
  SalesRecordsDAO get getDAO;
}