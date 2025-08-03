import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'car.dart';
import 'car_dao.dart';

part 'car_database.g.dart';

@Database(version: 1, entities: [Car])
abstract class CarDatabase extends FloorDatabase {
  CarDao get carDao;
}
