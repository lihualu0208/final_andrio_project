import 'package:floor/floor.dart';
import 'car.dart';

@dao
abstract class CarDao {
  @Query('SELECT * FROM cars')
  Future<List<Car>> getAllCars();

  @Insert()
  Future<void> insertCar(Car car);

  @Update()
  Future<void> updateCar(Car car);

  @Delete()
  Future<void> deleteCar(Car car);
}
