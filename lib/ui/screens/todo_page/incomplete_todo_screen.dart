import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/binding/edit_todo_binding.dart';
import 'package:test_app/controllers/todo_controller.dart';
import 'package:test_app/ui/components/todo_item.dart';
import 'package:test_app/ui/components/todo_list_view.dart';

import '../edit_todo.dart';


class InCompletedTodoScreen extends StatelessWidget {
  InCompletedTodoScreen({Key? key}) : super(key: key);
  static const id = '/All_todo_screen';

  final TodoController todoController = Get.find<TodoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UnCompleted Tasks'),

      ),
      body: SafeArea(
          child: Obx(
                  () => TodoListView(todos: todoController.getInCompleteTodo())
          )
      ),
    );
  }
}