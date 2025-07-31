import 'package:floor/floor.dart';
import 'package:my_flutter_labs/SalesRecords.dart';


@dao
abstract class SalesRecordsDAO{

  @Query("Select * from SalesRecords")
  Future<List<SalesRecords>> getRecords();

  @insert
  Future<void> addSalesRecord(SalesRecords record);

  @update
  Future<void> updateSalesRecord(SalesRecords record);

  @delete
  Future<void> removeSalesRecord(SalesRecords record);

}