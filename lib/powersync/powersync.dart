import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import '../models/schema.dart';

/// PowerSync database instance
/// This follows the PowerSync documentation pattern
late PowerSyncDatabase db;

/// Initialize the PowerSync database
/// This follows the PowerSync documentation pattern from:
/// https://docs.powersync.com/client-sdk-references/flutter#2-instantiate-the-powersync-database
Future<void> openDatabase() async {
  final dir = await getApplicationSupportDirectory();
  final path = join(dir.path, 'powersync-todo.db');

  // Set up the database
  // Inject the Schema you defined in the previous step and a file path
  db = PowerSyncDatabase(schema: schema, path: path);
  await db.initialize();
}

/// Connect to PowerSync with backend connector
/// This should be called when the user is authenticated
Future<void> connectToPowerSync(PowerSyncBackendConnector connector) async {
  await db.connect(connector: connector);
}

/// Disconnect from PowerSync
Future<void> disconnectFromPowerSync() async {
  await db.disconnect();
}

/// Get the current PowerSync database instance
PowerSyncDatabase get database => db;
