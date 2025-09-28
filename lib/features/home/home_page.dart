import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/core/models/task_model.dart';
import 'package:todolist/core/provider/task_viewmodel.dart';
import 'package:todolist/features/add_task/add_task_view.dart';
import 'package:todolist/features/calendar/calendar_view.dart';
import 'package:todolist/features/fav_task/fav_task_view.dart';
import 'package:todolist/features/habits/habits_view.dart';
import 'package:todolist/features/profile/profile_view.dart';
import 'package:todolist/features/settings/settings_view.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC9463D),
        title: Text("To Do List"),
      ),
      body: Column(
        children: [
          Selector<TaskProvider, int>(
            selector: (_, provider) => provider.sayac,
            builder: (_, sayac, __) => Text("Favori sayınız: $sayac"),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: tasks.isEmpty
                  ? const Center(child: Text("Henüz görev yok"))
                  : _buildTaskListView(tasks, taskProvider),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              width: 100,
              height: 120,
              child: const DrawerHeader(
                decoration: BoxDecoration(color: const Color(0xFFC9463D)),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home Page'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Favorite Tasks'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavTask()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: const Text('Habits'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HabitsView()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Calendar'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalendarPage()),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 300),
              color: const Color.fromARGB(255, 248, 247, 247),
              child: ListTile(
                leading: const Icon(Icons.settings, size: 29),
                title: const Text('Settings', style: TextStyle(fontSize: 19)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsView(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildAddTaskButton(context),
    );
  }

  FloatingActionButton _buildAddTaskButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFFC9463D),
      child: const Icon(Icons.add, color: Colors.white, size: 35),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Addtask(
              onSave: (task) {
                context.read<TaskProvider>().addTask(task);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskListView(List<TaskModel> tasks, TaskProvider taskProvider) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return SizedBox(
          height: 130,
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: task.borderColor ?? Colors.grey,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(task.task, style: const TextStyle(fontSize: 22)),
              subtitle: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "Açıklama: ${task.description}\nGün: ${task.day.name}",
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.star,
                      color: task.isFavorite
                          ? Colors.amber
                          : const Color.fromARGB(255, 140, 117, 117),
                    ),
                    onPressed: () {
                      taskProvider.changedFavorite(index);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.update, color: Colors.black87),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Addtask(
                            existingTask: task,
                            onSave: (updatedTask) {
                              context.read<TaskProvider>().updateTask(
                                updatedTask,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Color(0xFFA60303)),
                    onPressed: () {
                      taskProvider.removeTask(task);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
