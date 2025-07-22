import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/core/provider/task_provider.dart';
import 'package:todolist/features/add_task/add_task_view.dart';
import 'package:todolist/core/constant/string.dart';
import 'package:todolist/core/models/task_model.dart';
import 'package:todolist/features/home/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final provider = TaskProvider();
        final initialTasks = jsonList
            .map((e) => TaskModel.fromJson(e))
            .toList();
        provider.loadInitialTasks(initialTasks);
        return provider;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 130, 48, 18),
        ),
      ),
      home: const TaskListPage(title: AppStrings.submit),
    );
  }
}
