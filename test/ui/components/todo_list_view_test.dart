import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/controllers/todo_controller.dart';
import 'package:test_app/data/models/todo.dart';
import 'package:test_app/ui/components/todo_item.dart';
import 'package:test_app/ui/components/todo_list_view.dart';
import '../helper/pump_app.dart';

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

  group('TodoListView', () {

    setUp(() {
      controller = MockTodoController();
    });

    Widget buildSubject({List<Todo> todos = const <Todo>[]}) {
      Get.lazyPut<TodoController>(() => controller);
      return TodoListView(todos: todos);
    }
    group('constructor', () {
      test('works properly', () {
        expect(
              () {
              Get.lazyPut<TodoController>(() => controller);
              return TodoListView(todos: const <Todo>[]);
          },
          returnsNormally,
        );

        Get.reset();
      });
    });

    group('internal TodoListView', () {

      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(TodoListView), findsOneWidget);
        Get.reset();
      });
      
      group('render todos list item', () {
        
        testWidgets('when todos is empty ', (tester) async {
          await tester.pumpApp(buildSubject());

          expect(find.byType(TodoItem), findsNothing);
          Get.reset();
        });

        testWidgets('when todos is not empty ', (tester) async {
          await tester.pumpApp(buildSubject(todos: mockTodos));

          expect(find.byType(ListView), findsOneWidget);
          expect(find.byType(TodoItem), findsNWidgets(mockTodos.length));
          Get.reset();
        });

        group('TodoItem interacted', () {
          testWidgets('onToggle call ', (tester) async {
            final todo = mockTodos.first;
            when(
                    () => controller.onUpdateCompleted(todo, !todo.isCompleted)
            ).thenAnswer((_) async {});
            await tester.pumpApp(buildSubject(todos: mockTodos));


            final todoListTile =
              tester.widget<TodoItem>(find.byType(TodoItem).first);
            todoListTile.onToggle!(!todo.isCompleted);

            verify(
                  () => controller.onUpdateCompleted(todo, !todo.isCompleted),
            ).called(1);
            Get.reset();
          });

          testWidgets('onDismissed call', (tester) async {
            final todo = mockTodos.first;
            when(
                      () => controller.onDeleteTodo(todo.id)
              ).thenAnswer((_) async {});
              await tester.pumpApp(buildSubject(todos: mockTodos));


              final todoListTile = tester.widget<TodoItem>(
                find.byType(TodoItem).first,
              );
              todoListTile.onDismissed!(DismissDirection.startToEnd);
              await tester.pumpAndSettle(Duration(seconds: 2));
              verify(
                    () => controller.onDeleteTodo(todo.id),
              ).called(1);
              Get.reset();
            },
          );

          testWidgets(
            'navigate to EditTodo when tapped',
                (tester) async {
              await tester.pumpApp(buildSubject(todos: mockTodos));

              final todoListTile = tester.widget<TodoItem>(
                find.byType(TodoItem).first,
              );
              todoListTile.onTap!();
              expect('/EditTodo', Get.currentRoute);
              Get.reset();
            },
          );

        });
      });
    });

  });
}