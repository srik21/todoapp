import 'dart:convert';
import 'package:flutter/material.dart';
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

  void loadTasks() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tasksString = prefs.getString(_storageKey);

      if (tasksString != null) {
        List decoded = jsonDecode(tasksString);
        tasks.value = decoded.map((e) => TaskModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error loading tasks: $e");
      tasks.value = [];
      Get.snackbar(
        "Error",
        "Failed to load tasks",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      isLoading.value = false;
    }
  }

  void _saveTasks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List encoded = tasks.map((e) => e.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(encoded));
    } catch (e) {
      print("Error saving tasks: $e");
      Get.snackbar(
        "Error",
        "Failed to save tasks",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void addTask(String title, String description) {
    if (title.trim().isNotEmpty && description.trim().isNotEmpty) {
      tasks.add(TaskModel(title: title.trim(), description: description.trim()));
      tasks.refresh();
      _saveTasks();
      Get.snackbar(
        "Success",
        "Task added successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Error",
        "Title and description cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void toggleComplete(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks[index].isComplete = !tasks[index].isComplete;
      String taskTitle = tasks[index].title;
      String status = tasks[index].isComplete ? "completed" : "uncompleted";
      tasks.refresh();
      _saveTasks();
      Get.snackbar(
        "Task Updated",
        "$taskTitle marked as $status",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void deleteTask(int index) {
    if (index >= 0 && index < tasks.length) {
      String taskTitle = tasks[index].title;
      tasks.removeAt(index);
      tasks.refresh();
      _saveTasks();
      Get.snackbar(
        "Task Deleted",
        "$taskTitle has been removed",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void clearAllTasks() {
    tasks.clear();
    tasks.refresh();
    _saveTasks();
    Get.snackbar(
      "Tasks Cleared",
      "All tasks have been removed",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}