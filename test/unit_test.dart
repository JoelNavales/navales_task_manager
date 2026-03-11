import 'package:flutter_test/flutter_test.dart';
import '../lib/models/task.dart';

void main() {
  group('Task Model Test', () {
    test('Task constructor assigns value correctly', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'This is a test task',
        priority: Priority.high,
        dueDate: DateTime(2026, 3, 20),
        isCompleted: true,
      );
    });
  });
}
