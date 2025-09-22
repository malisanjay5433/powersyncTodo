import 'package:powersync/powersync.dart';

/// PowerSync schema definition for the Todo app
/// This schema represents a "view" of the downloaded data
/// No migrations are required — the schema is applied directly when the PowerSync database is constructed
const schema = Schema([
  Table('todos', [
    Column.text('title'),
    Column.text('description'),
    Column.integer('completed'),
    Column.text('created_at'),
    Column.text('updated_at'),
    Column.text('created_by'),
    Column.text('completed_by'),
  ], indexes: [
    // Index to allow efficient lookup by completion status
    Index('todos_completed', [IndexedColumn('completed')]),
    // Index to allow efficient lookup by creation date
    Index('todos_created_at', [IndexedColumn('created_at')])
  ])
]);

// /// Alternative schema with lists (if you want to extend to multiple todo lists)
// const schemaWithLists = Schema([
//   Table('todos', [
//     Column.text('list_id'),
//     Column.text('title'),
//     Column.text('description'),
//     Column.integer('completed'),
//     Column.text('created_at'),
//     Column.text('updated_at'),
//     Column.text('created_by'),
//     Column.text('completed_by'),
//   ], indexes: [
//     // Index to allow efficient lookup within a list
//     Index('todos_list_id', [IndexedColumn('list_id')]),
//     // Index to allow efficient lookup by completion status
//     Index('todos_completed', [IndexedColumn('completed')])
//   ]),
//   Table('lists', [
//     Column.text('name'),
//     Column.text('created_at'),
//     Column.text('updated_at'),
//     Column.text('owner_id')
//   ], indexes: [
//     // Index to allow efficient lookup by owner
//     Index('lists_owner_id', [IndexedColumn('owner_id')])
//   ])
// ]);
