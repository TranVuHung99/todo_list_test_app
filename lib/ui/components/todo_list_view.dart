import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/binding/edit_todo_binding.dart';
import 'package:test_app/controllers/todo_controller.dart';
import 'package:test_app/data/models/todo.dart';
import 'package:test_app/data/todo_repository/todo_repository.dart';
import 'package:test_app/ui/components/todo_item.dart';
import 'package:test_app/ui/screens/edit_todo.dart';

class TodoListView extends StatelessWidget {
  TodoListView({Key? key, required this.todos}) : super(key: key);
  final List<Todo> todos;
  final TodoController todoController = Get.find<TodoController>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, id) {
        var todo = todos[id];
        return TodoItem(
          todo: todo,
          onToggle: (isCompleted) {
            todoController.onUpdateCompleted(todo, isCompleted);
          },
          onDismissed: (_) {
            todoController.onDeleteTodo(todo.id);
            Get.snackbar('Remove!', "Task was remove successfully",
                snackPosition: SnackPosition.BOTTOM);
          },
          onTap: () {
            Get.to(() => EditTodo(todo: todo), binding: EditTodoBind(
                initialTodo: todo,
                repository: Get.find<TodoRepository>()
            ));
          },
        );
      },
      itemCount: todos.length,
    );
  }
}
