import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_app/data/models/todo.dart';
import 'package:test_app/data/todo_apis/todo_api.dart';

class LocalStorageTodosApi extends TodoApi {

  LocalStorageTodosApi({required GetStorage plugin})
    : _plugin = plugin {
    _init();
  }

  final GetStorage _plugin;

  final _todoStreamController = BehaviorSubject<List<Todo>>.seeded(const []);

  static const kTodoStorageKey = '__todo_storage_key__';

  String? _getValue(String key) {
    try {
        final storageValue = _plugin.read<String>(key);
        return storageValue;
    } catch(_) {

    }
  }

  void _init() {
    final todosJson = _getValue(kTodoStorageKey);
    if (todosJson != null) {
      final todos = List<Map>.from(json.decode(todosJson) as List)
          .map((jsonMap) => Todo.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _todoStreamController.add(todos);
    } else {
      _todoStreamController.add(const []);
    }
  }

  Future<void> _setValue(String key, String value) =>
      _plugin.write(key, value);


  @override
  Future<int> clearCompleted() async{
    final todos = [..._todoStreamController.value];
    final completedTodosAmount = todos.where((t) => t.isCompleted).length;
    todos.removeWhere((t) => t.isCompleted);
    _todoStreamController.add(todos);
    await _setValue(kTodoStorageKey, json.encode(todos));
    return completedTodosAmount;
  }

  @override
  Future<int> completeAll({required bool isCompleted}) async{
    final todos = [..._todoStreamController.value];
    final changedTodosAmount =
        todos.where((t) => t.isCompleted != isCompleted).length;
    final newTodos = [
      for (final todo in todos) todo.copyWith(isCompleted: isCompleted)
    ];
    _todoStreamController.add(newTodos);
    await _setValue(kTodoStorageKey, json.encode(newTodos));
    return changedTodosAmount;
  }

  @override
  Future<void> deleteTodo(String id) {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == id);
    if (todoIndex == -1) {
      throw TodoNotFoundException();
    } else {
      todos.removeAt(todoIndex);
      _todoStreamController.add(todos);
      return _setValue(kTodoStorageKey, json.encode(todos));
    }
  }

  @override
  Stream<List<Todo>> getTodos() => _todoStreamController.asBroadcastStream();

  @override
  Future<void> saveTodo(Todo todo) {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == todo.id);
    if (todoIndex >= 0) {
      todos[todoIndex] = todo;
    } else {
      todos.add(todo);
    }

    _todoStreamController.add(todos);
    return _setValue(kTodoStorageKey, json.encode(todos));
  }

}