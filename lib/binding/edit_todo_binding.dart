import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:test_app/controllers/edit_todo_controller.dart';
import 'package:test_app/data/models/todo.dart';
import 'package:test_app/data/todo_repository/todo_repository.dart';

class EditTodoBind extends Bindings {
  EditTodoBind({
    @required Todo? initialTodo,
    required this.repository
  }) : assert(repository != null),
        _todo = initialTodo;
  final Todo? _todo;
  final TodoRepository repository;
  @override
  void dependencies() {
    Get.lazyPut<EditTodoController>(() => EditTodoController(
        repository: repository,
        initialTodo: _todo,
    ));
  }
}