import 'package:flutter/material.dart';
import '../powersync/powersync.dart';
import '../models/todo.dart';

/// Todos widget following PowerSync documentation pattern
/// Reference: https://docs.powersync.com/client-sdk-references/flutter#watching-queries-powersyncwatch
class TodosWidget extends StatelessWidget {
  const TodosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: db.watch('SELECT * FROM todos ORDER BY created_at DESC'),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final todos = snapshot.data!.map((row) => Todo.fromMap(row)).toList();
        
        if (todos.isEmpty) {
          return const Center(
            child: Text('No todos found. Add your first todo!'),
          );
        }

        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: todo.description != null 
                    ? Text(todo.description!)
                    : null,
                leading: Checkbox(
                  value: todo.completed,
                  onChanged: (value) => _toggleTodo(todo),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteTodo(todo.id),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _toggleTodo(Todo todo) async {
    await db.execute(
      'UPDATE todos SET completed = ?, updated_at = datetime() WHERE id = ?',
      [todo.completed ? 0 : 1, todo.id],
    );
  }

  Future<void> _deleteTodo(String id) async {
    await db.execute('DELETE FROM todos WHERE id = ?', [id]);
  }
}

/// Helper functions for todos following PowerSync documentation pattern
class TodosHelper {
  /// Find a single todo by ID
  /// Reference: https://docs.powersync.com/client-sdk-references/flutter#fetching-a-single-item
  static Future<Todo> find(String id) async {
    final result = await db.get('SELECT * FROM todos WHERE id = ?', [id]);
    return Todo.fromMap(result);
  }

  /// Get all todos
  /// Reference: https://docs.powersync.com/client-sdk-references/flutter#querying-items-powersyncgetall
  static Future<List<Todo>> getAllTodos() async {
    final results = await db.getAll('SELECT * FROM todos ORDER BY created_at DESC');
    return results.map((row) => Todo.fromMap(row)).toList();
  }

  /// Get pending todos
  static Future<List<Todo>> getPendingTodos() async {
    final results = await db.getAll('SELECT * FROM todos WHERE completed = 0 ORDER BY created_at DESC');
    return results.map((row) => Todo.fromMap(row)).toList();
  }

  /// Get completed todos
  static Future<List<Todo>> getCompletedTodos() async {
    final results = await db.getAll('SELECT * FROM todos WHERE completed = 1 ORDER BY created_at DESC');
    return results.map((row) => Todo.fromMap(row)).toList();
  }

  /// Create a new todo
  /// Reference: https://docs.powersync.com/client-sdk-references/flutter#mutations-powersyncexecute
  static Future<void> createTodo(String title, {String? description}) async {
    await db.execute(
      'INSERT INTO todos(id, title, description, completed, created_at, updated_at) VALUES(uuid(), ?, ?, 0, datetime(), datetime())',
      [title, description ?? ''],
    );
  }

  /// Update a todo
  static Future<void> updateTodo(String id, String title, {String? description}) async {
    await db.execute(
      'UPDATE todos SET title = ?, description = ?, updated_at = datetime() WHERE id = ?',
      [title, description ?? '', id],
    );
  }

  /// Toggle todo completion
  static Future<void> toggleTodo(String id) async {
    await db.execute(
      'UPDATE todos SET completed = NOT completed, updated_at = datetime() WHERE id = ?',
      [id],
    );
  }

  /// Delete a todo
  static Future<void> deleteTodo(String id) async {
    await db.execute('DELETE FROM todos WHERE id = ?', [id]);
  }
}
