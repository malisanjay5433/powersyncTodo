import 'package:flutter/material.dart';
import 'powersync/powersync.dart';
import 'powersync/my_backend_connector.dart';
import 'powersync/auth_service.dart';
import 'widgets/todos_widget.dart';
import 'widgets/lists_widget.dart';

/// Main entry point following PowerSync documentation pattern
/// Reference: https://docs.powersync.com/client-sdk-references/flutter#2-instantiate-the-powersync-database
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize PowerSync database
  await openDatabase();
  
  runApp(const DemoApp());
}

/// Demo app following PowerSync documentation pattern
/// Reference: https://docs.powersync.com/client-sdk-references/flutter#2-instantiate-the-powersync-database
class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  bool _isConnected = false;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _connectToPowerSync();
  }

  Future<void> _connectToPowerSync() async {
    setState(() {
      _isConnecting = true;
    });

    try {
      // First, authenticate the user
      final authSuccess = await AuthService.instance.loginWithDevToken();
      if (!authSuccess) {
        throw Exception('Authentication failed');
      }
      
      // Then connect to PowerSync with backend connector
      await connectToPowerSync(MyBackendConnector());
      
      setState(() {
        _isConnected = true;
        _isConnecting = false;
      });
    } catch (e) {
      debugPrint('Error connecting to PowerSync: $e');
      setState(() {
        _isConnected = false;
        _isConnecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PowerSync Todo Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    if (_isConnecting) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Connecting to PowerSync...'),
            ],
          ),
        ),
      );
    }

    if (!_isConnected) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Failed to connect to PowerSync'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _connectToPowerSync,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return const TodoAppHome();
  }
}

/// Main app home following PowerSync documentation pattern
class TodoAppHome extends StatefulWidget {
  const TodoAppHome({super.key});

  @override
  State<TodoAppHome> createState() => _TodoAppHomeState();
}

class _TodoAppHomeState extends State<TodoAppHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const TodosPage(),
    const ListsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PowerSync Todo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddTodoDialog,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Lists',
          ),
        ],
      ),
    );
  }

  void _showAddTodoDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter todo title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter todo description (optional)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                TodosHelper.createTodo(
                  titleController.text,
                  description: descriptionController.text.isEmpty 
                      ? null 
                      : descriptionController.text,
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

/// Todos page using PowerSync widgets
class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: TodosWidget(),
    );
  }
}

/// Lists page using PowerSync widgets
class ListsPage extends StatelessWidget {
  const ListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: ListsWidget(),
    );
  }
}
