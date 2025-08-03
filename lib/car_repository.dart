import 'car.dart';
import 'car_dao.dart';

class CarRepository {
  final CarDao _dao;
  CarRepository(this._dao);

  Future<List<Car>> getAllCars() => _dao.findAllCars();
  Future<void> insertCar(Car car) async => _dao.insertCar(car);
  Future<void> updateCar(Car car) async => _dao.updateCar(car);
  Future<void> deleteCar(Car car) async => _dao.deleteCar(car);
  Future<Car?> getCar(int id) => _dao.findCarById(id);
}
