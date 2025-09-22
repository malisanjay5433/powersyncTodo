import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo.dart';

/// SQLite database helper for persistent storage
class SQLiteDatabaseHelper {
  static final SQLiteDatabaseHelper _instance = SQLiteDatabaseHelper._internal();
  static Database? _database;

  SQLiteDatabaseHelper._internal();

  factory SQLiteDatabaseHelper() => _instance;

  /// Get database instance
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'todos.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        completed INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  /// Add a new todo
  Future<void> addTodo(Todo todo) async {
    final db = await database;
    await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all todos
  Future<List<Todo>> getTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      orderBy: 'updated_at DESC',
    );

    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  /// Update a todo
  Future<void> updateTodo(Todo todo) async {
    final db = await database;
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  /// Delete a todo
  Future<void> deleteTodo(String id) async {
    final db = await database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Search todos
  Future<List<Todo>> searchTodos(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'updated_at DESC',
    );

    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  /// Clear all completed todos
  Future<void> clearCompleted() async {
    final db = await database;
    await db.delete(
      'todos',
      where: 'completed = ?',
      whereArgs: [1],
    );
  }

  /// Get completed todos count
  Future<int> getCompletedCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM todos WHERE completed = 1');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get pending todos count
  Future<int> getPendingCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM todos WHERE completed = 0');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Close database
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
