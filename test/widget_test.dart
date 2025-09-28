import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todolist/core/enums/week_of_days.dart';
import 'package:todolist/core/models/task_model.dart';
import 'package:todolist/core/provider/task_viewmodel_mock.dart';
import 'package:todolist/features/add_task/add_task_view.dart';
import 'package:todolist/core/provider/task_viewmodel.dart';

void main() {
  group('Addtask Widget Tests with MockTaskProvider', () {
    late TaskModel? savedTask;
    late MockTaskProvider mockProvider;

    setUp(() {
      savedTask = null;
      mockProvider = MockTaskProvider();
    });

    Widget createWidgetUnderTest() {
      return ChangeNotifierProvider<TaskProvider>.value(
        value: mockProvider,
        child: MaterialApp(
          home: Addtask(
            onSave: (task) {
              savedTask = task;
              mockProvider.addTask(task);
            },
          ),
        ),
      );
    }

    testWidgets('Renders inputs and dropdown with default selection', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(TextField).at(0), findsOneWidget);
      expect(find.byType(TextField).at(1), findsOneWidget);

      expect(find.byType(DropdownButtonFormField<WeekOfDays>), findsOneWidget);

      expect(find.text('Monday'), findsWidgets);
    });

    testWidgets('Submit button triggers onSave with correct TaskModel', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField).at(0), 'Mock Task');
      await tester.enterText(find.byType(TextField).at(1), 'Mock Description');

      final submitButton = find.byKey(const Key('submitButton'));
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(savedTask, isNotNull);
      expect(savedTask!.task, 'Mock Task');
      expect(savedTask!.description, 'Mock Description');
      expect(savedTask!.day, WeekOfDays.Monday);

      expect(mockProvider.mockTasks.contains(savedTask), isTrue);
      expect(mockProvider.tasks.length, 1);
    });

    testWidgets('Shows snackbar error if description is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField).at(0), 'Task title only');
      await tester.enterText(find.byType(TextField).at(1), '');

      await tester.tap(find.byKey(const Key('submitButton')));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(savedTask, isNull);
    });

    test('Favorite toggle changes task.isFavorite', () {
      final task = TaskModel(
        id: '1',
        task: 'Favorite test',
        description: 'desc',
        day: WeekOfDays.Tuesday,
        isFavorite: false,
        borderColor: Colors.black,
      );
      mockProvider.addTask(task);
      expect(mockProvider.tasks[0].isFavorite, isFalse);

      mockProvider.changedFavorite(0);
      expect(mockProvider.tasks[0].isFavorite, isTrue);

      mockProvider.changedFavorite(0);
      expect(mockProvider.tasks[0].isFavorite, isFalse);
    });

    testWidgets('Allows submitting with empty description', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(
        find.byType(TextField).at(0),
        'Task with no description',
      );
      await tester.enterText(find.byType(TextField).at(1), '');

      final submitButton = find.byKey(const Key('submitButton'));
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(savedTask, isNotNull);
      expect(savedTask!.description, '');
      expect(mockProvider.tasks.contains(savedTask), isTrue);
    });
  });
}
