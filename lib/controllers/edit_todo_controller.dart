import 'package:get/get.dart';
import 'package:test_app/controllers/todo_controller.dart';
import 'package:test_app/data/models/todo.dart';
import 'package:test_app/data/todo_repository/todo_repository.dart';

enum editTodoStatus { initial, success, loading, error }


class EditTodoController extends GetxController{
  var todoTitle = "".obs;
  var todoDesc = "".obs;
  var status = editTodoStatus.initial.obs;

  EditTodoController({Todo? initialTodo, required this.repository})
      : assert(repository != null),
        _todo = initialTodo;


  final Todo? _todo;
  final TodoRepository repository;
  @override
  void onInit() {
    // TODO: implement onInit

    todoTitle = _todo?.title.obs ?? "".obs;
    todoDesc = _todo?.desc.obs ?? "".obs;

    super.onInit();
  }
  void onTitleChange(String title) {
    todoTitle.value = title;
  }

  void onDescChange(String desc) {
    todoDesc.value = desc;
  }

  Future<void> onSubmitted(Todo? updateTodo) async{
    status.value = editTodoStatus.loading;
    final todo = (updateTodo ?? Todo(title: '')).copyWith(
        title: todoTitle.value,
        desc: todoDesc.value
    );
    try {
      await repository.saveTodo(todo);
      status.value = editTodoStatus.success;
    } catch(e) {
      status.value =  editTodoStatus.error;
    }
  }
}