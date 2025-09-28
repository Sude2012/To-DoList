import 'package:flutter/material.dart';
import 'package:todolist/core/db/database_helper.dart';
import 'package:todolist/core/models/habit_model.dart';
import 'dart:math';

class HabitsView extends StatefulWidget {
  const HabitsView({super.key});

  @override
  State<HabitsView> createState() => _HabitsViewState();
}

class _HabitsViewState extends State<HabitsView> {
  List<Habit> habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final data = await DatabaseHelper().getAllHabits(); // List<HabitModel>
    setState(() {
      habits = data
          .map((h) => Habit(h.name, h.days, completedDays: h.completedDays))
          .toList();
    });
  }

  void _addHabit(Habit habit) async {
    final habitModel = habit.toHabitModel(DateTime.now().toIso8601String());
    await DatabaseHelper().insertHabit(habitModel);
    setState(() {
      habits.add(habit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habits", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFF76C1C3),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 30),
            onPressed: () => _showAddHabitDialog(),
          ),
        ],
      ),
      body: habits.isEmpty
          ? const Center(
              child: Text(
                "Henüz alışkanlık yok '+' butonuna tıklayarak başlayın",
                style: TextStyle(color: Colors.black),
              ),
            )
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: List.generate(habit.days, (dayIndex) {
                            final isCompleted = habit.completedDays.contains(
                              dayIndex + 1,
                            );
                            return GestureDetector(
                              onTap: () async {
                                setState(() {
                                  if (isCompleted) {
                                    habit.completedDays.remove(dayIndex + 1);
                                  } else {
                                    habit.completedDays.add(dayIndex + 1);
                                  }
                                });

                                // DB'ye kaydet
                                final habitModel = habit.toHabitModel(
                                  DateTime.now().toIso8601String(),
                                );
                                await DatabaseHelper().updateHabit(habitModel);
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: isCompleted
                                    ? const Color(0xFF789342)
                                    : Colors.grey[300],
                                child: Text(
                                  "${dayIndex + 1}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showAddHabitDialog() {
    final TextEditingController nameController = TextEditingController();
    int selectedDays = 1;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Alışkanlık Ekle"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Alışkanlık adı"),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Gün sayısı: "),
                DropdownButton<int>(
                  value: selectedDays,
                  items: List.generate(30, (i) => i + 1)
                      .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedDays = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final habit = Habit(nameController.text, selectedDays);
                _addHabit(habit);
                Navigator.pop(context);
              }
            },
            child: const Text("Tamam"),
          ),
        ],
      ),
    );
  }
}

class Habit {
  final String name;
  final int days;
  List<int> completedDays;

  Habit(this.name, this.days, {List<int>? completedDays})
    : completedDays = completedDays ?? [];

  HabitModel toHabitModel(String id) {
    return HabitModel(
      id: id,
      name: name,
      days: days,
      completedDays: completedDays,
    );
  }
}
