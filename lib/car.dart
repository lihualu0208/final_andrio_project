import 'package:floor/floor.dart';

@Entity(tableName: 'cars')
class Car {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String make;
  final String model;
  final String year;
  final String color;

  Car({this.id, required this.make, required this.model, required this.year, required this.color});
}
