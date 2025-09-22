#!/usr/bin/env dart

/// Test PowerSync Configuration
/// Run with: dart run test_powersync_config.dart

import 'lib/config/auth_config.dart';

void main() {
  print('🧪 Testing PowerSync Configuration');
  print('==================================\n');
  
  // Check if configuration is set up
  print('📋 Configuration Status:');
  print('Endpoint: ${AuthConfig.endpoint}');
  print('Token: ${AuthConfig.token.substring(0, 10)}...');
  print('User ID: ${AuthConfig.userId}');
  print('Database: ${AuthConfig.databaseName}\n');
  
  // Check if values are still placeholders
  bool hasPlaceholders = false;
  
  if (AuthConfig.endpoint.contains('your-instance')) {
    print('❌ Endpoint still contains placeholder value');
    hasPlaceholders = true;
  }
  
  if (AuthConfig.token.contains('your-dev-token')) {
    print('❌ Token still contains placeholder value');
    hasPlaceholders = true;
  }
  
  if (AuthConfig.databaseName.contains('your_database')) {
    print('❌ Database name still contains placeholder value');
    hasPlaceholders = true;
  }
  
  if (hasPlaceholders) {
    print('\n🔧 Action Required:');
    print('1. Go to https://app.powersync.co');
    print('2. Create a project and get your credentials');
    print('3. Update lib/config/auth_config.dart with your actual values');
    print('4. Run this test again\n');
  } else {
    print('✅ Configuration looks good!');
    print('You can now run your Flutter app with PowerSync\n');
  }
  
  print('🚀 Next Steps:');
  print('1. Update lib/config/auth_config.dart with your credentials');
  print('2. Run: flutter run -t lib/main_new.dart');
  print('3. Test the app on your emulator\n');
}
