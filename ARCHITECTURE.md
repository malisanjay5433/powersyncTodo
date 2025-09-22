# PowerSync Todo App - Architecture Documentation

## Overview

This is a Flutter Todo application built with Clean Architecture principles, using PowerSync for offline-first data synchronization and Riverpod for state management. The app provides a seamless todo management experience that works both online and offline.

## Architecture

### Clean Architecture Layers

The application follows Clean Architecture with three main layers:

```
lib/
├── core/                    # Shared utilities and infrastructure
│   ├── constants/          # App constants and database schema
│   ├── errors/             # Error handling and failure types
│   └── network/            # PowerSync service and network layer
├── features/
│   └── todo/               # Todo feature module
│       ├── data/           # Data layer
│       │   ├── datasources/    # Local data sources (SQLite)
│       │   ├── models/         # Data models and DTOs
│       │   └── repositories/   # Repository implementations
│       ├── domain/         # Domain layer (business logic)
│       │   ├── entities/       # Business entities
│       │   ├── repositories/   # Repository interfaces
│       │   └── usecases/       # Use cases (business operations)
│       └── presentation/   # Presentation layer (UI)
│           ├── pages/          # Screen widgets
│           ├── providers/      # Riverpod providers
│           └── widgets/        # Reusable UI components
└── main.dart              # App entry point
```

### Layer Responsibilities

#### 1. Domain Layer (Business Logic)
- **Entities**: Core business objects (`Todo`)
- **Repositories**: Abstract interfaces for data access
- **Use Cases**: Business operations (CreateTodo, UpdateTodo, etc.)

#### 2. Data Layer (Data Management)
- **Data Sources**: SQLite local storage implementation
- **Models**: Data transfer objects and serialization
- **Repository Implementations**: Concrete implementations of domain interfaces

#### 3. Presentation Layer (UI)
- **Pages**: Screen widgets (TodoListPage, AddTodoPage)
- **Providers**: Riverpod state management
- **Widgets**: Reusable UI components

## PowerSync Integration

### Offline-First Approach

The app uses PowerSync to provide offline-first functionality:

1. **Local SQLite Database**: All data is stored locally first
2. **Real-time Sync**: Changes sync to backend when online
3. **Conflict Resolution**: Handles conflicts with last-write-wins strategy
4. **Queue Management**: Offline changes are queued and synced when online

### Database Schema

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

### Sync Rules

PowerSync rules ensure data isolation and security:

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

## State Management with Riverpod

### Provider Structure

- **Service Providers**: PowerSync and database services
- **Repository Providers**: Data access layer
- **Use Case Providers**: Business logic operations
- **State Providers**: UI state management

### Key Providers

```dart
// Service providers
final powerSyncServiceProvider = Provider<PowerSyncService>(...);
final todoRepositoryProvider = Provider<TodoRepositoryImpl>(...);

// Use case providers
final createTodoProvider = Provider<CreateTodo>(...);
final updateTodoProvider = Provider<UpdateTodo>(...);

// State providers
final todosProvider = StreamProvider.family<List<Todo>, String?>(...);
final syncStatusProvider = StreamProvider<String>(...);
```

## Key Features

### 1. Todo Management
- Create new todos with title and description
- Mark todos as completed/incomplete
- Edit todo content
- Delete todos (soft delete)
- Search todos by title or description

### 2. Offline Support
- All operations work offline
- Changes are queued for sync
- Automatic sync when online
- Visual sync status indicator

### 3. Real-time Updates
- UI automatically updates when data changes
- Stream-based data flow
- Reactive state management

### 4. Clean UI/UX
- Modern Material Design 3
- Google Fonts (Poppins)
- Responsive design
- Loading states and error handling

## Data Flow

### Creating a Todo

1. User inputs todo details in `AddTodoPage`
2. `CreateTodo` use case validates input
3. `TodoRepository` saves to local SQLite
4. PowerSync queues change for sync
5. UI updates automatically via stream
6. When online, PowerSync syncs to backend

### Reading Todos

1. `GetTodos` use case requests data
2. `TodoRepository` queries local SQLite
3. Data streams to UI via Riverpod
4. UI renders todo list
5. Changes from other devices sync automatically

### Updating Todos

1. User toggles completion or edits content
2. `UpdateTodo` use case processes change
3. Local database is updated immediately
4. PowerSync queues change for sync
5. UI updates in real-time

## Error Handling

### Failure Types

- **DatabaseFailure**: SQLite operation errors
- **NetworkFailure**: PowerSync connection errors
- **ValidationFailure**: Input validation errors
- **SyncFailure**: Synchronization errors
- **UnknownFailure**: Unexpected errors

### Error Recovery

- Automatic retry for network operations
- Graceful degradation when offline
- User-friendly error messages
- Fallback to local data

## Testing Strategy

### Unit Tests (50-60% Coverage)

- **Entity Tests**: Business logic validation
- **Use Case Tests**: Business operation testing
- **Model Tests**: Data serialization/deserialization
- **Repository Tests**: Data access layer testing

### Test Structure

```
test/
├── features/
│   └── todo/
│       ├── domain/
│       │   ├── entities/
│       │   └── usecases/
│       └── data/
│           └── models/
```

## Dependencies

### Core Dependencies
- **flutter_riverpod**: State management
- **powersync**: Offline-first sync
- **sqflite**: Local SQLite database
- **google_fonts**: Typography
- **freezed**: Immutable data classes
- **json_annotation**: JSON serialization

### Development Dependencies
- **build_runner**: Code generation
- **mockito**: Testing mocks
- **flutter_lints**: Code quality

## Getting Started

### Prerequisites
- Flutter SDK 3.2.3+
- Dart SDK 3.0.0+

### Setup
1. Clone the repository
2. Run `flutter packages get`
3. Run `flutter packages pub run build_runner build`
4. Configure PowerSync endpoint and token
5. Run `flutter run`

### Configuration

Update PowerSync configuration in `lib/core/constants/app_constants.dart`:

```dart
static const String powerSyncEndpoint = 'wss://your-powersync-endpoint.com';
static const String powerSyncToken = 'your-powersync-token';
```

## Best Practices

### Code Organization
- Follow Clean Architecture principles
- Keep layers independent
- Use dependency injection
- Implement proper error handling

### Performance
- Use streams for reactive updates
- Implement proper pagination for large datasets
- Optimize database queries
- Cache frequently accessed data

### Security
- Validate all inputs
- Use proper authentication
- Implement data encryption
- Follow OWASP guidelines

## Future Enhancements

- User authentication and authorization
- Todo categories and tags
- Due dates and reminders
- File attachments
- Collaborative features
- Advanced search and filtering
- Data export/import
- Push notifications
