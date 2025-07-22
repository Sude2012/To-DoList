import 'package:flutter/material.dart';
import 'package:todolist/core/models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  void addTask(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(TaskModel task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void loadInitialTasks(List<TaskModel> jsonTasks) {
    _tasks.addAll(jsonTasks);
    notifyListeners();
  }
}
