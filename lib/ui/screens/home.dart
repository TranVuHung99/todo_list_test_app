import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/binding/edit_todo_binding.dart';
import 'package:test_app/controllers/tab_controller.dart';
import 'package:test_app/data/todo_repository/todo_repository.dart';
import 'package:test_app/ui/screens/todo_page/all_todo_screen.dart';
import 'package:test_app/ui/screens/todo_page/complete_todo_screen.dart';
import 'package:test_app/ui/screens/todo_page/incomplete_todo_screen.dart';

import 'edit_todo.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  static const id = '/Home_page';

  final MyTabController tabController = Get.find<MyTabController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Obx(
          () => IndexedStack(
            index: tabController.tab.value.index,
            children: [
              AllTodoScreen(),
              CompletedTodoScreen(),
              InCompletedTodoScreen()
            ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('homeView_addTodo_floatingActionButton'),
        tooltip: "Add Todo",
        onPressed: () => Get.to(() => EditTodo(),
            binding: EditTodoBind(repository: Get.find<TodoRepository>())),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(
                () => _HomeTabButton(
                  groupValue: tabController.tab.value,
                  value: HomeTab.allTodos,
                  icon: Icons.list_rounded,
                  title: "All",
                ),
            ),
            Obx(
                () => _HomeTabButton(
                  groupValue: tabController.tab.value,
                  value: HomeTab.completedTodos,
                  icon: Icons.assignment_turned_in_rounded,
                  title: "Completed",
                ),
            ),
            Obx(
                () => _HomeTabButton(
                  groupValue: tabController.tab.value,
                  value: HomeTab.inCompletedTodos,
                  icon: Icons.assignment_rounded,
                  title: "UnCompleted",
                ),
            )
          ],
        ),
      ),
    );
  }
}
class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    Key? key,
    required this.groupValue,
    required this.value,
    required this.icon,
    required this.title
  }) : super(key: key);

  final HomeTab groupValue;
  final HomeTab value;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    Color? color = groupValue != value ? Colors.black38 : Theme.of(context).colorScheme.secondary;
    return TextButton(
        onPressed: () => Get.find<MyTabController>().setTab(value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
              color: color,
              size: 26,
            ),
            Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color
              ),
            )
          ],
        ),
    );
  }
}
