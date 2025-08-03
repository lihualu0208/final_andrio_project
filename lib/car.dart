/*
 * Student Name: Viet-Quynh Nguyen
 * Lab Professor: Professor Fedor Ilitchev
 * Due Date: 08/04/2025
 * Description: 25S_CST2335_022 Final Project
 */

import 'package:floor/floor.dart';

/// Represents a car entity stored in the database.
@Entity(tableName: 'cars')
class Car {
  /// The primary key of the car (auto-generated).
  @PrimaryKey(autoGenerate: true)
  final int? id;

  /// The make (manufacturer) of the car.
  final String make;

  /// The model of the car.
  final String model;

  /// The year the car was manufactured.
  final String year;

  /// The color of the car.
  final String color;

  /// The local file path to the car's image.
  final String imagePath;

  /// Constructs a [Car] with all required fields.
  Car({
    this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.imagePath,
  });
}
