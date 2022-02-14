import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/controllers/todo_controller.dart';
import 'package:test_app/ui/components/todo_list_view.dart';
import 'package:test_app/ui/components/todos_view_option_button.dart';



class AllTodoScreen extends StatelessWidget {
  AllTodoScreen({Key? key}) : super(key: key);
  static const id = '/All_todo_screen';

  final TodoController todoController = Get.find<TodoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Tasks'),
        actions: [TodoViewOptionButtons()],
      ),
      body: SafeArea(
        child: Obx(
            () => TodoListView(todos: todoController.todos.value)
        )
      ),
    );
  }
}


