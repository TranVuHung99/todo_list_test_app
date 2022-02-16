import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/controllers/todo_controller.dart';
import 'package:test_app/data/models/todo.dart';
import 'package:test_app/ui/components/todo_item.dart';
import 'package:test_app/ui/components/todo_list_view.dart';
import 'package:test_app/ui/components/todos_view_option_button.dart';
import 'package:test_app/ui/screens/todo_page/all_todo_screen.dart';
import '../../helper/pump_app.dart';

class MockTodoController extends GetxController with Mock implements TodoController {}


void main() {
  final mockTodos = [
    Todo(
      id: '1',
      title: 'title 1',
      desc: 'description 1',
    ),
    Todo(
      id: '2',
      title: 'title 2',
      desc: 'description 2',
    ),
    Todo(
      id: '3',
      title: 'title 3',
      desc: 'description 3',
      isCompleted: true,
    ),
  ];
  late TodoController controller;

  group('AllTodoScreen', () {
    setUp(() {
      controller = MockTodoController();
      when(
          () => controller.todos
      ).thenReturn(mockTodos.obs);
    });

    Widget buildSubject({List<Todo> todos = const <Todo>[]}) {
      Get.lazyPut<TodoController>(() => controller);
      return AllTodoScreen();
    }

    testWidgets('renders AllTodoScreen', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(AllTodoScreen), findsOneWidget);
      Get.reset();
    });

    testWidgets(
      'renders AppBar with title text',
          (tester) async {
        await tester.pumpApp(buildSubject(),);

        expect(find.byType(AppBar), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('All Tasks'),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders TodoViewOptionButtons',
          (tester) async {
        await tester.pumpApp(buildSubject(),);

        expect(find.byType(TodoViewOptionButtons), findsOneWidget);
      },
    );

    testWidgets(
      'renders TodoListView',
          (tester) async {
        await tester.pumpApp(buildSubject(),);

        expect(find.byType(TodoListView), findsOneWidget);
      },
    );

    testWidgets(
      'renders all todos',
          (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(TodoItem), findsNWidgets(mockTodos.length));
      },
    );
  });
}