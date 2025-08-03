import 'car.dart';
import 'car_dao.dart';

class CarRepository {
  final CarDao _dao;

  CarRepository(this._dao);

  Future<List<Car>> getAllCars() => _dao.getAllCars();

  Future<void> insertCar(Car car) => _dao.insertCar(car);

  Future<void> updateCar(Car car) => _dao.updateCar(car);

  Future<void> deleteCar(Car car) => _dao.deleteCar(car);
}
