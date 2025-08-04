import 'package:floor/floor.dart';

/// Represents a single sales record in the database.
/// This entity stores the essential information about a sale,
/// including customer ID, car ID, dealer ID, sale date, and a title/label.
///
/// The [recordID] is the primary key, and [ID] is used to auto-increment
/// future records at runtime.
/// This class is used with the Floor persistence library.
@entity
class SalesRecords{
  /// Constructs a [SalesRecords] object and updates the static [ID]
  /// if this record's ID is higher than the current value.
  SalesRecords(this.recordID, this.title, this.custID, this.carID, this.dealerID, this.date){
    if(this.recordID >= ID)
      ID = this.recordID+1;
  }

  /// Global static auto-incrementing ID used for inserting new records manually.
  static int ID = 1;

  /// Primary key of the sales record.
  @primaryKey
  final int recordID;

  /// Title or description of the sale.
  String title;
  /// ID of the customer involved in the sale.
  int custID;
  /// ID of the car being sold.
  int carID;
  /// ID of the dealership handling the sale.
  int dealerID;
  /// Date of the sale (formatted as a string).
  String date;
}