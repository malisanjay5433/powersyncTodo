import 'package:flutter/material.dart';
import '../powersync/powersync.dart';
import '../models/todolist.dart';

/// Lists widget following PowerSync documentation pattern
/// Reference: https://docs.powersync.com/client-sdk-references/flutter#fetching-a-single-item
class ListsWidget extends StatelessWidget {
  const ListsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: db.watch('SELECT * FROM lists ORDER BY created_at DESC'),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final lists = snapshot.data!.map((row) => TodoList.fromRow(row)).toList();
        
        if (lists.isEmpty) {
          return const Center(
            child: Text('No lists found. Create your first list!'),
          );
        }

        return ListView.builder(
          itemCount: lists.length,
          itemBuilder: (context, index) {
            final list = lists[index];
            return ListTile(
              title: Text(list.name),
              subtitle: Text('Created: ${_formatDate(list.createdAt)}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteList(list.id),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _deleteList(String id) async {
    await db.execute('DELETE FROM lists WHERE id = ?', [id]);
  }
}

/// Helper functions for lists following PowerSync documentation pattern
class ListsHelper {
  /// Find a single list by ID
  /// Reference: https://docs.powersync.com/client-sdk-references/flutter#fetching-a-single-item
  static Future<TodoList> find(String id) async {
    final result = await db.get('SELECT * FROM lists WHERE id = ?', [id]);
    return TodoList.fromRow(result);
  }

  /// Get all list IDs
  /// Reference: https://docs.powersync.com/client-sdk-references/flutter#querying-items-powersyncgetall
  static Future<List<String>> getListIds() async {
    final results = await db.getAll('SELECT id FROM lists WHERE id IS NOT NULL');
    return results.map((row) => row['id'] as String).toList();
  }

  /// Create a new list
  static Future<void> createList(String name, String ownerId) async {
    await db.execute(
      'INSERT INTO lists(id, name, created_at, updated_at, owner_id) VALUES(uuid(), ?, datetime(), datetime(), ?)',
      [name, ownerId],
    );
  }
}
