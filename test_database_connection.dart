#!/usr/bin/env dart

/// Test Database Connection
/// Run with: dart run test_database_connection.dart

import 'dart:io';

void main() async {
  print('🧪 Testing Database Connection');
  print('=============================\n');
  
  // Test local PostgreSQL connection
  print('📋 Testing Local PostgreSQL...');
  
  try {
    // Test if PostgreSQL is running
    final result = await Process.run('psql', ['--version']);
    if (result.exitCode == 0) {
      print('✅ PostgreSQL is installed: ${result.stdout.toString().trim()}');
    } else {
      print('❌ PostgreSQL not found');
      return;
    }
    
    // Test database connection
    final dbTest = await Process.run('psql', [
      'powersync_todo_db',
      '-c',
      'SELECT version();'
    ]);
    
    if (dbTest.exitCode == 0) {
      print('✅ Database connection successful');
      print('✅ Database: powersync_todo_db');
      print('✅ Host: localhost');
      print('✅ Port: 5432');
    } else {
      print('❌ Database connection failed');
      print('Error: ${dbTest.stderr}');
    }
    
  } catch (e) {
    print('❌ Error testing database: $e');
  }
  
  print('\n🎯 Next Steps:');
  print('1. Go to https://app.powersync.co');
  print('2. Create project and get credentials');
  print('3. Update lib/config/auth_config.dart');
  print('4. Run: flutter run -t lib/main_new.dart\n');
}
