import 'package:floor/floor.dart';
import 'dart:async';
import 'SalesRecords.dart';
import 'SalesRecordsDAO.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


part 'SalesDatabase.g.dart';

@Database(version: 1, entities: [SalesRecords])
abstract class SalesDatabase extends FloorDatabase{
  SalesRecordsDAO get getDAO;
}