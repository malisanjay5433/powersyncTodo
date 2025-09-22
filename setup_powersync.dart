#!/usr/bin/env dart

/// PowerSync Setup Script
/// This script helps you set up PowerSync authentication
/// Run with: dart run setup_powersync.dart

import 'dart:io';

void main() {
  print('🚀 PowerSync Setup Script');
  print('========================\n');
  
  print('This script will help you set up PowerSync authentication for your Flutter app.\n');
  
  print('📋 Prerequisites:');
  print('1. PowerSync Cloud account (https://app.powersync.co)');
  print('2. A PowerSync project created');
  print('3. Client token generated\n');
  
  print('🔧 Step 1: Get your PowerSync credentials');
  print('1. Go to https://app.powersync.co');
  print('2. Sign in or create an account');
  print('3. Create a new project or select existing one');
  print('4. Go to Settings → Client Tokens');
  print('5. Click "Create Token"');
  print('6. Copy the endpoint URL and token\n');
  
  print('📝 Step 2: Update your configuration');
  print('Edit lib/config/auth_config.dart and update:');
  print('- powersyncEndpoint: Your PowerSync endpoint URL');
  print('- devToken: Your development token');
  print('- prodToken: Your production token (optional)\n');
  
  print('🧪 Step 3: Test your setup');
  print('Run your Flutter app:');
  print('flutter run -t lib/main_new.dart\n');
  
  print('✅ That\'s it! Your PowerSync app should now work with authentication.\n');
  
  print('📚 Need help?');
  print('- Check POWERSYNC_AUTH_SETUP.md for detailed instructions');
  print('- Visit https://docs.powersync.com for documentation');
  print('- Join the PowerSync Discord community\n');
  
  print('🎯 Next steps:');
  print('1. Update lib/config/auth_config.dart with your credentials');
  print('2. Test the app with flutter run');
  print('3. Implement your backend API integration');
  print('4. Deploy to production with secure token management\n');
}
