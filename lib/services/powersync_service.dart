import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import 'sqlite_database_helper.dart';

/// PowerSync service for managing offline-first data synchronization
/// Note: This is a simplified implementation for demonstration
/// In a real app, you would integrate with actual PowerSync
class PowerSyncService {
  static PowerSyncService? _instance;
  final SQLiteDatabaseHelper _dbHelper = SQLiteDatabaseHelper();
  List<Todo> _todos = [];
  bool _isConnected = false;
  
  // Stream controllers for status updates
  final StreamController<bool> _statusController = 
      StreamController<bool>.broadcast();
  final StreamController<List<Todo>> _todosController = 
      StreamController<List<Todo>>.broadcast();

  PowerSyncService._internal();

  static PowerSyncService get instance {
    _instance ??= PowerSyncService._internal();
    return _instance!;
  }

  /// Get status stream (simplified - true = connected, false = disconnected)
  Stream<bool> get statusStream => _statusController.stream;

  /// Get todos stream
  Stream<List<Todo>> get todosStream => _todosController.stream;

  /// Get current connection status
  bool get isConnected => _isConnected;

  /// Initialize PowerSync database (simplified implementation with SQLite)
  Future<void> initialize() async {
    try {
      // Initialize SQLite database
      await _dbHelper.database;
      
      // Load todos from SQLite
      _todos = await _dbHelper.getTodos();
      
      // Set up mock connection
      _isConnected = true;
      _statusController.add(true);
      
      // Notify listeners with loaded todos
      _todosController.add(_todos);

      debugPrint('PowerSync initialized successfully with SQLite storage');
      debugPrint('Loaded ${_todos.length} todos from database');
    } catch (e) {
      debugPrint('Error initializing PowerSync: $e');
      // Don't rethrow on iOS to prevent app crashes
      _isConnected = false;
      _statusController.add(false);
    }
  }

  /// Add a new todo (with SQLite persistence)
  Future<void> addTodo(Todo todo) async {
    try {
      await _dbHelper.addTodo(todo);
      _todos = await _dbHelper.getTodos();
      _todosController.add(_todos);
      debugPrint('Todo added to SQLite: ${todo.title}');
    } catch (e) {
      debugPrint('Error adding todo: $e');
    }
  }

  /// Update a todo (with SQLite persistence)
  Future<void> updateTodo(Todo todo) async {
    try {
      await _dbHelper.updateTodo(todo);
      _todos = await _dbHelper.getTodos();
      _todosController.add(_todos);
      debugPrint('Todo updated in SQLite: ${todo.title}');
    } catch (e) {
      debugPrint('Error updating todo: $e');
    }
  }

  /// Delete a todo (with SQLite persistence)
  Future<void> deleteTodo(String id) async {
    try {
      await _dbHelper.deleteTodo(id);
      _todos = await _dbHelper.getTodos();
      _todosController.add(_todos);
      debugPrint('Todo deleted from SQLite: $id');
    } catch (e) {
      debugPrint('Error deleting todo: $e');
    }
  }

  /// Get all todos (from SQLite)
  Future<List<Todo>> getTodos() async {
    try {
      return await _dbHelper.getTodos();
    } catch (e) {
      debugPrint('Error getting todos: $e');
      return [];
    }
  }

  /// Search todos (from SQLite)
  Future<List<Todo>> searchTodos(String query) async {
    try {
      return await _dbHelper.searchTodos(query);
    } catch (e) {
      debugPrint('Error searching todos: $e');
      return [];
    }
  }

  /// Close PowerSync connection
  Future<void> close() async {
    await _dbHelper.close();
    await _statusController.close();
    await _todosController.close();
    _isConnected = false;
  }
}
