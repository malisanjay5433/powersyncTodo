/// Authentication configuration for PowerSync
/// Update these values with your actual PowerSync credentials
class AuthConfig {
  // ========================================
  // 🔧 UPDATE THESE VALUES
  // ========================================
  
  /// PowerSync endpoint URL
  /// Get this from your PowerSync Dashboard → Settings → Client Tokens
  static const String powersyncEndpoint = 'wss://your-actual-instance.powersync.co';
  
  /// Development token for testing
  /// Get this from your PowerSync Dashboard → Settings → Client Tokens
  static const String devToken = 'your-actual-token-here';
  
  /// Production token for production
  /// Get this from your PowerSync Dashboard → Settings → Client Tokens
  static const String prodToken = 'your-prod-token-here';
  
  /// User ID for development (you can change this)
  static const String devUserId = 'dev-user-123';
  
  /// Database name (same as in your PowerSync project)
  static const String databaseName = 'powersync_todo_db';
  
  // ========================================
  // 🚀 QUICK START INSTRUCTIONS
  // ========================================
  
  /// Step 1: Go to https://app.powersync.co
  /// Step 2: Create a new project or select existing one
  /// Step 3: Go to Settings → Client Tokens
  /// Step 4: Create a new client token
  /// Step 5: Copy the endpoint URL and token
  /// Step 6: Update the values above
  
  // ========================================
  // 🔒 PRODUCTION SETUP
  // ========================================
  
  /// For production, use environment variables or secure storage
  /// instead of hardcoded values
  
  static String get endpoint {
    // In production, you might want to use different endpoints
    // based on environment (dev/staging/prod)
    return powersyncEndpoint;
  }
  
  static String get token {
    // In production, you might want to use different tokens
    // based on environment (dev/staging/prod)
    return devToken; // Change to prodToken for production
  }
  
  static String get userId {
    // In production, this should come from your authentication system
    return devUserId;
  }
  
}
