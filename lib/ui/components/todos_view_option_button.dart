import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/controllers/todo_controller.dart';

enum TodoViewOptions { toggleAll, clearCompleted }

class TodoViewOptionButtons extends StatelessWidget {
  TodoViewOptionButtons({Key? key}) : super(key: key);


  final TodoController todoController = Get.find<TodoController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
        () {
          final todos = todoController.todos.value;
          final hasTodos = todos.isNotEmpty;
          final completedTodosAmount = todos.where((todo) => todo.isCompleted).length;

          return PopupMenuButton<TodoViewOptions>(
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            tooltip: "Option Actions",
            onSelected: (options) async {
              switch (options) {
                case TodoViewOptions.toggleAll:
                  todoController.onToggleCompleteAll();
                  break;
                case TodoViewOptions.clearCompleted:
                  final deletedCount = await todoController.onClearCompleted();
                  Get.snackbar('Successful', 'Tasks deleted: '
                      + deletedCount.toString(),
                      snackPosition: SnackPosition.BOTTOM
                  );
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: TodoViewOptions.toggleAll,
                  enabled: hasTodos,
                  child: Text(
                    completedTodosAmount == todos.length
                        ? 'Uncomplete All Tasks'
                        : 'Complete All Tasks',
                  ),
                ),
                PopupMenuItem(
                  value: TodoViewOptions.clearCompleted,
                  enabled: hasTodos && completedTodosAmount > 0,
                  child: Text('Clear Completed Tasks'),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert_rounded),
          );
        }
    );
  }
}
