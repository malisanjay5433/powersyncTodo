import 'auth_config.dart';

/// PowerSync configuration for the Todo app
class PowerSyncConfig {
  // PowerSync endpoint - uses AuthConfig for centralized configuration
  static String get endpoint => AuthConfig.endpoint;
  
  // PowerSync token - uses AuthConfig for centralized configuration
  static String get token => AuthConfig.token;
  
  // Development token (for testing only)
  static String get devToken => AuthConfig.devToken;
  
  // Production token (for production use)
  static String get prodToken => AuthConfig.prodToken;
  
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
