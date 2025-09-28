import 'package:todolist/core/models/task_model.dart';
import 'package:todolist/core/provider/task_viewmodel.dart';

class MockTaskProvider extends TaskProvider {
  List<TaskModel> mockTasks = [];

  @override
  List<TaskModel> get tasks => mockTasks;

  @override
  Future<void> loadTasks() async {
    mockTasks = [];
    notifyListeners();
  }

  @override
  void addTask(TaskModel task) {
    mockTasks.add(task);
    notifyListeners();
  }

  @override
  void removeTask(TaskModel task) {
    mockTasks.remove(task);
    notifyListeners();
  }

  @override
  void changedFavorite(int index) {
    mockTasks[index].isFavorite = !mockTasks[index].isFavorite;
    notifyListeners();
  }
}
