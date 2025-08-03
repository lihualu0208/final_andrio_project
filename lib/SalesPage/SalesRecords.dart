import 'package:floor/floor.dart';


@entity
class SalesRecords{
  SalesRecords(this.recordID, this.title, this.custID, this.carID, this.dealerID, this.date){
    if(this.recordID >= ID)
      ID = this.recordID+1;
  }

  static int ID = 1;

  @primaryKey
  final int recordID;

  String title;
  int custID;
  int carID;
  int dealerID;
  String date;



}