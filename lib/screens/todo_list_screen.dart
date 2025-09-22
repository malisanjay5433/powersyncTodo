import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../models/todo.dart';
import 'add_todo_screen.dart';

/// Main screen displaying the list of todos
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PowerSync Todo'),
        actions: [
          // Sync status indicator
          Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: _buildSyncStatusIndicator(todoProvider.isConnected),
              );
            },
          ),
          Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'clear_completed') {
                    _clearCompleted(todoProvider);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'clear_completed',
                    child: Row(
                      children: [
                        Icon(Icons.clear_all),
                        SizedBox(width: 8),
                        Text('Clear Completed'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                return TextField(
                  onChanged: todoProvider.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search todos...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: todoProvider.searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: todoProvider.clearSearch,
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          
          // Stats
          Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      'Total',
                      todoProvider.todos.length.toString(),
                      Colors.blue,
                    ),
                    _buildStatCard(
                      'Pending',
                      todoProvider.pendingCount.toString(),
                      Colors.orange,
                    ),
                    _buildStatCard(
                      'Completed',
                      todoProvider.completedCount.toString(),
                      Colors.green,
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 16),
          
          // Todo list
          Expanded(
            child: Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                if (todoProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final todos = todoProvider.filteredTodos;
                
                if (todos.isEmpty) {
                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Icon(
                          Icons.task_alt,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          todoProvider.searchQuery.isNotEmpty 
                              ? 'No todos found' 
                              : 'No todos yet',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          todoProvider.searchQuery.isNotEmpty
                              ? 'Try a different search term'
                              : 'Tap the + button to add your first todo',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return _buildTodoItem(todo, todoProvider);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTodo(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoItem(Todo todo, TodoProvider todoProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: todo.completed,
          onChanged: (value) => todoProvider.toggleTodo(todo.id),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
            color: todo.completed ? Colors.grey[600] : null,
          ),
        ),
        subtitle: todo.description != null && todo.description!.isNotEmpty
            ? Text(
                todo.description!,
                style: TextStyle(
                  decoration: todo.completed ? TextDecoration.lineThrough : null,
                  color: todo.completed ? Colors.grey[500] : null,
                ),
              )
            : null,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _editTodo(todo, todoProvider);
            } else if (value == 'delete') {
              _deleteTodo(todo, todoProvider);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddTodo() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddTodoScreen(),
      ),
    );
  }

  void _editTodo(Todo todo, TodoProvider todoProvider) {
    showDialog(
      context: context,
      builder: (context) => _EditTodoDialog(todo: todo),
    );
  }

  void _deleteTodo(Todo todo, TodoProvider todoProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete "${todo.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              todoProvider.deleteTodo(todo.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Todo "${todo.title}" deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _clearCompleted(TodoProvider todoProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Completed'),
        content: const Text('Are you sure you want to clear all completed todos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              todoProvider.clearCompleted();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Completed todos cleared'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  /// Build sync status indicator
  Widget _buildSyncStatusIndicator(bool isConnected) {
    final color = isConnected ? Colors.green : Colors.red;
    final icon = isConnected ? Icons.cloud_done : Icons.cloud_off;
    final tooltip = isConnected ? 'Connected and synced' : 'Disconnected';

    return Tooltip(
      message: tooltip,
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
}

/// Dialog for editing todos
class _EditTodoDialog extends StatefulWidget {
  final Todo todo;

  const _EditTodoDialog({required this.todo});

  @override
  State<_EditTodoDialog> createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<_EditTodoDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(text: widget.todo.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_titleController.text.trim().isNotEmpty) {
              context.read<TodoProvider>().updateTodo(
                widget.todo.id,
                _titleController.text.trim(),
                description: _descriptionController.text.trim().isEmpty 
                    ? null 
                    : _descriptionController.text.trim(),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
