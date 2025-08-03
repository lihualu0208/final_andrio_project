import 'package:floor/floor.dart';
import 'car.dart';

@dao
abstract class CarDao {
  @Query('SELECT * FROM cars')
  Future<List<Car>> findAllCars();

  @Query('SELECT * FROM cars WHERE id = :id')
  Future<Car?> findCarById(int id);

  @insert
  Future<int> insertCar(Car car);

  @update
  Future<int> updateCar(Car car);

  @delete
  Future<int> deleteCar(Car car);
}
