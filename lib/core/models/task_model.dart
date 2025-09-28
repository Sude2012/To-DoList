import 'dart:ui';

import 'package:todolist/core/enums/week_of_days.dart';
import 'package:todolist/main.dart';
import 'package:uuid/uuid.dart';

class TaskModel {
  final String id;
  final WeekOfDays day;
  final String description;
  final String task;
  bool isFavorite;
  final Color borderColor;

  TaskModel({
    required this.id,
    required this.day,
    required this.description,
    required this.task,
    required this.isFavorite,
    required this.borderColor,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'].toString() ?? Uuid().v4(),
      day: WeekOfDays.values.firstWhere((e) => e.name == map['day']),
      description: map['description'],
      task: map["task"],
      isFavorite: map["isFavorite"] == 1,
      borderColor: Color(map['borderColor'] ?? 0xFFFFFFFF),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'description': description,
      'day': day.name,
      'isFavorite': isFavorite ? 1 : 0,
      'borderColor': borderColor.value,
    };
  }

  static String generateUniqeId() => uuid.v4();
}

var uuid = Uuid();
