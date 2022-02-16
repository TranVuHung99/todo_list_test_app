import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/controllers/edit_todo_controller.dart';
import 'package:test_app/data/models/todo.dart';
import 'package:test_app/data/todo_repository/todo_repository.dart';
import 'package:test_app/ui/screens/edit_todo.dart';
import '../helper/pump_app.dart';


class MockEditTodoController extends GetxController with Mock implements EditTodoController {}
class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  final mockTodo = Todo(
    id: '1',
    title: 'title 1',
    desc: 'description 1',
  );

  late EditTodoController mockController;
  late TodoRepository repository;
  setUp(() {
    repository = MockTodoRepository();
    mockController = MockEditTodoController();
    when(
            () => mockController.status
    ).thenReturn(editTodoStatus.initial.obs);
    when(
            () => mockController.todoTitle
    ).thenReturn(''.obs);
    when(
            () => mockController.todoDesc
    ).thenReturn(''.obs);
  });

  group('EditTodoPage', () {

    void putController({Todo? todo}) {
      Get.lazyPut<EditTodoController>(
        () => todo != null
          ? EditTodoController(repository: repository, initialTodo: todo)
          : mockController);
    }

    Widget buildSubject({Todo? todo}) {
      return EditTodo(todo: todo,);
    }

    group('renders EditTodoPage', () {
      testWidgets('is rendered', (tester) async {
          putController();
          await tester.pumpApp(buildSubject());
          expect(find.byType(EditTodo), findsOneWidget);
          Get.reset();
      });

      testWidgets('supports providing an initial todo', (tester) async {
        final initTodo = Todo(
          id: 'initial-id',
          title: 'initial',
        );
        putController(todo: initTodo);
        await tester.pumpApp(buildSubject(todo: initTodo));
        expect(find.byType(EditTodo), findsOneWidget);
        expect(
          find.byWidgetPredicate(
                (w) => w is EditableText && w.controller.text == 'initial',
          ),
          findsOneWidget,
        );
        Get.reset();
      });


      const titleTextFormField = Key('editTodoView_title_textFormField');
      const descriptionTextFormField =
      Key('editTodoView_description_textFormField');

      testWidgets(
        'renders AppBar when no initial Todo provided ',
            (tester) async {
          putController();
          await tester.pumpApp(buildSubject());

          expect(find.byType(AppBar), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(AppBar),
              matching: find.text('Add new Task'),
            ),
            findsOneWidget,
          );
          Get.reset();
        },
      );

      testWidgets(
        'renders AppBar when an initial Todo provided ',
            (tester) async {
          putController();
          await tester.pumpApp(buildSubject(todo: mockTodo));

          expect(find.byType(AppBar), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(AppBar),
              matching: find.text('Update Task'),
            ),
            findsOneWidget,
          );
          Get.reset();
        },
      );

      group('title text form field', () {
        testWidgets('is rendered', (tester) async {
          putController();
          await tester.pumpApp(buildSubject());

          expect(find.byKey(titleTextFormField), findsOneWidget);
          Get.reset();
        });

        testWidgets('is disabled when loading', (tester) async {
          when(
              () => mockController.status
          ).thenReturn(editTodoStatus.loading.obs);
          putController();
          await tester.pumpApp(buildSubject());

          final textField =
          tester.widget<TextFormField>(find.byKey(descriptionTextFormField));
          expect(textField.enabled, false);
          Get.reset();
        });

        testWidgets(
          'call onTitleChange when input new value', (tester) async {
            when(
                  () => mockController.onTitleChange('newtitle')
            ).thenReturn((_) {});
            putController();
            await tester.pumpApp(buildSubject());
            await tester.enterText(
              find.byKey(titleTextFormField),
              'newtitle',
            );

            verify(
                  () => mockController.onTitleChange('newtitle'),
            ).called(1);
            Get.reset();
          },
        );
      });

      group('description text form field', () {
        testWidgets('is rendered', (tester) async {
          putController();
          await tester.pumpApp(buildSubject());

          expect(find.byKey(descriptionTextFormField), findsOneWidget);
          Get.reset();
        });

        testWidgets('is disabled when loading', (tester) async {
          when(
                () => mockController.status
          ).thenReturn(editTodoStatus.loading.obs);
          putController();
          await tester.pumpApp(buildSubject());

          final textField =
          tester.widget<TextFormField>(find.byKey(titleTextFormField));
          expect(textField.enabled, false);
          Get.reset();
        });

        testWidgets(
          'call onDescChange when input new value', (tester) async {
            when(
                    () => mockController.onDescChange('newDesc')
            ).thenReturn((_) {});
            putController();
            await tester.pumpApp(buildSubject());
            await tester.enterText(
              find.byKey(descriptionTextFormField),
              'newDesc',
            );

            verify(
                  () => mockController.onDescChange('newDesc'),
            ).called(1);
            Get.reset();
          },
        );
      });

      group('save fab', () {
        testWidgets('is rendered', (tester) async {
          putController();
          await tester.pumpApp(buildSubject());

          expect(
            find.descendant(
              of: find.byType(FloatingActionButton),
              matching: find.byTooltip('Add Todo'),
            ),
            findsOneWidget,
          );
          Get.reset();
        });

        testWidgets('call onSubmitted when tapped', (tester) async {
            final todo = Todo(
              id: 'initial-id',
              title: 'title',
              desc: 'description'
            );
            when(
                  () => mockController.onSubmitted(todo)
            ).thenAnswer((_) async {});

            putController();
            await tester.pumpApp(buildSubject(todo: todo));
            await tester.tap(find.byType(FloatingActionButton));
            verify(() => mockController.onSubmitted(todo)).called(1);
            Get.reset();
          },
        );
      });
    });
  });
}
