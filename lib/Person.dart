import 'package:floor/floor.dart';
@entity
@entity
class Person {
  //CONSTRUCT
  Person(this.id,this.name);// ID HERE NAME HERE
  static int ID=1;
  @primaryKey
  final int id;

  final String name;

//  Person(this.id, this.name);
}