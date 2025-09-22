/// PowerSync configuration for the Todo app
class PowerSyncConfig {
  // PowerSync endpoint - replace with your actual PowerSync instance URL
  static const String endpoint = 'wss://your-powersync-instance.powersync.co';
  
  // PowerSync token - replace with your actual token
  static const String token = 'your-powersync-token';
  
  // Database name
  static const String databaseName = 'todo_powersync_db';
  
  /// Get PowerSync schema for todos (simplified for v1.4.2)
  static String get schema => '''
    CREATE TABLE IF NOT EXISTS todos (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT,
      completed INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    );
  ''';

  /// Get PowerSync sync rules
  static String get syncRules => '''
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
  ''';
}
