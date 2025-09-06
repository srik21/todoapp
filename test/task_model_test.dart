import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/models/task_model.dart';

void main() {
  group('TaskModel Unit Tests', () {
    test('TaskModel toJson/fromJson works correctly', () {
      // Create a Task
      TaskModel task = TaskModel(
        title: 'Test Task',
        description: 'Test Description',
      );

      // Convert to JSON
      final json = task.toJson();
      expect(json['title'], 'Test Task');
      expect(json['description'], 'Test Description');
      expect(json['isComplete'], false);

      // Convert back from JSON
      TaskModel newTask = TaskModel.fromJson(json);
      expect(newTask.title, 'Test Task');
      expect(newTask.description, 'Test Description');
      expect(newTask.isComplete, false);
    });

    test('Toggle task completion works', () {
      TaskModel task = TaskModel(title: 'A', description: 'B');
      expect(task.isComplete, false);

      task.isComplete = !task.isComplete;
      expect(task.isComplete, true);
    });
  });
}
