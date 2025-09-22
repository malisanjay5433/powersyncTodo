import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../services/powersync_service.dart';

/// TodoProvider using PowerSync for offline-first data management
class TodoProvider with ChangeNotifier {
  final PowerSyncService _powerSyncService = PowerSyncService.instance;
  List<Todo> _todos = [];
  bool _isLoading = false;
  String _searchQuery = '';
  bool _isConnected = false;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  bool get isConnected => _isConnected;

  /// Get filtered todos based on search query
  List<Todo> get filteredTodos {
    if (_searchQuery.isEmpty) {
      return _todos;
    }
    return _todos.where((todo) =>
        todo.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (todo.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
    ).toList();
  }

  /// Get completed todos count
  int get completedCount => _todos.where((todo) => todo.completed).length;

  /// Get pending todos count
  int get pendingCount => _todos.where((todo) => !todo.completed).length;

  /// Initialize PowerSync and load todos
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Initialize PowerSync
      await _powerSyncService.initialize();

      // Listen to PowerSync status changes
      _powerSyncService.statusStream.listen((connected) {
        _isConnected = connected;
        notifyListeners();
      });

      // Listen to todos changes from PowerSync
      _powerSyncService.todosStream.listen((todos) {
        _todos = todos;
        notifyListeners();
      });

      // Load initial todos
      _todos = await _powerSyncService.getTodos();
    } catch (e) {
      debugPrint('Error initializing PowerSync: $e');
      // Set fallback state for iOS
      _isConnected = false;
      _todos = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new todo
  Future<void> addTodo(String title, {String? description}) async {
    if (title.trim().isEmpty) return;

    final todo = Todo.create(
      title: title.trim(),
      description: description?.trim(),
    );

    try {
      await _powerSyncService.addTodo(todo);
      // Todos will be updated automatically via the stream
    } catch (e) {
      debugPrint('Error adding todo: $e');
    }
  }

  /// Toggle todo completion status
  Future<void> toggleTodo(String id) async {
    final todoIndex = _todos.indexWhere((todo) => todo.id == id);
    if (todoIndex == -1) return;

    final todo = _todos[todoIndex];
    final updatedTodo = todo.copyWith(
      completed: !todo.completed,
      updatedAt: DateTime.now(),
    );

    try {
      await _powerSyncService.updateTodo(updatedTodo);
      // Todos will be updated automatically via the stream
    } catch (e) {
      debugPrint('Error toggling todo: $e');
    }
  }

  /// Update todo title and description
  Future<void> updateTodo(String id, String title, {String? description}) async {
    if (title.trim().isEmpty) return;

    final todoIndex = _todos.indexWhere((todo) => todo.id == id);
    if (todoIndex == -1) return;

    final todo = _todos[todoIndex];
    final updatedTodo = todo.copyWith(
      title: title.trim(),
      description: description?.trim(),
      updatedAt: DateTime.now(),
    );

    try {
      await _powerSyncService.updateTodo(updatedTodo);
      // Todos will be updated automatically via the stream
    } catch (e) {
      debugPrint('Error updating todo: $e');
    }
  }

  /// Delete a todo
  Future<void> deleteTodo(String id) async {
    try {
      await _powerSyncService.deleteTodo(id);
      // Todos will be updated automatically via the stream
    } catch (e) {
      debugPrint('Error deleting todo: $e');
    }
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Clear search query
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  /// Clear all completed todos
  Future<void> clearCompleted() async {
    try {
      final completedTodos = _todos.where((todo) => todo.completed).toList();
      for (final todo in completedTodos) {
        await _powerSyncService.deleteTodo(todo.id);
      }
      // Todos will be updated automatically via the stream
    } catch (e) {
      debugPrint('Error clearing completed todos: $e');
    }
  }

  /// Dispose resources
  @override
  void dispose() {
    _powerSyncService.close();
    super.dispose();
  }
}
