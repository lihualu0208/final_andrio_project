import 'package:floor/floor.dart';
import 'car.dart';

@dao
abstract class CarDao {
  @Query('SELECT * FROM cars')
  Future<List<Car>> getAllCars();

  @insert
  Future<void> insertCar(Car car);

  @update
  Future<void> updateCar(Car car);

  @delete
  Future<void> deleteCar(Car car);
}
