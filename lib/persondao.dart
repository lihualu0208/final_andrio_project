import 'package:final_andrio_project/Person.dart';
import 'package:floor/floor.dart';
//import 'Person.dart';

@dao
abstract class persondao {
  //this performs a SQL query and returns a List of your @entity class
  @Query('SELECT * FROM Person')
  Future< List<Person>> findAllPersons();//no function body in this abstract

  //@insert
  // @insert
  // Future <void> addPerson(Person tobeInserted);
  //This performs a SQL insert operation, but you must create a unique id variable
  @insert
  Future<void> insertPerson(Person person);
  //This performs a SQL delete operation where the p.id matches that in the database
  // @delete
  // Future <void> delete(Person p);

  @update
  Future <void> updateItem(Person p);



}