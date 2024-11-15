import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'todo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE todos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT,
  isCompleted INTEGER NOT NULL
)
''');
  }

  Future<List<Todo>> getTodos() async {
    final db = await instance.database;
    final todos = await db.query('todos');
    return todos.map((json) => Todo.fromJson(json)).toList();
  }

  Future<int> addTodoItem(Todo todo) async {
    final db = await instance.database;
    return await db.insert('todos', todo.toJson());
  }

  Future<int> updateTodoItem(Todo todo) async {
    final db = await instance.database;
    return await db.update(
      'todos',
      todo.toJson(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> deleteTodoItem(int id) async {
    final db = await instance.database;
    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCompletedTodos() async {
    final db = await instance.database;
    return await db.delete(
      'todos',
      where: 'isCompleted = ?',
      whereArgs: [1],
    );
  }
}
