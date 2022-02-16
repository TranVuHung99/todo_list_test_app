import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/controllers/tab_controller.dart';
import 'package:test_app/controllers/todo_controller.dart';
import 'package:test_app/data/models/todo.dart';
import 'package:test_app/data/todo_repository/todo_repository.dart';
import 'package:test_app/ui/screens/home.dart';
import 'package:test_app/ui/screens/todo_page/all_todo_screen.dart';
import 'package:test_app/ui/screens/todo_page/complete_todo_screen.dart';
import 'package:test_app/ui/screens/todo_page/incomplete_todo_screen.dart';
import '../helper/pump_app.dart';

class MockTabController extends GetxController with Mock implements MyTabController {}
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

  group('HomeView', () {
    const addTodoFloatingActionButtonKey = Key(
      'homeView_addTodo_floatingActionButton',
    );

    late MyTabController tabController;
    late TodoRepository repository;
    setUp(() {
      repository = MockTodoRepository();
      tabController = MockTabController();
      when(() => tabController.tab).thenReturn(HomeTab.allTodos.obs);
      when(
              () => repository.getTodos()
      ).thenAnswer((_) => Stream.value(mockTodos));

    });



    Widget buildSubject() {
      Get.lazyPut<MyTabController>(() => tabController);
      Get.lazyPut<TodoController>(() => TodoController(repository: repository));

      return Home();
    }

    testWidgets(
      'renders AllTodosScreen when tab is set to HomeTab.allTodos', (tester) async {

        await tester.pumpApp(buildSubject());

        expect(find.byType(AllTodoScreen), findsOneWidget);
        Get.reset();
      },
    );

    testWidgets(
        'renders CompletedTodosScreen when tab is set to HomeTab.completedTodos',
            (tester) async {
        when(() => tabController.tab).thenReturn(HomeTab.completedTodos.obs);
        await tester.pumpApp(buildSubject());

        expect(find.byType(CompletedTodoScreen), findsOneWidget);
        Get.reset();
      },
    );

    testWidgets(
      'renders InCompletedTodosScreen when tab is set to HomeTab.incompletedTodos',
          (tester) async {
        when(() => tabController.tab).thenReturn(HomeTab.inCompletedTodos.obs);
        await tester.pumpApp(buildSubject());

        expect(find.byType(InCompletedTodoScreen), findsOneWidget);
        Get.reset();
      },
    );

    testWidgets(
      'calls setTab with HomeTab.allTodos'
          'when allTodos navigation button is pressed',
          (tester) async {
        when(() => tabController.setTab(HomeTab.allTodos))
            .thenReturn((_) {});
        await tester.pumpApp(buildSubject(),);

        await tester.tap(find.text('All'));

        verify(() => tabController.setTab(HomeTab.allTodos)).called(1);
        Get.reset();
      },
    );

    testWidgets(
      'calls setTab with HomeTab.completedTodos'
          'when completedTodos navigation button is pressed',
          (tester) async {
        when(() => tabController.setTab(HomeTab.completedTodos))
            .thenReturn((_) {});
        await tester.pumpApp(buildSubject(),);

        await tester.tap(find.text('Completed'));

        verify(() => tabController.setTab(HomeTab.completedTodos)).called(1);
        Get.reset();
      },
    );

    testWidgets(
      'calls setTab with HomeTab.inCompletedTodos'
          'when inCompletedTodos navigation button is pressed',
          (tester) async {
        when(() => tabController.setTab(HomeTab.inCompletedTodos))
            .thenReturn((_) {});
        await tester.pumpApp(buildSubject(),);

        await tester.tap(find.text('UnCompleted'));

        verify(() => tabController.setTab(HomeTab.inCompletedTodos)).called(1);
        Get.reset();
      },
    );

    group('add todo floating action button', () {
      testWidgets(
        'is rendered',
            (tester) async {
          await tester.pumpApp(buildSubject());

          expect(
            find.byKey(addTodoFloatingActionButtonKey),
            findsOneWidget,
          );

          final addTodoFloatingActionButton =
          tester.widget(find.byKey(addTodoFloatingActionButtonKey));
          expect(
            addTodoFloatingActionButton,
            isA<FloatingActionButton>(),
          );
        },
      );

      testWidgets('renders add icon', (tester) async {
        await tester.pumpApp(buildSubject());
        expect(
          find.descendant(
            of: find.byKey(addTodoFloatingActionButtonKey),
            matching: find.byIcon(Icons.add),
          ),
          findsOneWidget,
        );
      });

      testWidgets(
        'navigates to the EditTodoPage when pressed',
            (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.byKey(addTodoFloatingActionButtonKey));

          expect('/EditTodo', Get.currentRoute);
        },
      );
    });
  });
}