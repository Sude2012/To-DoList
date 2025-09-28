import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todolist/core/models/habit_model.dart';
import 'package:todolist/core/models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;
  static String? _dbPath;

  static void setTestDbPath(String path) {
    _dbPath = path;
  }

  Future<Database?> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db;
  }

  Future<Database?> _initDb() async {
    final dbPath = _dbPath ?? await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  /// Tabloları oluşturuyoruz
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        task TEXT,
        description TEXT,
        day TEXT,
        isFavorite INTEGER,
        borderColor INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE habits (
        id TEXT PRIMARY KEY,
        name TEXT,
        days INTEGER,
        completedDays TEXT
      )
    ''');
  }

  // ------------------ TASK İşlemleri ------------------

  static Future<void> insertTask(TaskModel task) async {
    final db = await DatabaseHelper().db;
    await db!.insert('tasks', task.toMap());
  }

  Future<List<TaskModel>> getAllTasks() async {
    final dbClient = await db;
    final result = await dbClient!.query('tasks');
    return result.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<void> deleteTaskById(String id) async {
    final dbClient = await db;
    await dbClient!.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<TaskModel>> getTasks() async {
    final db = await DatabaseHelper().db;
    final List<Map<String, dynamic>> maps = await db!.query('tasks');
    return List.generate(maps.length, (index) {
      return TaskModel.fromMap(maps[index]);
    });
  }

  Future<void> updateTaskInDb(TaskModel task) async {
    final dbClient = await db;
    await dbClient!.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // ------------------ HABIT İşlemleri ------------------

  Future<void> insertHabit(HabitModel habit) async {
    final dbClient = await db;
    await dbClient!.insert('habits', habit.toMap());
  }

  Future<List<HabitModel>> getAllHabits() async {
    final dbClient = await db;
    final result = await dbClient!.query('habits');
    return result.map((e) => HabitModel.fromMap(e)).toList();
  }

  Future<void> updateHabit(HabitModel habit) async {
    final dbClient = await db;
    await dbClient!.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<void> deleteHabitById(String id) async {
    final dbClient = await db;
    await dbClient!.delete('habits', where: 'id = ?', whereArgs: [id]);
  }
}
