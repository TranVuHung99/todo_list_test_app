import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/controllers/todo_controller.dart';
import 'package:test_app/data/models/todo.dart';
import 'package:test_app/data/todo_repository/todo_repository.dart';
import 'package:test_app/ui/components/todo_item.dart';
import 'package:test_app/ui/components/todo_list_view.dart';
import 'package:test_app/ui/screens/todo_page/incomplete_todo_screen.dart';
import '../../helper/pump_app.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

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
  late TodoRepository repository;
  group('InCompletedTodoScreen', () {
    setUp(() {
      repository = MockTodoRepository();
      when(
              () => repository.getTodos()
      ).thenAnswer((_) => Stream.value(mockTodos));

    });

    Widget buildSubject({List<Todo> todos = const <Todo>[]}) {
      Get.lazyPut<TodoController>(() => TodoController(repository: repository));
      return InCompletedTodoScreen();
    }

    testWidgets('renders InCompletedTodoScreen', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(InCompletedTodoScreen), findsOneWidget);
    });

    testWidgets(
      'renders AppBar with title text',
          (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(AppBar), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('UnCompleted Tasks'),
          ),
          findsOneWidget,
        );
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
      'renders uncompleted todos',
          (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(TodoItem),
            findsNWidgets(mockTodos.where((t) => !t.isCompleted).length)
        );
        expect(find.descendant(
            of: find.byType(TodoItem),
            matching: find.byWidgetPredicate((w) =>  w is Checkbox && w.value == true)
        ), findsNothing);
      },
    );
  });
}