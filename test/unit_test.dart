import 'package:task_manager/models/task.dart';
import 'package:test/test.dart';

void main() {
  group("Task model - Constructor and Properties", () {
    late Task task;
    setUp(() {
      task = Task(
        id: '00',
        title: 'Test00',
        dueDate: DateTime(2025, 3, 10, 21, 15),
      );
    });

    test(
      'Default Values: Task model should have correct default values for optional properties',

      () {
        //assert
        expect(task.description, '');
        expect(task.isCompleted, false);
      },
    );
    test("Required fields: Task model should have correct required values", () {
      //assert
      expect(task.id, '00');
      expect(task.title, 'Test00');
    });
    test(
      "Priority assignment: Task model should have correct default priority value",
      () {
        //assert
        expect(task.priority, Priority.medium);
      },
    );
    test(
      'Due date assignment: Task model should have correct due date value',
      () {
        //assert
        expect(task.dueDate, DateTime(2025, 3, 10, 21, 15));
      },
    );
  });

  group('Task model - CopyWith', () {
    late Task task;
    setUp(() {
      task = Task(
        id: '00',
        title: 'Test00',
        dueDate: DateTime(2025, 3, 10, 21, 15),
      );
    });
    test('Partial update: copyWith should update only provided fields ', () {
      //act
      task = task.copyWith(
        title: 'Updated task',
        priority: Priority.medium,
        isCompleted: true,
      );

      //assert
      expect(task.id, '00'); // unchanged
      expect(task.title, 'Updated task'); // updated
    });
    test('Full update: copyWith should update all fields when provided', () {
      //act
      task = task.copyWith();
      //assert
    });
    test('Original unchange: copyWith should not modify the original task', () {
      //act
      task = task.copyWith();
      //assert
    });
  });
  group('Task Model — isOverdue getter', () {
    test(
      'isOverdue getter: isOverdue should return true when dueDate is past and task is incomplete',
      () {
        //act
      },
      //assert
    );
    test(
      'isOverdue getter: should return false when dueDate is in the future',
      () {
        //act
      },
      //assert
    );
    test(
      'isOverdue getter: should return false when task is completed even if past due',
      () {
        //act
      },
      //assert
    );
  });

  group('Task Model - toJson() / fromJson()', () {
    test(
      'toJson()/fromJson(): toJson and fromJson should correctly serialize and deserialize a task',
      () {
        //act
      },
      //assert
    );
    test(
      'toJson()/fromJson(): fromJson should restore correct field types',
      () {
        //act
      },
      //assert
    );
    test(
      'toJson()/fromJson(): toJson should map priority using index correctlys',
      () {
        //act
      },
      //assert
    );
  });
}
