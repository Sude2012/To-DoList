import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/core/constant/string.dart';
import 'package:todolist/core/enums/week_of_days.dart';
import 'package:todolist/core/provider/task_viewmodel.dart';
import 'package:todolist/main.dart';
import 'package:todolist/core/models/task_model.dart';

class Addtask extends StatefulWidget {
  Addtask({Key? key, required this.onSave}) : super(key: key);
  final void Function(TaskModel task) onSave;
  @override
  State<Addtask> createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  WeekOfDays? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.addtask)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: taskController,

                decoration: InputDecoration(
                  hintText: AppStrings.task,
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildDescriptionTextField(),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<WeekOfDays>(
                    decoration: InputDecoration(border: OutlineInputBorder()),

                    hint: Text(AppStrings.choose_day),
                    value: selectedDay ?? WeekOfDays.Monday,
                    isExpanded: true,
                    onChanged: (WeekOfDays? newDay) {
                      setState(() {
                        selectedDay = newDay;
                      });
                    },
                    items: WeekOfDays.values.map((day) {
                      return DropdownMenuItem<WeekOfDays>(
                        value: day,
                        child: Text(day.name),
                      );
                    }).toList(),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40, left: 230, right: 30),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 195, 41, 14),
              minimumSize: Size(10, 45),
            ),
            onPressed: () {
              final taskText = taskController.text;
              final descriptionText = descriptionController.text;
              final day = selectedDay;

              final errorMessage = context
                  .read<TaskProvider>()
                  .validateTaskInput(taskText, descriptionText, day);

              if (errorMessage != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(errorMessage)));
                return;
              }

              context.read<TaskProvider>().addTask(
                TaskModel(
                  task: taskText,
                  description: descriptionText,
                  day: day!,
                  isFavorite: false,
                ),
              );

              Navigator.pop(context);
            },

            child: Text(
              AppStrings.submit,
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }

  TextField _buildDescriptionTextField() {
    return TextField(
      controller: descriptionController,
      decoration: InputDecoration(
        hintText: AppStrings.descript,
        border: OutlineInputBorder(),
      ),
    );
  }
}
