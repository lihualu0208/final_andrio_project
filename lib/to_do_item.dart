// lib/to_do_item.dart
import 'package:floor/floor.dart';

//annotation @Entity indicates ToDoItem objects can be stored into SQLite table
@Entity(tableName: 'todo_items')
class ToDoItem {
  @primaryKey final int id;
  final String name;
  final int quantity;

  ToDoItem({required this.id, required this.name, required this.quantity});

  // A static currentId counter is maintained to assign unique IDs to new items.
  static int currentId = 1;

  @override
  String toString() {
    return 'ToDoItem{id: $id, name: $name, quantity: $quantity}';
  }
}