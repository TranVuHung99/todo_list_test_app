import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:test_app/controllers/tab_controller.dart';
import 'package:test_app/controllers/todo_controller.dart';
import 'package:test_app/data/todo_repository/todo_repository.dart';

class HomeBind extends Bindings {
  HomeBind({required this.repository})
      : assert(repository != null);

  final TodoRepository repository;
  @override
  void dependencies() {
    Get.lazyPut<TodoController>(() => TodoController(
      repository: repository
    ));
    Get.lazyPut<MyTabController>(() => MyTabController());
  }
}