import 'package:flutter/material.dart';
import 'package:todolist/core/enums/week_of_days.dart';
import 'package:todolist/core/models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final List<TaskModel> _tasks = [];
  int sayac = 0;

  List<TaskModel> get tasks => _tasks;

  String? validateTaskInput(String task, String description, WeekOfDays? day) {
    if (day == null) {
      return "Lütfen bir gün seçin.";
    }
    if (task.isEmpty) {
      return "Görev adı boş olamaz.";
    }
    if (description.isEmpty) {
      return "Açıklama boş olamaz.";
    }
    return null;
  }

  void addTaskWithValidation(
    String task,
    String description,
    WeekOfDays day,
    BuildContext context,
  ) {
    final errorMessage = validateTaskInput(task, description, day);
    if (errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }
    final newTask = TaskModel(
      task: task,
      description: description,
      day: day,
      isFavorite: false,
    );
    _tasks.add(newTask);
    notifyListeners();
  }

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

  void changedFavorite(int index) {
    _tasks[index].isFavorite = !_tasks[index].isFavorite;
    sayac = _tasks.where((task) => task.isFavorite == true).length;
    notifyListeners();
  }
}
