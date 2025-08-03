import 'package:floor/floor.dart';

@Entity(tableName: 'cars')
class Car {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String make;
  final String model;
  final String year;
  final String color;
  final String imagePath;

  Car({this.id, required this.make, required this.model, required this.year, required this.color, required this.imagePath});
}