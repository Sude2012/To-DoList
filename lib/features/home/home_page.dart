import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/core/models/task_model.dart';
import 'package:todolist/core/provider/task_provider.dart';
import 'package:todolist/features/add_task/add_task_view.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key, required this.title});
  final String title;

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: tasks.isEmpty
            ? Center(child: Text("Henüz görev yok"))
            : _buildTaskListView(tasks),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 202, 47, 36),
        child: const Icon(Icons.add, color: Colors.white, size: 35),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: false,
            builder: (context) => Addtask(
              onSave: (task) {
                context.read<TaskProvider>().addTask(task);
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskListView(List<TaskModel> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          child: ListTile(
            title: Text(task.task),
            subtitle: Text(
              "Açıklama: ${task.description}\nGün: ${task.day.name}",
            ),
          ),
        );
      },
    );
  }
}
