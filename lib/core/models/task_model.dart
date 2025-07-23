import 'package:todolist/core/enums/week_of_days.dart';
import 'package:todolist/main.dart';

class TaskModel {
  final WeekOfDays day;
  final String description;
  final String task;

  bool isFavorite;

  TaskModel({
    required this.day,
    required this.description,
    required this.task,
    required this.isFavorite,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      day: WeekOfDays.values.firstWhere((e) => e.name == json['day']),
      description: json['description'],
      task: json["task"],
      isFavorite: json["isFavorite"],
    );
  }
}

final jsonList = [
  {
    "day": "Monday",
    "description": "Flutter dersi çalış",
    "task": "Ders Çalış",
    "isFavorite": false,
  },
  {
    "day": "Tuesday",
    "description": "Spor yap",
    "task": "Basketbol",
    "isFavorite": false,
  },
  {
    "day": "Wednesday",
    "description": "Ödev yap",
    "task": "Matematik ödevi",
    "isFavorite": false,
  },
  {
    "day": "Thursday",
    "description": "Toplantı",
    "task": "İş toplantısı",
    "isFavorite": false,
  },
  {
    "day": "Friday",
    "description": "Etkinliğe katıl",
    "task": "Mezuniyet",
    "isFavorite": true,
  },
];

final tasks = jsonList.map((e) => TaskModel.fromJson(e)).toList();
