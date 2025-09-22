import 'package:flutter/foundation.dart';
import '../config/powersync_config.dart';

/// Authentication service for PowerSync
/// This handles different authentication methods based on your backend setup
class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();
  
  AuthService._();
  
  // Current user ID (set when user logs in)
  String? _currentUserId;
  String? get currentUserId => _currentUserId;
  
  // Authentication state
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  
  /// Login with development token (for testing)
  Future<bool> loginWithDevToken() async {
    try {
      _currentUserId = 'dev-user-123';
      _isAuthenticated = true;
      debugPrint('Logged in with development token');
      return true;
    } catch (e) {
      debugPrint('Error logging in with dev token: $e');
      return false;
    }
  }
  
  /// Login with custom credentials
  Future<bool> loginWithCredentials(String userId, String token) async {
    try {
      _currentUserId = userId;
      _isAuthenticated = true;
      debugPrint('Logged in with credentials for user: $userId');
      return true;
    } catch (e) {
      debugPrint('Error logging in with credentials: $e');
      return false;
    }
  }
  
  /// Login with Supabase (if using Supabase backend)
  Future<bool> loginWithSupabase(String supabaseToken) async {
    try {
      // TODO: Implement Supabase authentication
      // This would typically involve:
      // 1. Validating the Supabase token
      // 2. Extracting user ID from the token
      // 3. Setting up PowerSync credentials
      
      _currentUserId = 'supabase-user-123'; // Extract from token
      _isAuthenticated = true;
      debugPrint('Logged in with Supabase token');
      return true;
    } catch (e) {
      debugPrint('Error logging in with Supabase: $e');
      return false;
    }
  }
  
  /// Login with Firebase (if using Firebase backend)
  Future<bool> loginWithFirebase(String firebaseToken) async {
    try {
      // TODO: Implement Firebase authentication
      // This would typically involve:
      // 1. Validating the Firebase token
      // 2. Extracting user ID from the token
      // 3. Setting up PowerSync credentials
      
      _currentUserId = 'firebase-user-123'; // Extract from token
      _isAuthenticated = true;
      debugPrint('Logged in with Firebase token');
      return true;
    } catch (e) {
      debugPrint('Error logging in with Firebase: $e');
      return false;
    }
  }
  
  /// Logout
  Future<void> logout() async {
    _currentUserId = null;
    _isAuthenticated = false;
    debugPrint('Logged out');
  }
  
  /// Get PowerSync credentials based on current authentication
  Map<String, dynamic> getPowerSyncCredentials() {
    if (!_isAuthenticated) {
      throw Exception('User not authenticated');
    }
    
    // For development, use dev token
    if (kDebugMode) {
      return {
        'endpoint': PowerSyncConfig.endpoint,
        'token': PowerSyncConfig.devToken,
        'userId': _currentUserId,
      };
    }
    
    // For production, use production token
    return {
      'endpoint': PowerSyncConfig.endpoint,
      'token': PowerSyncConfig.prodToken,
      'userId': _currentUserId,
    };
  }
}
