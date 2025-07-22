import 'package:todolist/core/enums/week_of_days.dart';
import 'package:todolist/main.dart';

class TaskModel {
  final WeekOfDays day;
  final String description;
  final String task;

  TaskModel({required this.day, required this.description, required this.task});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      day: WeekOfDays.values.firstWhere((e) => e.name == json['day']),
      description: json['description'],
      task: json["task"],
    );
  }
}

final jsonList = [
  {"day": "Monday", "description": "Flutter dersi çalış", "task": "Ders Çalış"},
  {"day": "Tuesday", "description": "Spor yap", "task": "Basketbol"},
  {"day": "Wednesday", "description": "Ödev yap", "task": "Matematik ödevi"},
  {"day": "Thursday", "description": "Toplantı", "task": "İş toplantısı"},
  {"day": "Friday", "description": "Etkinliğe katıl", "task": "Mezuniyet"},
];

final tasks = jsonList.map((e) => TaskModel.fromJson(e)).toList();
