import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/controllers/todo_controller.dart';
import 'package:test_app/data/models/todo.dart';
import 'package:test_app/ui/components/todos_view_option_button.dart';
import '../helper/pump_app.dart';
import '../helper/finder.dart';


class MockTodoController extends GetxController with Mock implements TodoController {}


extension on CommonFinders {
  Finder optionMenuItem({
    bool enabled = true,
    required String title,
  }) {
    return find.descendant(
      of: find.byWidgetPredicate(
            (w) => w is PopupMenuItem && w.enabled == enabled,
      ),
      matching: find.text(title),
    );
  }
}

extension on WidgetTester {
  Future<void> openPopup() async {
    await tap(find.byType(TodoViewOptionButtons));
    await pumpAndSettle();
  }
}

void main() {
  group('TodosOverviewOptionsButton', () {
    late TodoController controller;


    setUp(() {
      controller = MockTodoController();
      when(
            () => controller.todos,
      ).thenReturn(const <Todo>[].obs);
      when(
          () => controller.onToggleCompleteAll()
      ).thenAnswer((_) async {});
      when(
              () => controller.onClearCompleted()
      ).thenAnswer((_) async => 0);
    });

    Widget buildSubject() {
      Get.lazyPut<TodoController>(() => controller);
      return TodoViewOptionButtons();
    }

    group('constructor', () {
      test('works properly', () {
        expect(
              () {
                Get.lazyPut<TodoController>(() => controller);
                return TodoViewOptionButtons();
              },
          returnsNormally,
        );

        Get.reset();
      });
    });

    group('internal PopupMenuButton', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());
        expect(
          find.bySpecificType<PopupMenuButton<TodoViewOptions>>(),
          findsOneWidget,
        );
        expect(
          find.byTooltip('Option Actions'),
          findsOneWidget,
        );
        Get.reset();
      });

      group('mark all todos button', () {
        final titleMarkAllTodoCompleted = "Complete All Tasks";
        final titleMarkAllTodoUnCompleted = "Uncomplete All Tasks";

        testWidgets('is disabled when there are no todos', (tester) async {
          await tester.pumpApp(buildSubject());
          await tester.openPopup();

          expect(
            find.optionMenuItem(
              title: titleMarkAllTodoUnCompleted,
              enabled: false,
            ),
            findsOneWidget,
          );
          Get.reset();
        });

        testWidgets(
          'renders mark all complete button '
              'when not all todos are marked completed',
              (tester) async {
            when(
                  () => controller.todos,
            ).thenReturn(
                [
                  Todo(title: 'a', isCompleted: true),
                  Todo(title: 'b', isCompleted: false),
                ].obs
            );
            await tester.pumpApp(buildSubject());
            await tester.openPopup();

            expect(
              find.optionMenuItem(
                title: titleMarkAllTodoCompleted,
              ),
              findsOneWidget,
            );
            Get.reset();
          },
        );

        testWidgets(
          'renders mark all incomplete button '
              'when all todos are marked completed',
              (tester) async {
            when(
                  () => controller.todos,
            ).thenReturn(
                [
                  Todo(title: 'a', isCompleted: true),
                  Todo(title: 'b', isCompleted: true),
                ].obs
            );

            await tester.pumpApp(buildSubject());
            await tester.openPopup();


            expect(
              find.optionMenuItem(
                title: titleMarkAllTodoUnCompleted,
              ),
              findsOneWidget,
            );
            Get.reset();
          },
        );

        testWidgets(
          'call onToggleCompleteAll when tapped',
              (tester) async {
            when(
                  () => controller.todos,
            ).thenReturn(
                [
                  Todo(title: 'a', isCompleted: true),
                  Todo(title: 'b', isCompleted: false),
                ].obs
            );
            await tester.pumpApp(buildSubject());
            await tester.openPopup();

            await tester.tap(
              find.optionMenuItem(
                title: titleMarkAllTodoCompleted,
              ),
            );

            verify(
                  () => controller.onToggleCompleteAll(),
            ).called(1);

            Get.reset();
          },
        );
      });

      group('clear completed button', () {
        final titleClearCompleted = 'Clear Completed Tasks';

        testWidgets(
          'is disabled when there are no completed todos',
              (tester) async {
            await tester.pumpApp(buildSubject());
            await tester.openPopup();

            expect(
              find.optionMenuItem(
                title: titleClearCompleted,
                enabled: false,
              ),
              findsOneWidget,
            );
            Get.reset();
          },
        );

        testWidgets(
          'renders clear completed button '
              'when there are completed todos',
              (tester) async {
            when(
                  () => controller.todos,
            ).thenReturn(
                [
                  Todo(title: 'a', isCompleted: true),
                  Todo(title: 'b', isCompleted: false),
                ].obs
            );
            await tester.pumpApp(buildSubject());
            await tester.openPopup();

            expect(
              find.optionMenuItem(
                title: titleClearCompleted,
                enabled: true,
              ),
              findsOneWidget,
            );
            Get.reset();
          },
        );

        testWidgets(
          'call onClearCompleted when tap',
              (tester) async {
            when(
                  () => controller.todos,
            ).thenReturn(
                [
                  Todo(title: 'a', isCompleted: true),
                  Todo(title: 'b', isCompleted: false),
                ].obs
            );
            await tester.pumpApp(buildSubject());
            await tester.openPopup();

            await tester.tap(
              find.optionMenuItem(
                title: titleClearCompleted,
              ),
            );


            await tester.pumpAndSettle(Duration(seconds: 2));

            verify(
                  () => controller.onClearCompleted(),
            ).called(1);
            Get.reset();
          },
        );

        testWidgets('render delete success snackbar', (tester) async {
          when(
                () => controller.todos,
          ).thenReturn(
              [
                Todo(title: 'a', isCompleted: true),
                Todo(title: 'b', isCompleted: false),
              ].obs
          );
          await tester.pumpApp(buildSubject());
          await tester.openPopup();

          await tester.tap(
            find.optionMenuItem(
              title: titleClearCompleted,
            ),
          );
          await tester.pumpAndSettle();
          expect(find.byType(GetSnackBar), findsOneWidget);
          expect(find.descendant(
            of: find.byType(GetSnackBar),
            matching: find.text('Tasks deleted: 0')
          ), findsOneWidget);

          await tester.pumpAndSettle(Duration(seconds: 2));
          Get.reset();
        });
      });
    });
  });
}