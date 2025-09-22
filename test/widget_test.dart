// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:powersynctodo/main.dart';
import 'package:powersynctodo/providers/todo_provider.dart';

void main() {
  testWidgets('App starts and shows todo list', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => TodoProvider(),
        child: const PowerSyncTodoApp(),
      ),
    );

    // Verify that our app shows the todo list page
    expect(find.text('PowerSync Todo'), findsOneWidget);
    
    // Wait for the app to load and check for either loading or no todos message
    await tester.pumpAndSettle();
    
    // Check if either loading or no todos message is shown
    final hasLoadingText = find.text('Loading...').evaluate().isNotEmpty;
    final hasNoTodosText = find.text('No todos yet').evaluate().isNotEmpty;
    expect(hasLoadingText || hasNoTodosText, isTrue);
  });
}
