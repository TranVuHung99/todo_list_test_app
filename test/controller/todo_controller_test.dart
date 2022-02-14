import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:test_app/controllers/todo_controller.dart';
import 'package:test_app/data/models/todo.dart';
import 'package:test_app/data/todo_repository/todo_repository.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

class FakeTodo extends Fake implements Todo {}

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

  group('TodoController', () {
    late TodoRepository repository;

    setUpAll(() {
      registerFallbackValue(FakeTodo());
    });

    setUp(() {
      repository = MockTodoRepository();
      when(
          () => repository.getTodos(),
      ).thenAnswer((_) => Stream.value(mockTodos));
      when(() => repository.saveTodo(any())).thenAnswer((_) async{});
    });

    TodoController createSubject() {
      return TodoController(repository: repository);
    }

    group('constructor', () {
      test('work correctly', () {
        expect(createSubject, returnsNormally);
      });

      test('initial empty list Todo', () {
        expect(
            createSubject().todos.value,
            equals(List<Todo>.empty())
        );
      });

      test('initial controller', () {
        final controller = createSubject();
        controller.onInit();
        verify(() => repository.getTodos()).called(1);
        expect(repository.getTodos(), emits(mockTodos));
      });
    });

    group('onTodoSave call', (){
      test('save todo use repository', (){
        final controller = createSubject();
        controller.onTodoSave(mockTodos.first);
        verify(() => repository.saveTodo(mockTodos.first)).called(1);
      });
    });

    group('onUpdateCompleted call', (){
      test('update todo isCompleted with args isCompleted value', (){
        final controller = createSubject();
        controller.onUpdateCompleted(mockTodos.first, true);
        verify(() => repository.saveTodo(
            mockTodos.first.copyWith(isCompleted: true)
        )).called(1);
      });
    });

    group('onDeleteTodo call', (){
      setUp(() {
        when(
            () => repository.deleteTodo(any())
        ).thenAnswer((_) async{});
      });

      test('delete todo use repository', (){
        final controller = createSubject();
        controller.todos.value = mockTodos;
        controller.onDeleteTodo(mockTodos.first.id);
        verify(() => repository.deleteTodo(mockTodos.first.id)).called(1);
      });
    });
  });
}

