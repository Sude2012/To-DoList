import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/core/models/task_model.dart';
import 'package:todolist/core/provider/task_viewmodel.dart';

class FavTask extends StatelessWidget {
  const FavTask({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final favoriteTasks = taskProvider.tasks
        .where((t) => t.isFavorite)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Favori Görevler"),
        backgroundColor: Color(0xFFCBDBA7),
      ),
      body: favoriteTasks.isEmpty
          ? const Center(child: Text("Henüz favori görev yok"))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: favoriteTasks.length,
                itemBuilder: (context, index) {
                  final task = favoriteTasks[index];
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: task.borderColor ?? Colors.grey,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        task.task,
                        style: const TextStyle(fontSize: 22),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Açıklama: ${task.description}\nGün: ${task.day.name}",
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
