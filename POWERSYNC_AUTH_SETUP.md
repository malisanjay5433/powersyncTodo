# PowerSync Authentication Setup Guide

This guide shows you how to set up authentication and configure PowerSync endpoints and tokens for your Flutter app.

## 🔧 Quick Setup (Development)

### 1. Update Configuration

Edit `lib/config/powersync_config.dart`:

```dart
class PowerSyncConfig {
  // Replace with your actual PowerSync instance URL
  static const String endpoint = 'wss://your-instance.powersync.co';
  
  // Replace with your development token
  static const String devToken = 'your-dev-token-here';
  
  // Replace with your production token
  static const String prodToken = 'your-prod-token-here';
}
```

### 2. Get PowerSync Credentials

#### Option A: PowerSync Cloud (Recommended)
1. Go to [PowerSync Dashboard](https://app.powersync.co)
2. Create a new project or select existing one
3. Go to "Settings" → "Client Tokens"
4. Create a new client token
5. Copy the endpoint URL and token

#### Option B: Self-Hosted PowerSync
1. Set up your own PowerSync instance
2. Configure your backend to work with PowerSync
3. Get the WebSocket endpoint URL
4. Generate authentication tokens

### 3. Update Your App

```dart
// In your main app initialization
await AuthService.instance.loginWithDevToken();
```

## 🔐 Authentication Methods

### Development Token (Quick Start)

```dart
// For development and testing
await AuthService.instance.loginWithDevToken();
```

### Custom Authentication

```dart
// For custom backend authentication
await AuthService.instance.loginWithCredentials('user-123', 'custom-token');
```

### Supabase Integration

```dart
// If using Supabase as your backend
await AuthService.instance.loginWithSupabase(supabaseToken);
```

### Firebase Integration

```dart
// If using Firebase as your backend
await AuthService.instance.loginWithFirebase(firebaseToken);
```

## 📋 Step-by-Step Setup

### Step 1: PowerSync Cloud Setup

1. **Sign up for PowerSync Cloud**
   - Go to [app.powersync.co](https://app.powersync.co)
   - Create a new account or sign in

2. **Create a Project**
   - Click "New Project"
   - Enter project name: "PowerSync Todo"
   - Select region closest to your users

3. **Configure Backend**
   - Go to "Backend" tab
   - Set up your backend database (PostgreSQL, MySQL, etc.)
   - Configure sync rules

4. **Get Client Token**
   - Go to "Settings" → "Client Tokens"
   - Click "Create Token"
   - Copy the endpoint URL and token

### Step 2: Update Your App

1. **Update Configuration**
   ```dart
   // lib/config/powersync_config.dart
   static const String endpoint = 'wss://your-instance.powersync.co';
   static const String devToken = 'your-token-here';
   ```

2. **Initialize Authentication**
   ```dart
   // In your main.dart or app initialization
   await AuthService.instance.loginWithDevToken();
   ```

3. **Connect to PowerSync**
   ```dart
   // After authentication
   await connectToPowerSync(MyBackendConnector());
   ```

### Step 3: Backend Integration

1. **Set up your backend API**
   - Create endpoints for CRUD operations
   - Implement authentication
   - Connect to your database

2. **Update Backend Connector**
   ```dart
   // lib/powersync/my_backend_connector.dart
   @override
   Future<void> uploadData(PowerSyncDatabase database) async {
     // Implement your backend API calls here
     final transaction = await database.getNextCrudTransaction();
     if (transaction == null) return;
     
     for (var op in transaction.crud) {
       switch (op.op) {
         case UpdateType.put:
           await _createTodo(op.opData);
           break;
         case UpdateType.patch:
           await _updateTodo(op.opData);
           break;
         case UpdateType.delete:
           await _deleteTodo(op.opData);
           break;
       }
     }
     
     await transaction.complete();
   }
   ```

## 🔒 Production Setup

### Environment Variables

Create a `.env` file (don't commit to git):

```env
POWERSYNC_ENDPOINT=wss://your-instance.powersync.co
POWERSYNC_TOKEN=your-production-token
```

### Secure Token Management

```dart
// For production, use secure token storage
class SecureTokenStorage {
  static Future<String?> getToken() async {
    // Use flutter_secure_storage or similar
    // return await storage.read(key: 'powersync_token');
  }
  
  static Future<void> setToken(String token) async {
    // await storage.write(key: 'powersync_token', value: token);
  }
}
```

## 🧪 Testing

### Test Authentication

```dart
// Test if authentication is working
void testAuth() async {
  final success = await AuthService.instance.loginWithDevToken();
  if (success) {
    print('✅ Authentication successful');
  } else {
    print('❌ Authentication failed');
  }
}
```

### Test PowerSync Connection

```dart
// Test PowerSync connection
void testPowerSync() async {
  try {
    await connectToPowerSync(MyBackendConnector());
    print('✅ PowerSync connected successfully');
  } catch (e) {
    print('❌ PowerSync connection failed: $e');
  }
}
```

## 🚨 Common Issues

### 1. "User not authenticated" Error
- Make sure to call `AuthService.instance.loginWithDevToken()` before connecting to PowerSync
- Check if the token is valid and not expired

### 2. "Connection failed" Error
- Verify the endpoint URL is correct
- Check if the token has the right permissions
- Ensure your PowerSync instance is running

### 3. "Invalid token" Error
- Regenerate the token in PowerSync Dashboard
- Make sure the token is not expired
- Check if the token has the right scope

## 📚 Additional Resources

- [PowerSync Authentication Setup](https://docs.powersync.com/installation/authentication-setup)
- [PowerSync Flutter Documentation](https://docs.powersync.com/client-sdk-references/flutter)
- [PowerSync Dashboard](https://app.powersync.co)
- [PowerSync Community Discord](https://discord.gg/powersync)

## 🎯 Next Steps

1. **Set up PowerSync Cloud account**
2. **Update configuration with your credentials**
3. **Test authentication in your app**
4. **Implement backend API integration**
5. **Deploy to production with secure token management**

---

**Need help?** Check the PowerSync documentation or join the community Discord for support!
