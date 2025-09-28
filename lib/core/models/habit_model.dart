import 'package:flutter/material.dart';

class HabitModel {
  final String id;
  final String name;
  final int days;
  final List<int> completedDays; // Liste olarak saklıyoruz

  HabitModel({
    required this.id,
    required this.name,
    required this.days,
    required this.completedDays,
  });

  // DB’ye kaydetmek için Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'days': days,
      'completedDays': completedDays
          .toString(), // listeyi string olarak kaydediyoruz
    };
  }

  // DB’den okurken
  factory HabitModel.fromMap(Map<String, dynamic> map) {
    String completedDaysStr = map['completedDays'] ?? '[]';
    List<int> completedDaysList = completedDaysStr
        .replaceAll("[", "")
        .replaceAll("]", "")
        .split(",")
        .where((e) => e.isNotEmpty)
        .map((e) => int.parse(e.trim()))
        .toList();

    return HabitModel(
      id: map['id'],
      name: map['name'],
      days: map['days'],
      completedDays: completedDaysList,
    );
  }
}
