
import 'package:floor/floor.dart';


// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'persondao.dart';
import 'Person.dart';

part 'persondatabase.g.dart'; // the generated code will be there

@Database(version:1,entities: [Person] )
abstract class persondatabase extends FloorDatabase{
//create function return a dao object;

persondao get getDao;//get generate this  fuction  as a getter;

}