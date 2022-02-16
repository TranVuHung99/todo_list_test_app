import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:test_app/controllers/edit_todo_controller.dart';
import 'package:test_app/data/models/todo.dart';
import 'package:test_app/data/todo_repository/todo_repository.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

class FakeTodo extends Fake implements Todo {}

void main() {
  group('EditTodoController', () {
    late TodoRepository repository;

    setUpAll(() {
      registerFallbackValue(FakeTodo());
    });

    setUp(() {
      repository = MockTodoRepository();
    });

    EditTodoController createSubject() {
      return EditTodoController(
        repository: repository,
        initialTodo: null,
      );
    }

    group('constructor', () {
      test('works correctly', () {
        expect(createSubject, returnsNormally);
      });

      test('onInit call', () {
        final controller = createSubject();
        controller.onInit();
        expect(
          controller.todoTitle.value,
          equals('')
        );
        expect(
          controller.todoDesc.value,
          equals('')
        );
        expect(
          controller.status.value,
          equals(editTodoStatus.initial)
        );
      });
    });

    group('onTitleChange call', () {
      test('update title with event value', () {
        final controller = createSubject();
        controller.onTitleChange('newTitle');
        expect(controller.todoTitle.value, 'newTitle');
      });
    });

    group('onDescChange call', () {
      test('update desc with event value', () {
        final controller = createSubject();
        controller.onDescChange('newDesc');
        expect(controller.todoDesc.value, 'newDesc');
      });
    });

    group('onSubmitted call', () {
      setUp(() {
        when(
            () => repository.saveTodo(any())
        ).thenAnswer((_) async {});
      });
      
      test('add new todo to repository if no initial todo was provided', () async {
        final controller = createSubject();
        controller.todoTitle.value = 'title';
        controller.todoDesc.value = 'description';
        
        await controller.onSubmitted(null);
        expect(controller.status.value, editTodoStatus.success);
        verify(
            () => repository.saveTodo(
              any(
                that: isA<Todo>()
                    .having((t) => t.title, 'title', equals('title'))
                    .having((t) => t.desc, 'description', equals('description'))
              ),
            ),
          ).called(1);
      });
      
      test('update todo to repository if initial todo was provided', () async {
        final initialTodo = Todo(id: 'initial-id', title: 'initial-title');
        final controller = createSubject();
        controller.todoTitle.value = 'title';
        controller.todoDesc.value = 'description';
        await controller.onSubmitted(initialTodo);
        expect(controller.status.value, editTodoStatus.success);
        verify(
              () => repository.saveTodo(
            any(
                that: isA<Todo>()
                    .having((t) => t.id, 'id', equals('initial-id'))
                    .having((t) => t.title, 'title', equals('title'))
                    .having((t) => t.desc, 'description', equals('description'))
            ),
          ),
        ).called(1);
      });

      group('onSubmitted error', () {
        setUp((){
          when(
                  () => repository.saveTodo(any())
          ).thenThrow(Exception('fail'));
        });

        test('set error status if save to repository fail', () async{
          final controller = createSubject();
          controller.todoTitle.value = 'title';
          controller.todoDesc.value = 'description';
          await controller.onSubmitted(null);
          expect(controller.status.value, editTodoStatus.error);
        });
      });
    });
  });
}