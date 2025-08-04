import 'package:floor/floor.dart';
import 'SalesRecords.dart';

/// Data Access Object (DAO) for performing database operations on [SalesRecords].
///
/// This abstract class defines methods for interacting with the `SalesRecords`
/// table using Floor's annotations. The implementation is generated automatically
/// by Floor at build time.
@dao
abstract class SalesRecordsDAO{
  /// Retrieves all sales records from the database.
  ///
  /// Returns a list of [SalesRecords] objects.
  @Query("Select * from SalesRecords")
  Future<List<SalesRecords>> getRecords();

  /// Inserts a new sales record into the database.
  ///
  /// The [record] must have a unique primary key ([SalesRecords.recordID]).
  @insert
  Future<void> addSalesRecord(SalesRecords record);

  /// Updates an existing sales record in the database.
  ///
  /// The [record] is matched using its primary key.
  @update
  Future<void> updateSalesRecord(SalesRecords record);

  /// Deletes a sales record from the database.
  ///
  /// The [record] is matched using its primary key.
  @delete
  Future<void> removeSalesRecord(SalesRecords record);

}