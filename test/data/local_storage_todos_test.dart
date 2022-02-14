import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:test_app/data/models/todo.dart';
import 'package:test_app/data/todo_apis/local_storage_todos_api/local_storage_todos_api.dart';
import 'package:test_app/data/todo_apis/todo_api.dart';

class MockGetStorage extends Mock implements GetStorage {}

void main() {
  group('LocalStorageTodosApi', () {
    late GetStorage plugin;

    final todos = [
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

    setUp(() {
      plugin = MockGetStorage();
      when(() => plugin.read(any())).thenReturn(json.encode(todos));
      when(() => plugin.write(any(), any())).thenAnswer((_) async => true);
    });

    LocalStorageTodosApi createSubject() {
      return LocalStorageTodosApi(
        plugin: plugin,
      );
    }

    group('constructor', () {
      test('works correctly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });

      group('initializes the todos stream', () {
        test('add todos if present', () {
          final subject = createSubject();

          expect(subject.getTodos(), emits(todos));
          verify(
                () => plugin.read(
              LocalStorageTodosApi.kTodoStorageKey,
            ),
          ).called(1);
        });

        test('add empty list if no todos present', () {
          when(() => plugin.read(any())).thenReturn(null);

          final subject = createSubject();

          expect(subject.getTodos(), emits(const <Todo>[]));
          verify(
                () => plugin.read(
              LocalStorageTodosApi.kTodoStorageKey,
            ),
          ).called(1);
        });
      });
    });

    test('getTodos returns stream of current list todos', () {
      expect(
        createSubject().getTodos(),
        emits(todos),
      );
    });

    group('saveTodo', () {
      test('saves new todos', () {
        final newTodo = Todo(
          id: '4',
          title: 'title 4',
          desc: 'description 4',
        );

        final newTodos = [...todos, newTodo];

        final subject = createSubject();

        expect(subject.saveTodo(newTodo), completes);
        expect(subject.getTodos(), emits(newTodos));

        verify(
              () => plugin.write(
            LocalStorageTodosApi.kTodoStorageKey,
            json.encode(newTodos),
          ),
        ).called(1);
      });

      test('updates existing todos', () {
        final updatedTodo = Todo(
          id: '1',
          title: 'new title 1',
          desc: 'new description 1',
          isCompleted: true,
        );
        final newTodos = [updatedTodo, ...todos.sublist(1)];

        final subject = createSubject();

        expect(subject.saveTodo(updatedTodo), completes);
        expect(subject.getTodos(), emits(newTodos));

        verify(
              () => plugin.write(
            LocalStorageTodosApi.kTodoStorageKey,
            json.encode(newTodos),
          ),
        ).called(1);
      });
    });

    group('deleteTodo', () {
      test('deletes existing todos', () {
        final newTodos = todos.sublist(1);

        final subject = createSubject();

        expect(subject.deleteTodo(todos[0].id), completes);
        expect(subject.getTodos(), emits(newTodos));

        verify(
              () => plugin.write(
            LocalStorageTodosApi.kTodoStorageKey,
            json.encode(newTodos),
          ),
        ).called(1);
      });

      test(
        'throws TodoNotFoundException if todo '
            'with provided id is not found',
            () {
          final subject = createSubject();

          expect(
                () => subject.deleteTodo('non-existing-id'),
            throwsA(isA<TodoNotFoundException>()),
          );
        },
      );
    });

    group('clearCompleted', () {
      test('deletes all completed todos', () {
        final newTodos = todos.where((todo) => !todo.isCompleted).toList();
        final deletedTodosAmount = todos.length - newTodos.length;

        final subject = createSubject();

        expect(
          subject.clearCompleted(),
          completion(equals(deletedTodosAmount)),
        );
        expect(subject.getTodos(), emits(newTodos));

        verify(
              () => plugin.write(
            LocalStorageTodosApi.kTodoStorageKey,
            json.encode(newTodos),
          ),
        ).called(1);
      });
    });

    group('completeAll', () {
      test('sets isCompleted on all todos to provided value', () {
        final newTodos =
        todos.map((todo) => todo.copyWith(isCompleted: true)).toList();
        final changedTodosAmount =
            todos.where((todo) => !todo.isCompleted).length;

        final subject = createSubject();

        expect(
          subject.completeAll(isCompleted: true),
          completion(equals(changedTodosAmount)),
        );
        expect(subject.getTodos(), emits(newTodos));

        verify(
              () => plugin.write(
            LocalStorageTodosApi.kTodoStorageKey,
            json.encode(newTodos),
          ),
        ).called(1);
      });
    });
  });
}