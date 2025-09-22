# PowerSync Todo App - API Documentation

## Overview

This document provides comprehensive API documentation for the PowerSync Todo application, including all functions, classes, and their usage patterns.

## Core Services

### PowerSyncService

The main service for managing PowerSync integration and local database operations.

#### Methods

##### `static PowerSyncService get instance`
- **Description**: Returns the singleton instance of PowerSyncService
- **Returns**: `PowerSyncService`
- **Usage**: `PowerSyncService.instance`

##### `Future<Database> get database`
- **Description**: Gets the SQLite database instance
- **Returns**: `Future<Database>`
- **Usage**: `await powerSyncService.database`

##### `Stream<String> get syncStatusStream`
- **Description**: Stream of sync status changes
- **Returns**: `Stream<String>`
- **Usage**: `powerSyncService.syncStatusStream.listen((status) => ...)`

##### `String get currentSyncStatus`
- **Description**: Current sync status
- **Returns**: `String`
- **Possible Values**: 'connected', 'syncing', 'disconnected'

##### `Future<void> startSync()`
- **Description**: Starts PowerSync connection and synchronization
- **Returns**: `Future<void>`
- **Usage**: `await powerSyncService.startSync()`

##### `Future<void> stopSync()`
- **Description**: Stops PowerSync connection
- **Returns**: `Future<void>`
- **Usage**: `await powerSyncService.stopSync()`

##### `bool get isSyncing`
- **Description**: Checks if sync is currently active
- **Returns**: `bool`

##### `bool get isConnected`
- **Description**: Checks if connected to sync service
- **Returns**: `bool`

## Domain Layer

### Todo Entity

Core business entity representing a todo item.

#### Properties

- `String id` - Unique identifier
- `String title` - Todo title
- `String? description` - Optional description
- `bool completed` - Completion status
- `DateTime createdAt` - Creation timestamp
- `DateTime updatedAt` - Last update timestamp
- `String? userId` - Associated user ID
- `bool deleted` - Soft delete flag

#### Factory Methods

##### `Todo.create({required String title, String? description, String? userId})`
- **Description**: Creates a new Todo with generated ID and timestamps
- **Parameters**:
  - `title` (required): Todo title
  - `description` (optional): Todo description
  - `userId` (optional): User ID
- **Returns**: `Todo`
- **Usage**: `Todo.create(title: 'Buy milk', description: 'From the store')`

#### Instance Methods

##### `Todo markCompleted()`
- **Description**: Marks todo as completed
- **Returns**: `Todo` - Updated todo instance
- **Usage**: `todo.markCompleted()`

##### `Todo markIncomplete()`
- **Description**: Marks todo as incomplete
- **Returns**: `Todo` - Updated todo instance
- **Usage**: `todo.markIncomplete()`

##### `Todo updateContent({String? title, String? description})`
- **Description**: Updates todo content
- **Parameters**:
  - `title` (optional): New title
  - `description` (optional): New description
- **Returns**: `Todo` - Updated todo instance
- **Usage**: `todo.updateContent(title: 'New title')`

##### `Todo markDeleted()`
- **Description**: Marks todo as deleted (soft delete)
- **Returns**: `Todo` - Updated todo instance
- **Usage**: `todo.markDeleted()`

### Repository Interface

Abstract interface for todo data operations.

#### Methods

##### `Stream<List<Todo>> watchTodos({String? userId})`
- **Description**: Watches all todos for changes
- **Parameters**:
  - `userId` (optional): Filter by user ID
- **Returns**: `Stream<List<Todo>>` - Stream of todo lists
- **Usage**: `repository.watchTodos(userId: 'user123')`

##### `Future<Todo?> getTodoById(String id)`
- **Description**: Gets a specific todo by ID
- **Parameters**:
  - `id`: Todo ID
- **Returns**: `Future<Todo?>` - Todo or null if not found
- **Usage**: `await repository.getTodoById('todo123')`

##### `Future<Todo> createTodo(Todo todo)`
- **Description**: Creates a new todo
- **Parameters**:
  - `todo`: Todo entity to create
- **Returns**: `Future<Todo>` - Created todo
- **Usage**: `await repository.createTodo(todo)`

##### `Future<Todo> updateTodo(Todo todo)`
- **Description**: Updates an existing todo
- **Parameters**:
  - `todo`: Updated todo entity
- **Returns**: `Future<Todo>` - Updated todo
- **Usage**: `await repository.updateTodo(todo)`

##### `Future<bool> deleteTodo(String id)`
- **Description**: Soft deletes a todo
- **Parameters**:
  - `id`: Todo ID to delete
- **Returns**: `Future<bool>` - Success status
- **Usage**: `await repository.deleteTodo('todo123')`

##### `Future<bool> permanentDeleteTodo(String id)`
- **Description**: Permanently deletes a todo
- **Parameters**:
  - `id`: Todo ID to delete
- **Returns**: `Future<bool>` - Success status
- **Usage**: `await repository.permanentDeleteTodo('todo123')`

##### `Stream<List<Todo>> watchTodosByStatus({required bool completed, String? userId})`
- **Description**: Watches todos by completion status
- **Parameters**:
  - `completed`: Completion status filter
  - `userId` (optional): User ID filter
- **Returns**: `Stream<List<Todo>>` - Stream of filtered todos
- **Usage**: `repository.watchTodosByStatus(completed: true)`

##### `Stream<List<Todo>> searchTodos({required String query, String? userId})`
- **Description**: Searches todos by query
- **Parameters**:
  - `query`: Search query
  - `userId` (optional): User ID filter
- **Returns**: `Stream<List<Todo>>` - Stream of search results
- **Usage**: `repository.searchTodos(query: 'buy milk')`

## Use Cases

### CreateTodo

Use case for creating new todos.

#### Constructor
```dart
CreateTodo(TodoRepository repository)
```

#### Methods

##### `Future<Todo> call({required String title, String? description, String? userId})`
- **Description**: Creates a new todo
- **Parameters**:
  - `title` (required): Todo title
  - `description` (optional): Todo description
  - `userId` (optional): User ID
- **Returns**: `Future<Todo>` - Created todo
- **Throws**: `ValidationFailure` if title is empty
- **Usage**: `await createTodo(title: 'Buy milk', description: 'From store')`

### UpdateTodo

Use case for updating existing todos.

#### Constructor
```dart
UpdateTodo(TodoRepository repository)
```

#### Methods

##### `Future<Todo> call(Todo todo)`
- **Description**: Updates a todo
- **Parameters**:
  - `todo`: Todo to update
- **Returns**: `Future<Todo>` - Updated todo
- **Throws**: `ValidationFailure` if title is empty
- **Usage**: `await updateTodo(todo)`

##### `Future<Todo> toggleCompletion(Todo todo)`
- **Description**: Toggles todo completion status
- **Parameters**:
  - `todo`: Todo to toggle
- **Returns**: `Future<Todo>` - Updated todo
- **Usage**: `await updateTodo.toggleCompletion(todo)`

##### `Future<Todo> updateContent({required Todo todo, String? title, String? description})`
- **Description**: Updates todo content
- **Parameters**:
  - `todo`: Todo to update
  - `title` (optional): New title
  - `description` (optional): New description
- **Returns**: `Future<Todo>` - Updated todo
- **Usage**: `await updateTodo.updateContent(todo: todo, title: 'New title')`

### DeleteTodo

Use case for deleting todos.

#### Constructor
```dart
DeleteTodo(TodoRepository repository)
```

#### Methods

##### `Future<bool> call(String id)`
- **Description**: Soft deletes a todo
- **Parameters**:
  - `id`: Todo ID to delete
- **Returns**: `Future<bool>` - Success status
- **Throws**: `ValidationFailure` if ID is empty
- **Usage**: `await deleteTodo('todo123')`

##### `Future<bool> permanentDelete(String id)`
- **Description**: Permanently deletes a todo
- **Parameters**:
  - `id`: Todo ID to delete
- **Returns**: `Future<bool>` - Success status
- **Throws**: `ValidationFailure` if ID is empty
- **Usage**: `await deleteTodo.permanentDelete('todo123')`

### SearchTodos

Use case for searching todos.

#### Constructor
```dart
SearchTodos(TodoRepository repository)
```

#### Methods

##### `Stream<List<Todo>> call({required String query, String? userId})`
- **Description**: Searches todos by query
- **Parameters**:
  - `query`: Search query
  - `userId` (optional): User ID filter
- **Returns**: `Stream<List<Todo>>` - Stream of search results
- **Throws**: `ValidationFailure` if query is empty
- **Usage**: `searchTodos(query: 'buy milk')`

##### `Stream<List<Todo>> getByStatus({required bool completed, String? userId})`
- **Description**: Gets todos by completion status
- **Parameters**:
  - `completed`: Completion status filter
  - `userId` (optional): User ID filter
- **Returns**: `Stream<List<Todo>>` - Stream of filtered todos
- **Usage**: `searchTodos.getByStatus(completed: true)`

## Data Models

### TodoModel

Data model for Todo serialization and database operations.

#### Factory Methods

##### `TodoModel.fromEntity(Todo todo)`
- **Description**: Creates model from entity
- **Parameters**:
  - `todo`: Todo entity
- **Returns**: `TodoModel`
- **Usage**: `TodoModel.fromEntity(todo)`

##### `TodoModel.fromMap(Map<String, dynamic> map)`
- **Description**: Creates model from database map
- **Parameters**:
  - `map`: Database row map
- **Returns**: `TodoModel`
- **Usage**: `TodoModel.fromMap(dbRow)`

##### `TodoModel.fromJson(Map<String, dynamic> json)`
- **Description**: Creates model from JSON
- **Parameters**:
  - `json`: JSON map
- **Returns**: `TodoModel`
- **Usage**: `TodoModel.fromJson(jsonData)`

#### Instance Methods

##### `Todo toEntity()`
- **Description**: Converts model to entity
- **Returns**: `Todo`
- **Usage**: `model.toEntity()`

##### `Map<String, dynamic> toMap()`
- **Description**: Converts model to database map
- **Returns**: `Map<String, dynamic>`
- **Usage**: `model.toMap()`

##### `Map<String, dynamic> toJson()`
- **Description**: Converts model to JSON
- **Returns**: `Map<String, dynamic>`
- **Usage**: `model.toJson()`

## Error Handling

### Failure Types

#### DatabaseFailure
- **Description**: Database operation errors
- **Properties**:
  - `String message` - Error message
  - `String? code` - Error code
- **Usage**: `throw Failure.database(message: 'Connection failed')`

#### NetworkFailure
- **Description**: Network operation errors
- **Properties**:
  - `String message` - Error message
  - `int? statusCode` - HTTP status code
- **Usage**: `throw Failure.network(message: 'Request failed', statusCode: 500)`

#### SyncFailure
- **Description**: Synchronization errors
- **Properties**:
  - `String message` - Error message
  - `String? operation` - Failed operation
- **Usage**: `throw Failure.sync(message: 'Sync failed', operation: 'upload')`

#### ValidationFailure
- **Description**: Input validation errors
- **Properties**:
  - `String message` - Error message
  - `String? field` - Field that failed validation
- **Usage**: `throw Failure.validation(message: 'Title required', field: 'title')`

#### UnknownFailure
- **Description**: Unexpected errors
- **Properties**:
  - `String message` - Error message
- **Usage**: `throw Failure.unknown(message: 'Unexpected error')`

## Riverpod Providers

### Service Providers

#### `powerSyncServiceProvider`
- **Type**: `Provider<PowerSyncService>`
- **Description**: PowerSync service instance
- **Usage**: `ref.watch(powerSyncServiceProvider)`

#### `todoRepositoryProvider`
- **Type**: `Provider<TodoRepositoryImpl>`
- **Description**: Todo repository implementation
- **Usage**: `ref.watch(todoRepositoryProvider)`

### Use Case Providers

#### `createTodoProvider`
- **Type**: `Provider<CreateTodo>`
- **Description**: Create todo use case
- **Usage**: `ref.read(createTodoProvider)`

#### `updateTodoProvider`
- **Type**: `Provider<UpdateTodo>`
- **Description**: Update todo use case
- **Usage**: `ref.read(updateTodoProvider)`

#### `deleteTodoProvider`
- **Type**: `Provider<DeleteTodo>`
- **Description**: Delete todo use case
- **Usage**: `ref.read(deleteTodoProvider)`

### State Providers

#### `todosProvider`
- **Type**: `StreamProvider.family<List<Todo>, String?>`
- **Description**: Stream of todos for a user
- **Usage**: `ref.watch(todosProvider(userId))`

#### `syncStatusProvider`
- **Type**: `StreamProvider<String>`
- **Description**: Stream of sync status changes
- **Usage**: `ref.watch(syncStatusProvider)`

#### `searchResultsProvider`
- **Type**: `StreamProvider.family<List<Todo>, SearchParams>`
- **Description**: Stream of search results
- **Usage**: `ref.watch(searchResultsProvider(SearchParams(query: 'milk')))`

## Constants

### AppConstants

#### Database Constants
- `String databaseName` - SQLite database name
- `int databaseVersion` - Database version
- `String todosTable` - Todos table name

#### PowerSync Constants
- `String powerSyncEndpoint` - PowerSync server endpoint
- `String powerSyncToken` - PowerSync authentication token

#### Sync Status Constants
- `String syncStatusConnected` - Connected status
- `String syncStatusDisconnected` - Disconnected status
- `String syncStatusSyncing` - Syncing status

#### UI Constants
- `double defaultPadding` - Default padding value
- `double defaultRadius` - Default border radius
- `double defaultElevation` - Default elevation

## Database Schema

### SQLite Schema

```sql
CREATE TABLE todos (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  completed INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  user_id TEXT,
  deleted INTEGER NOT NULL DEFAULT 0
);
```

### Indexes

```sql
CREATE INDEX idx_todos_user_id ON todos(user_id);
CREATE INDEX idx_todos_completed ON todos(completed);
CREATE INDEX idx_todos_updated_at ON todos(updated_at);
CREATE INDEX idx_todos_deleted ON todos(deleted);
```

### PowerSync Rules

```json
{
  "todos": {
    "access": {
      "user_id": "request.auth.user_id"
    },
    "write": {
      "user_id": "request.auth.user_id"
    }
  }
}
```

## Usage Examples

### Creating a Todo

```dart
// Using use case
final createTodo = ref.read(createTodoProvider);
final todo = await createTodo(
  title: 'Buy groceries',
  description: 'Milk, bread, eggs',
  userId: 'user123',
);
```

### Watching Todos

```dart
// Using provider
final todosAsync = ref.watch(todosProvider('user123'));
todosAsync.when(
  data: (todos) => ListView.builder(...),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);
```

### Updating a Todo

```dart
// Toggle completion
final updateTodo = ref.read(updateTodoProvider);
final updatedTodo = await updateTodo.toggleCompletion(todo);

// Update content
final updatedTodo = await updateTodo.updateContent(
  todo: todo,
  title: 'New title',
  description: 'New description',
);
```

### Searching Todos

```dart
// Search todos
final searchTodos = ref.read(searchTodosProvider);
final searchStream = searchTodos(query: 'milk', userId: 'user123');
searchStream.listen((todos) {
  // Handle search results
});
```

### Error Handling

```dart
try {
  final todo = await createTodo(title: 'Test');
} on ValidationFailure catch (e) {
  print('Validation error: ${e.message}');
} on DatabaseFailure catch (e) {
  print('Database error: ${e.message}');
} catch (e) {
  print('Unexpected error: $e');
}
```

This comprehensive API documentation covers all the major components and their usage patterns in the PowerSync Todo application.
