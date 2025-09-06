import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskController extends GetxController {
  var tasks = <TaskModel>[].obs;
  var isLoading = true.obs;

  final String _storageKey = "tasks_data";

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  /// Load tasks from SharedPreferences
  void loadTasks() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksString = prefs.getString(_storageKey);

    if (tasksString != null) {
      List decoded = jsonDecode(tasksString);
      tasks.value = decoded.map((e) => TaskModel.fromJson(e)).toList();
    }

    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }

  /// Save tasks to SharedPreferences
  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List encoded = tasks.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(encoded));
  }

  /// Add a new task
  void addTask(String title, String description) {
    tasks.add(TaskModel(title: title, description: description));
    _saveTasks();
  }

  /// Toggle complete/incomplete
  void toggleComplete(int index) {
    tasks[index].isComplete = !tasks[index].isComplete;
    tasks.refresh();
    _saveTasks();
  }

  /// Delete a task
  void deleteTask(int index) {
    tasks.removeAt(index);
    _saveTasks();
  }

  /// Clear all tasks (optional)
  void clearAllTasks() {
    tasks.clear();
    _saveTasks();
  }
}
