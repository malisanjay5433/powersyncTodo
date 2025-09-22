# 🔗 PowerSync Connection Guide

## **Step 1: Get PowerSync Credentials**

### **1.1 Sign up for PowerSync**
1. Go to [PowerSync.co](https://powersync.co)
2. Create an account
3. Create a new PowerSync instance
4. Get your **endpoint URL** and **token**

### **1.2 PowerSync Instance Setup**
- **Endpoint**: `wss://your-instance.powersync.co`
- **Token**: Your authentication token
- **Database**: Your database name

## **Step 2: Update Configuration**

### **2.1 Update PowerSync Config**
Edit `lib/config/powersync_config.dart`:

```dart
class PowerSyncConfig {
  // Replace with your actual PowerSync instance URL
  static const String endpoint = 'wss://your-instance.powersync.co';
  
  // Replace with your actual PowerSync token
  static const String token = 'your-actual-token-here';
  
  // Your database name
  static const String databaseName = 'your_database_name';
  
  // ... rest of config
}
```

### **2.2 Update Backend Connector**
Edit `lib/services/powersync_service.dart` and replace the simplified implementation:

```dart
import 'package:powersync/powersync.dart';

class PowerSyncService {
  PowerSyncDatabase? _database;
  PowerSyncBackendConnector? _connector;
  
  Future<void> initialize() async {
    try {
      // Initialize actual PowerSync database
      _database = await PowerSyncDatabase.open(
        name: PowerSyncConfig.databaseName,
        schema: PowerSyncConfig.schema,
      );
      
      // Set up backend connector
      _connector = _TodoBackendConnector();
      
      // Connect to PowerSync
      await _database!.connect(connector: _connector!);
      
      // Listen to status changes
      _database!.statusStream.listen((status) {
        _statusController.add(status);
      });
      
      // Listen to todos changes
      _database!.watch('SELECT * FROM todos ORDER BY updated_at DESC').listen((results) {
        final todos = results.map((row) => _mapRowToTodo(row)).toList();
        _todosController.add(todos);
      });
      
    } catch (e) {
      debugPrint('Error initializing PowerSync: $e');
      rethrow;
    }
  }
}
```

## **Step 3: Implement Backend Integration**

### **3.1 Create Backend Connector**
Replace the `_TodoBackendConnector` class:

```dart
class _TodoBackendConnector extends PowerSyncBackendConnector {
  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    // Get credentials from your authentication service
    return PowerSyncCredentials(
      endpoint: PowerSyncConfig.endpoint,
      token: PowerSyncConfig.token,
    );
  }

  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    final transaction = await database.getNextCrudTransaction();
    if (transaction == null) return;

    try {
      // Process each CRUD operation
      for (var op in transaction.crud) {
        switch (op.op) {
          case UpdateType.put:
            await _handleCreate(op);
            break;
          case UpdateType.patch:
            await _handleUpdate(op);
            break;
          case UpdateType.delete:
            await _handleDelete(op);
            break;
        }
      }

      await transaction.complete();
    } catch (e) {
      debugPrint('Error uploading data: $e');
      await transaction.rollback();
    }
  }

  Future<void> _handleCreate(CrudEntry op) async {
    // Implement your backend API call for creating todos
    final todoData = op.opData;
    // POST to your backend API
    // Example: await http.post('https://your-api.com/todos', body: todoData);
  }

  Future<void> _handleUpdate(CrudEntry op) async {
    // Implement your backend API call for updating todos
    final todoData = op.opData;
    // PUT to your backend API
    // Example: await http.put('https://your-api.com/todos/${todoData.id}', body: todoData);
  }

  Future<void> _handleDelete(CrudEntry op) async {
    // Implement your backend API call for deleting todos
    final todoData = op.opData;
    // DELETE from your backend API
    // Example: await http.delete('https://your-api.com/todos/${todoData.id}');
  }
}
```

## **Step 4: Backend API Requirements**

### **4.1 Required Endpoints**
Your backend needs these endpoints:

```
POST   /todos          - Create todo
PUT    /todos/:id      - Update todo
DELETE /todos/:id      - Delete todo
GET    /todos          - Get todos (for initial sync)
```

### **4.2 Data Format**
Your backend should accept/return data in this format:

```json
{
  "id": "unique-id",
  "title": "Todo title",
  "description": "Todo description",
  "completed": false,
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

## **Step 5: PowerSync Schema**

### **5.1 Update Schema**
Make sure your PowerSync schema matches your backend:

```dart
static Schema get schema => Schema(
  tables: [
    Table(
      name: 'todos',
      columns: [
        Column(name: 'id', type: ColumnType.text),
        Column(name: 'title', type: ColumnType.text),
        Column(name: 'description', type: ColumnType.text, nullable: true),
        Column(name: 'completed', type: ColumnType.boolean),
        Column(name: 'created_at', type: ColumnType.text),
        Column(name: 'updated_at', type: ColumnType.text),
      ],
      primaryKey: ['id'],
    ),
  ],
);
```

### **5.2 Sync Rules**
Configure sync rules in PowerSync dashboard:

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

## **Step 6: Testing**

### **6.1 Test Connection**
```bash
flutter run -d chrome
# Check console for PowerSync connection messages
```

### **6.2 Test Offline/Online**
1. **Add todos offline** - Should work locally
2. **Go online** - Should sync to backend
3. **Check backend** - Verify todos are synced

## **Step 7: Common Issues**

### **7.1 Connection Issues**
- Check your endpoint URL format
- Verify your token is valid
- Ensure your backend is running

### **7.2 Sync Issues**
- Check your backend API responses
- Verify data format matches schema
- Check PowerSync dashboard for errors

### **7.3 Authentication Issues**
- Implement proper token refresh
- Handle authentication errors
- Add user login/logout

## **Step 8: Production Deployment**

### **8.1 Environment Variables**
Use environment variables for credentials:

```dart
class PowerSyncConfig {
  static const String endpoint = String.fromEnvironment('POWERSYNC_ENDPOINT');
  static const String token = String.fromEnvironment('POWERSYNC_TOKEN');
}
```

### **8.2 Build Configuration**
Update `android/app/build.gradle` and `ios/Runner/Info.plist` with your credentials.

## **🎉 You're Ready!**

Once you complete these steps, your app will have:
- ✅ **Real PowerSync integration**
- ✅ **Offline-first functionality**
- ✅ **Real-time synchronization**
- ✅ **Backend data persistence**

**Need help?** Check the [PowerSync Documentation](https://docs.powersync.com/) for more details!
