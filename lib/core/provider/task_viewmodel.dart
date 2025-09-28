import 'package:flutter/material.dart';
import 'package:todolist/core/db/database_helper.dart';
import 'package:todolist/core/enums/week_of_days.dart';
import 'package:todolist/core/models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];
  int sayac = 0;

  List<TaskModel> get tasks => _tasks;

  TaskProvider() {
    loadTasks();
  }

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

  void addTask(TaskModel task) async {
    _tasks.add(task);
    await DatabaseHelper.insertTask(task);
    notifyListeners();
  }

  Future<void> loadTasks() async {
    _tasks = await DatabaseHelper.getTasks();
    notifyListeners();
  }

  void changedFavorite(int index) async {
    _tasks[index].isFavorite = !_tasks[index].isFavorite;
    sayac = _tasks.where((task) => task.isFavorite == true).length;

    await DatabaseHelper().updateTaskInDb(_tasks[index]);

    notifyListeners();
  }

  void removeTask(TaskModel task) async {
    _tasks.remove(task);
    await DatabaseHelper().deleteTaskById(task.id);
    notifyListeners();
  }

  void updateTask(TaskModel updatedTask) async {
    final index = tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      notifyListeners();

      await DatabaseHelper().updateTaskInDb(updatedTask);
    }
  }
}
