import 'package:test_app/data/models/todo.dart';
import 'package:test_app/data/todo_apis/todo_api.dart';

class TodoRepository {
  const TodoRepository({
    required TodoApi todosApi
  }) : _todosApi = todosApi;

  final TodoApi _todosApi;

  Stream<List<Todo>> getTodos() => _todosApi.getTodos();

  Future<void> saveTodo(Todo todo) => _todosApi.saveTodo(todo);

  Future<void> deleteTodo(String id) => _todosApi.deleteTodo(id);

  Future<int> clearCompleted() => _todosApi.clearCompleted();

  Future<int> completeAll({required bool isCompleted}) =>
      _todosApi.completeAll(isCompleted: isCompleted);
}