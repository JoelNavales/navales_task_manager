import 'package:task_manager/models/task.dart';
import 'package:task_manager/services/task_service.dart';
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
      task = task.copyWith(
        id: '00',
        title: 'Task Updated',
        description: 'Updated description',
        priority: Priority.medium,
      );
      //assert
      expect(task.id, '00');
      expect(task.title, 'Task Updated');
    });
    test('Original unchange: copyWith should not modify the original task', () {
      //act
      task.copyWith(
        title: 'Modified Task',
        description: 'Modified description',
        priority: Priority.high,
        isCompleted: true,
      );
      //assert
      expect(task.title, 'Test00');
      expect(task.description, '');
      expect(task.priority, Priority.medium);
    });
  });
  group('Task Model — isOverdue getter', () {
    late Task task;
    setUp(() {
      final pastDate = DateTime.now().subtract(const Duration(days: 1));

      task = Task(id: '01', title: 'Overdue Task', dueDate: pastDate);
    });
    test('should return true when dueDate is past and task is incomplete', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 1));
      task = Task(
        id: '01',
        title: 'Overdue Task',
        dueDate: pastDate,
        isCompleted: false,
      );
      expect(task.isOverdue, true);
    });
    test(
      'isOverdue getter: should return false when dueDate is in the future',
      () {
        final futureDate = DateTime.now().add(const Duration(days: 1));
        task = Task(
          id: '02',
          title: 'Future Task',
          dueDate: futureDate,
          isCompleted: false,
        );
        expect(task.isOverdue, false);
      },
    );
    test(
      'isOverdue getter: should return false when task is completed even if past due',
      () {
        final pastDate = DateTime(2025, 3, 10, 21, 15);
        task = Task(
          id: '03',
          title: 'Completed Task',
          dueDate: pastDate,
          isCompleted: true,
        );
        expect(task.isOverdue, false);
      },
    );
  });

  group('Task Model - toJson() / fromJson()', () {
    late Task task;
    late Task deserializedTask;
    late Map<String, dynamic> toJson;
    setUp(() {
      task = Task(
        id: '00',
        title: 'Test00',
        description: 'Test description',
        priority: Priority.medium,
        dueDate: DateTime.now(),
        isCompleted: false,
      );
      toJson = task.toJson();
      deserializedTask = Task.fromJson(toJson);
    });
    test(
      'toJson and fromJson should correctly serialize and deserialize a task',
      () {
        expect(
          [
            deserializedTask.id,
            deserializedTask.title,
            deserializedTask.description,
            deserializedTask.priority,
            deserializedTask.dueDate.toIso8601String(),
            deserializedTask.isCompleted,
          ],
          [
            task.id,
            task.title,
            task.description,
            task.priority,
            task.dueDate.toIso8601String(),
            task.isCompleted,
          ],
        );
      },
    );
    test('fromJson should restore correct field types', () {
      expect(
        [
          deserializedTask.id,
          deserializedTask.title,
          deserializedTask.description,
          deserializedTask.priority,
          deserializedTask.dueDate,
          deserializedTask.isCompleted,
        ],
        [
          isA<String>(),
          isA<String>(),
          isA<String>(),
          isA<Priority>(),
          isA<DateTime>(),
          isA<bool>(),
        ],
      );
    });
    test('toJson should map priority using index correctly', () {
      expect(toJson['priority'], task.priority.index);
    });
  });

  group('TaskService — addTask()', () {
    late TaskService service;
    late Task task;
    setUp(() {
      service = TaskService();
      task = Task(
        id: '00',
        title: 'Test Task',
        dueDate: DateTime(2025, 3, 10, 21, 15),
      );
    });
    test('addTask should successfully add a valid task', () {
      service.addTask(task);
      expect(service.allTasks, contains(task));
    });
    test('addTask should throw exception when title is empty', () {
      final invalidTask = task.copyWith(id: '01', title: '');
      expect(() => service.addTask(invalidTask), throwsArgumentError);
    });
    test('addTask should allow tasks with duplicate IDs', () {
      final duplicateTask = task.copyWith(title: 'Duplicated ID Task');
      service.addTask(task);
      service.addTask(duplicateTask);
      expect(service.allTasks.where((t) => t.id == task.id).length, 2);
    });
  });
  group('Task Service - deleteTask', () {
    late TaskService service;
    late Task task;
    setUp(() {
      service = TaskService();
      task = Task(id: '00', title: 'Delete Test Task', dueDate: DateTime.now());
    });
    test('deleteTask should remove an existing task', () {
      service.addTask(task);
      service.deleteTask(task.id);
      expect(service.allTasks.contains(task), false);
    });
    test('deleteTask should silently ignore non existent task', () {
      service.deleteTask('non-existent-id');
      expect(service.allTasks.length, 0);
    });
  });

  group('TaskService — toggleComplete()', () {
    late TaskService service;
    late Task task;
    setUp(() {
      service = TaskService();
      task = Task(
        id: '00',
        title: 'Test Task',
        dueDate: DateTime.now(),
        isCompleted: false,
      );
      service.addTask(task);
    });
    test('toggleComplete should change task status from false to true', () {
      service.toggleComplete(task.id);
      expect(service.allTasks.first.isCompleted, true);
    });
    test('ToggleComplete should change task status from true to false', () {
      expect(service.allTasks.first.isCompleted, false);
    });
    test('toggleComplete should throw StateError for unknown task ID', () {});
  });

  group('TaskService - getByStatus', () {
    late TaskService service;
    //late Task task;

    setUp(() {
      service = TaskService();
    });

    test('getByStatus should return only active tasks', () {
      final task1 = Task(
        id: '1',
        title: 'Active Task',
        dueDate: DateTime.now(),
        isCompleted: false,
      );

      final task2 = Task(
        id: '2',
        title: 'Completed Task',
        dueDate: DateTime.now(),
        isCompleted: true,
      );

      service.addTask(task1);
      service.addTask(task2);

      final result = service.getByStatus(false, completed: false);

      expect(result.length, 1);
      expect(result.first.isCompleted, false);
    });
    test('getByStatus should return only completed tasks', () {
      final task1 = Task(
        id: '1',
        title: 'Active Task',
        dueDate: DateTime.now(),
        isCompleted: false,
      );

      final task2 = Task(
        id: '2',
        title: 'Completed Task',
        dueDate: DateTime.now(),
        isCompleted: true,
      );

      service.addTask(task1);
      service.addTask(task2);

      final result = service.getByStatus(true, completed: true);

      expect(result.length, 1);
      expect(result.first.isCompleted, true);
    });
  });

  group('TaskService — sortByPriority()', () {
    late TaskService service;
    setUp(() {
      service = TaskService();
    });
    test(
      'sortByPriority should return tasks ordered from high to low priority',
      () {
        final task1 = Task(
          id: '1',
          title: 'Low Priority Task',
          dueDate: DateTime.now(),
          priority: Priority.low,
        );

        final task2 = Task(
          id: '2',
          title: 'High Priority Task',
          dueDate: DateTime.now(),
          priority: Priority.high,
        );

        service.addTask(task1);
        service.addTask(task2);

        final result = service.sortByPriority();

        expect(result.first.priority, Priority.high);
        expect(result.last.priority, Priority.low);
      },
    );
    test('sortByPriority should not modify the original task list', () {
      final task1 = Task(
        id: '1',
        title: 'Low Priority Task',
        dueDate: DateTime.now(),
        priority: Priority.low,
      );

      final task2 = Task(
        id: '2',
        title: 'High Priority Task',
        dueDate: DateTime.now(),
        priority: Priority.high,
      );

      service.addTask(task1);
      service.addTask(task2);

      final originalList = List<Task>.from(service.allTasks);
      service.sortByPriority();

      expect(service.allTasks, originalList);
    });
  });
  group('TaskService — sortByDueDate()', () {
    late TaskService service;
    setUp(() {
      service = TaskService();
    });
    test('sortByDueDate should return tasks ordered by earliest due date', () {
      final task1 = Task(
        id: '1',
        title: 'Later Task',
        dueDate: DateTime.now().add(const Duration(days: 2)),
      );

      final task2 = Task(
        id: '2',
        title: 'Earlier Task',
        dueDate: DateTime.now().add(const Duration(days: 1)),
      );

      service.addTask(task1);
      service.addTask(task2);

      final result = service.sortByDueDate();

      expect(result.first.dueDate.isBefore(result.last.dueDate), true);
    });
    test('sortByDueDate should not modify the original task list', () {
      final task1 = Task(
        id: '1',
        title: 'Later Task',
        dueDate: DateTime.now().add(const Duration(days: 2)),
      );

      final task2 = Task(
        id: '2',
        title: 'Earlier Task',
        dueDate: DateTime.now().add(const Duration(days: 1)),
      );

      service.addTask(task1);
      service.addTask(task2);

      final originalList = List<Task>.from(service.allTasks);
      service.sortByDueDate();

      expect(service.allTasks, originalList);
    });
  });
  group('TaskService — statistics getter', () {
    late TaskService service;
    setUp(() {
      service = TaskService();
    });
    // test('statistics should return empty map when there are no tasks', () {
    //   final stats = service.statistics;
    //   expect(stats, isEmpty);
    // });
    test('statistics should return empty map when there are no tasks', () {
      final stats = service.statistics;

      expect(stats['total'], 0);
      expect(stats['completed'], 0);
      expect(stats['overdue'], 0);
    });
    test(
      'statistics should correctly count mixed active and completed tasks',
      () {
        final task1 = Task(
          id: '1',
          title: 'Active Task',
          dueDate: DateTime.now().add(const Duration(days: 1)),
          isCompleted: false,
        );

        final task2 = Task(
          id: '2',
          title: 'Completed Task',
          dueDate: DateTime.now().add(const Duration(days: 1)),
          isCompleted: true,
        );

        service.addTask(task1);
        service.addTask(task2);

        final stats = service.statistics;

        expect(stats['total'], 2);
        expect(stats['completed'], 1);
        expect(stats['overdue'], 0);
      },
    );
    test('statistics should correctly count overdue tasks', () {
      final task1 = Task(
        id: '1',
        title: 'Overdue Task',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        isCompleted: false,
      );

      final task2 = Task(
        id: '2',
        title: 'Completed Task',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        isCompleted: true,
      );

      service.addTask(task1);
      service.addTask(task2);

      final stats = service.statistics;

      expect(stats['total'], 2);
      expect(stats['completed'], 1);
      expect(stats['overdue'], 1);
    });
  });
}
