# PowerSync Todo - Project Structure

This project now follows the [PowerSync Flutter documentation](https://docs.powersync.com/client-sdk-references/flutter) structure and best practices.

## 📁 Project Structure

```
lib/
├── models/
│   ├── schema.dart              # PowerSync schema definition
│   ├── todolist.dart           # TodoList model class
│   └── todo.dart               # Todo model class (existing)
├── powersync/
│   ├── my_backend_connector.dart  # PowerSync backend connector
│   └── powersync.dart          # PowerSync database initialization
├── widgets/
│   ├── lists_widget.dart       # Lists widget with PowerSync integration
│   └── todos_widget.dart       # Todos widget with PowerSync integration
├── config/
│   └── powersync_config.dart   # PowerSync configuration (existing)
├── providers/
│   └── todo_provider.dart      # State management (existing)
├── screens/
│   ├── add_todo_screen.dart    # Add todo screen (existing)
│   └── todo_list_screen.dart   # Todo list screen (existing)
├── services/
│   ├── powersync_service.dart  # PowerSync service interface (existing)
│   ├── real_powersync_service.dart  # Real PowerSync implementation (existing)
│   ├── sqlite_database_helper.dart  # SQLite helper (existing)
│   └── todo_storage.dart       # Todo storage (existing)
├── main.dart                   # Original main app
└── main_new.dart              # New PowerSync documentation-based main app
```

## 🚀 Key Features

### PowerSync Integration
- **Real-time sync**: Changes are automatically synced across devices
- **Offline support**: Works without internet connection
- **Local SQLite**: Fast local database access
- **Background sync**: Automatic data synchronization

### Following PowerSync Best Practices
- ✅ Schema definition in `models/schema.dart`
- ✅ Database initialization in `powersync/powersync.dart`
- ✅ Backend connector in `powersync/my_backend_connector.dart`
- ✅ Widget integration with `db.watch()` for real-time updates
- ✅ CRUD operations using PowerSync methods

## 📋 Usage

### Running the App
```bash
# Run the original app
flutter run

# Run the new PowerSync documentation-based app
flutter run -t lib/main_new.dart
```

### Key PowerSync Methods Used
- `db.watch()` - Real-time query subscriptions
- `db.get()` - Single row queries
- `db.getAll()` - Multiple row queries
- `db.execute()` - Write operations (INSERT/UPDATE/DELETE)
- `db.connect()` - Connect to PowerSync backend
- `db.disconnect()` - Disconnect from PowerSync

## 🔧 Configuration

### PowerSync Setup
1. Update `config/powersync_config.dart` with your PowerSync endpoint and token
2. Implement actual backend API calls in `powersync/my_backend_connector.dart`
3. Configure authentication in `fetchCredentials()` method

### Schema Management
- Schema is defined in `models/schema.dart`
- No migrations needed - schema is applied automatically
- Supports `text`, `integer`, and `real` column types

## 📚 Documentation References

- [PowerSync Flutter Documentation](https://docs.powersync.com/client-sdk-references/flutter)
- [PowerSync Schema Definition](https://docs.powersync.com/client-sdk-references/flutter#1-define-the-schema)
- [PowerSync Database Instantiation](https://docs.powersync.com/client-sdk-references/flutter#2-instantiate-the-powersync-database)
- [Backend Connector Integration](https://docs.powersync.com/client-sdk-references/flutter#3-integrate-with-your-backend)

## 🎯 Next Steps

1. **Backend Integration**: Implement actual API calls in `MyBackendConnector`
2. **Authentication**: Set up proper authentication flow
3. **Error Handling**: Add comprehensive error handling
4. **Testing**: Add unit tests for PowerSync operations
5. **Production**: Configure production PowerSync endpoint and tokens

## ✨ Benefits of This Structure

- **Maintainable**: Clear separation of concerns
- **Scalable**: Easy to add new features and models
- **Documentation-aligned**: Follows PowerSync best practices
- **Real-time**: Automatic UI updates when data changes
- **Offline-first**: Works without internet connection
- **Type-safe**: Full TypeScript-like type safety with Dart
