import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_practice/note_model.dart';

class TodoLocalDataSource {
  static Database? _database;
  final String tableName = 'todos';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  FutureOr<void> _createDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $tableName ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'title TEXT NOT NULL,'
      'description TEXT NOT NULL,'
      ' isCompleted INTEGER NOT NULL DEFAULT 0'
      ')',
    );
  }

  FutureOr<int> insertIntoTODO(TodoModel todo) async {
    final db = await database;
    return await db.insert(
      tableName,
      todo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  FutureOr<List<TodoModel>> getAllTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => TodoModel.fromJson(maps[i]));
  }

  FutureOr<TodoModel?> getTodoById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return TodoModel.fromJson(maps.first);
    }
    return null;
  }

  FutureOr<int> updateTodo(TodoModel todo) async {
    final db = await database;
    return await db.update(
      tableName,
      todo.toJson(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  FutureOr<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
