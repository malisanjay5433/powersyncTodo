import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/todo_provider.dart';
import 'screens/todo_list_screen.dart';
import 'services/sqlite_database_helper.dart';
import 'models/todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Add error handling for iOS
  try {
    runApp(const PowerSyncTodoApp());
  } catch (e) {
    debugPrint('Error starting app: $e');
    // Fallback to simple app if PowerSync fails
    runApp(const FallbackTodoApp());
  }
}

/// Main application widget with PowerSync
class PowerSyncTodoApp extends StatelessWidget {
  const PowerSyncTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider()..initialize(),
      child: MaterialApp(
        title: 'PowerSync Todo',
        debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
        useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        home: const TodoListScreen(),
      ),
    );
  }
}

/// Fallback app without PowerSync for iOS compatibility
class FallbackTodoApp extends StatelessWidget {
  const FallbackTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SimpleTodoProvider()..loadTodos(),
      child: MaterialApp(
        title: 'Simple Todo (Fallback)',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        home: const TodoListScreen(),
      ),
    );
  }
}

/// Simple TodoProvider without PowerSync for fallback
class SimpleTodoProvider with ChangeNotifier {
  final SQLiteDatabaseHelper _storage = SQLiteDatabaseHelper();
  List<Todo> _todos = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  bool get isConnected => false; // Always false for fallback

  List<Todo> get filteredTodos {
    if (_searchQuery.isEmpty) {
      return _todos;
    }
    // For now, filter locally. In a real app, you'd call _storage.searchTodos(_searchQuery)
    return _todos.where((todo) =>
        todo.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (todo.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
    ).toList();
  }

  int get completedCount => _todos.where((todo) => todo.completed).length;
  int get pendingCount => _todos.where((todo) => !todo.completed).length;

  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _todos = await _storage.getTodos();
    } catch (e) {
      debugPrint('Error loading todos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTodo(String title, {String? description}) async {
    if (title.trim().isEmpty) return;

    final todo = Todo.create(
      title: title.trim(),
      description: description?.trim(),
    );

    try {
      await _storage.addTodo(todo);
      _todos = await _storage.getTodos();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding todo: $e');
    }
  }

  Future<void> toggleTodo(String id) async {
    final todoIndex = _todos.indexWhere((todo) => todo.id == id);
    if (todoIndex == -1) return;

    final todo = _todos[todoIndex];
    final updatedTodo = todo.copyWith(
      completed: !todo.completed,
      updatedAt: DateTime.now(),
    );

    try {
      await _storage.updateTodo(updatedTodo);
      _todos = await _storage.getTodos();
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling todo: $e');
    }
  }

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
      await _storage.updateTodo(updatedTodo);
      _todos = await _storage.getTodos();
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating todo: $e');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _storage.deleteTodo(id);
      _todos = await _storage.getTodos();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting todo: $e');
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  Future<void> clearCompleted() async {
    try {
      await _storage.clearCompleted();
      _todos = await _storage.getTodos();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing completed todos: $e');
    }
  }
}
