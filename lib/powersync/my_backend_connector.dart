import 'package:flutter/foundation.dart';
import 'package:powersync/powersync.dart';
import 'auth_service.dart';

/// PowerSync backend connector following the documentation pattern
/// This implements the connection between your application backend and PowerSync
/// Reference: https://docs.powersync.com/client-sdk-references/flutter#3-integrate-with-your-backend
class MyBackendConnector extends PowerSyncBackendConnector {
  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    try {
      // Check if user is authenticated
      if (!AuthService.instance.isAuthenticated) {
        debugPrint('User not authenticated, cannot fetch PowerSync credentials');
        return null;
      }
      
      // Get credentials from auth service
      final credentials = AuthService.instance.getPowerSyncCredentials();
      
      return PowerSyncCredentials(
        endpoint: credentials['endpoint'] as String,
        token: credentials['token'] as String,
      );
    } catch (e) {
      debugPrint('Error fetching PowerSync credentials: $e');
      return null;
    }
  }

  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    // This function is called whenever there is data to upload, whether the
    // device is online or offline.
    // If this call throws an error, it is retried periodically.

    final transaction = await database.getNextCrudTransaction();
    if (transaction == null) {
      return;
    }

    // The data that needs to be changed in the remote db
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

    // Completes the transaction and moves onto the next one
    await transaction.complete();
  }

  /// Handle creating a new record
  Future<void> _handleCreate(CrudEntry op) async {
    // TODO: Implement actual backend API call for creating todos
    debugPrint('Creating todo: ${op.opData}');
    // Example: await http.post('https://your-api.com/todos', body: op.opData);
  }

  /// Handle updating an existing record
  Future<void> _handleUpdate(CrudEntry op) async {
    // TODO: Implement actual backend API call for updating todos
    debugPrint('Updating todo: ${op.opData}');
    // Example: await http.put('https://your-api.com/todos/${op.opData.id}', body: op.opData);
  }

  /// Handle deleting a record
  Future<void> _handleDelete(CrudEntry op) async {
    // TODO: Implement actual backend API call for deleting todos
    debugPrint('Deleting todo: ${op.opData}');
    // Example: await http.delete('https://your-api.com/todos/${op.opData.id}');
  }
}
