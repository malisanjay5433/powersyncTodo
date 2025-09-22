import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:powersync/powersync.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../config/powersync_config.dart';
import '../models/todo.dart';

/// Real PowerSync service implementation
/// Replace the simplified service with this when you have PowerSync credentials
class RealPowerSyncService {
  static RealPowerSyncService? _instance;
  PowerSyncDatabase? _database;
  PowerSyncBackendConnector? _connector;
  
  // Stream controllers for status updates
  final StreamController<SyncStatus> _statusController = 
      StreamController<SyncStatus>.broadcast();
  final StreamController<List<Todo>> _todosController = 
      StreamController<List<Todo>>.broadcast();

  RealPowerSyncService._internal();

  static RealPowerSyncService get instance {
    _instance ??= RealPowerSyncService._internal();
    return _instance!;
  }

  /// Get the PowerSync database
  PowerSyncDatabase? get database => _database;

  /// Get status stream
  Stream<SyncStatus> get statusStream => _statusController.stream;

  /// Get todos stream
  Stream<List<Todo>> get todosStream => _todosController.stream;

  /// Get current connection status
  bool get isConnected => _database != null;

  /// Initialize PowerSync database
  Future<void> initialize() async {
    try {
      // Get the database directory
      final documentsDir = await getApplicationDocumentsDirectory();
      final dbPath = path.join(documentsDir.path, '${PowerSyncConfig.databaseName}.db');
      
      // Create schema
      const schema = Schema([
        Table('todos', [
          Column.text('id'),
          Column.text('title'),
          Column.text('description'),
          Column.integer('completed'),
          Column.text('created_at'),
          Column.text('updated_at'),
        ])
      ]);

      // Open PowerSync database
      _database = PowerSyncDatabase(
        schema: schema,
        path: dbPath,
      );

      // Set up backend connector
      _connector = _TodoBackendConnector();

      // Connect to PowerSync
      await _database!.connect(connector: _connector!);

      // Listen to status changes
      _database!.statusStream.listen((status) {
        _statusController.add(status);
      });

      // Listen to todos changes
      _database!.watch('SELECT * FROM todos ORDER BY updated_at DESC').listen((results) {
        final todos = results.map((row) => _mapRowToTodo(row)).toList();
        _todosController.add(todos);
      });

      debugPrint('PowerSync initialized successfully');
    } catch (e) {
      debugPrint('Error initializing PowerSync: $e');
      rethrow;
    }
  }

  /// Add a new todo
  Future<void> addTodo(Todo todo) async {
    if (_database == null) return;

    await _database!.execute('''
      INSERT INTO todos (id, title, description, completed, created_at, updated_at)
      VALUES (?, ?, ?, ?, ?, ?)
    ''', [
      todo.id,
      todo.title,
      todo.description,
      todo.completed ? 1 : 0,
      todo.createdAt.toIso8601String(),
      todo.updatedAt.toIso8601String(),
    ]);
  }

  /// Update a todo
  Future<void> updateTodo(Todo todo) async {
    if (_database == null) return;

    await _database!.execute('''
      UPDATE todos 
      SET title = ?, description = ?, completed = ?, updated_at = ?
      WHERE id = ?
    ''', [
      todo.title,
      todo.description,
      todo.completed ? 1 : 0,
      todo.updatedAt.toIso8601String(),
      todo.id,
    ]);
  }

  /// Delete a todo
  Future<void> deleteTodo(String id) async {
    if (_database == null) return;

    await _database!.execute('DELETE FROM todos WHERE id = ?', [id]);
  }

  /// Get all todos
  Future<List<Todo>> getTodos() async {
    if (_database == null) return [];

    final results = await _database!.getAll('SELECT * FROM todos ORDER BY updated_at DESC');
    return results.map((row) => _mapRowToTodo(row)).toList();
  }

  /// Search todos
  Future<List<Todo>> searchTodos(String query) async {
    if (_database == null) return [];

    final results = await _database!.getAll('''
      SELECT * FROM todos 
      WHERE (title LIKE ? OR description LIKE ?) 
      ORDER BY updated_at DESC
    ''', ['%$query%', '%$query%']);

    return results.map((row) => _mapRowToTodo(row)).toList();
  }

  /// Map database row to Todo model
  Todo _mapRowToTodo(Map<String, dynamic> row) {
    return Todo(
      id: row['id'] as String,
      title: row['title'] as String,
      description: row['description'] as String?,
      completed: (row['completed'] as int) == 1,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  /// Close PowerSync connection
  Future<void> close() async {
    await _database?.close();
    await _statusController.close();
    await _todosController.close();
    _database = null;
    _connector = null;
  }
}

/// Backend connector for PowerSync
class _TodoBackendConnector extends PowerSyncBackendConnector {
  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    // TODO: Implement actual authentication
    // In a real app, you would fetch credentials from your authentication service
    return PowerSyncCredentials(
      endpoint: PowerSyncConfig.endpoint,
      token: PowerSyncConfig.token,
    );
  }

  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    // Handle uploading local changes to your backend
    final batch = await database.getCrudBatch();
    if (batch == null) return;

    try {
      // Process each CRUD operation
      for (var op in batch.crud) {
        switch (op.op) {
          case UpdateType.put:
            await _handleCreate(op);
            break;
          case UpdateType.patch:
            await _handleUpdate(op);
            break;
          case UpdateType.delete:
            await _handleDelete(op);
            break;
        }
      }

      // Mark batch as complete
      await batch.complete();
    } catch (e) {
      debugPrint('Error uploading data: $e');
      // In a real app, you might want to retry or handle the error differently
      await batch.complete();
    }
  }

  Future<void> _handleCreate(CrudEntry op) async {
    // TODO: Implement actual backend API call for creating todos
    debugPrint('Creating todo: ${op.opData}');
    // Example: await http.post('https://your-api.com/todos', body: op.opData);
  }

  Future<void> _handleUpdate(CrudEntry op) async {
    // TODO: Implement actual backend API call for updating todos
    debugPrint('Updating todo: ${op.opData}');
    // Example: await http.put('https://your-api.com/todos/${op.opData.id}', body: op.opData);
  }

  Future<void> _handleDelete(CrudEntry op) async {
    // TODO: Implement actual backend API call for deleting todos
    debugPrint('Deleting todo: ${op.opData}');
    // Example: await http.delete('https://your-api.com/todos/${op.opData.id}');
  }
}
