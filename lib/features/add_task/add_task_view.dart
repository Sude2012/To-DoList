import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/core/constant/string.dart';
import 'package:todolist/core/enums/week_of_days.dart';
import 'package:todolist/core/models/task_model.dart';
import 'package:todolist/core/provider/task_viewmodel.dart';

class Addtask extends StatefulWidget {
  const Addtask({Key? key, this.existingTask, required this.onSave})
    : super(key: key);

  final TaskModel? existingTask;
  final void Function(TaskModel task) onSave;

  @override
  State<Addtask> createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  WeekOfDays? selectedDay;
  Color selectedColor = const Color(0xFFC9463D);

  final List<Color> availableColors = [
    const Color(0xFF548D95),
    const Color(0xFF76C1C3),
    const Color(0xFF789342),
    const Color(0xFFCBDBA7),
    const Color(0xFFC9463D),
    const Color(0xFFA60303),
    const Color(0xFF730202),
    const Color(0xFF400101),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      taskController.text = widget.existingTask!.task;
      descriptionController.text = widget.existingTask!.description;
      selectedDay = widget.existingTask!.day;
      selectedColor =
          widget.existingTask!.borderColor ?? const Color(0xFFC9463D);
    } else {
      selectedDay = WeekOfDays.Monday;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
        backgroundColor: const Color(0xFFC9463D),
        toolbarHeight: 90,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            _buildTextField(taskController, "Task"),
            const SizedBox(height: 15),
            _buildTextField(descriptionController, "Description"),
            const SizedBox(height: 15),
            DropdownButtonFormField<WeekOfDays>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              hint: const Text("Choose Day"),
              value: selectedDay,
              isExpanded: true,
              onChanged: (WeekOfDays? newDay) {
                setState(() {
                  selectedDay = newDay;
                });
              },
              items: WeekOfDays.values.map((day) {
                return DropdownMenuItem<WeekOfDays>(
                  value: day,
                  child: Text(day.toString().split('.').last),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            Wrap(
              spacing: 8,
              children: availableColors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: selectedColor == color
                          ? Border.all(width: 3, color: Colors.black)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC9463D),
                minimumSize: const Size.fromHeight(45),
              ),
              onPressed: () {
                final updatedTask = TaskModel(
                  id: widget.existingTask?.id ?? TaskModel.generateUniqeId(),
                  task: taskController.text,
                  description: descriptionController.text,
                  day: selectedDay!,
                  isFavorite: widget.existingTask?.isFavorite ?? false,
                  borderColor: selectedColor,
                );
                widget.onSave(updatedTask);
                Navigator.pop(context);
              },
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextField _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
