import '../models/todo.dart';

/// Simple in-memory storage for todos
/// This works on all platforms without database setup issues
class TodoStorage {
  static final TodoStorage _instance = TodoStorage._internal();
  static final List<Todo> _todos = [];

  TodoStorage._internal();

  factory TodoStorage() => _instance;

  /// Get all todos
  List<Todo> getTodos() {
    return List.from(_todos);
  }

  /// Add a new todo
  void addTodo(Todo todo) {
    _todos.insert(0, todo);
  }

  /// Update an existing todo
  void updateTodo(Todo todo) {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
    }
  }

  /// Delete a todo
  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
  }

  /// Clear all completed todos
  void clearCompleted() {
    _todos.removeWhere((todo) => todo.completed);
  }

  /// Search todos by query
  List<Todo> searchTodos(String query) {
    if (query.isEmpty) return _todos;
    
    return _todos.where((todo) =>
        todo.title.toLowerCase().contains(query.toLowerCase()) ||
        (todo.description?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }
}
