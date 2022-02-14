
import 'package:get/get.dart';
import 'package:test_app/data/models/todo.dart';
import 'package:test_app/data/todo_repository/todo_repository.dart';

class TodoController extends GetxController {

  TodoController({required this.repository}) : assert(repository != null);
  final TodoRepository repository;

  var todos = List<Todo>.empty().obs;

  @override
  void onInit() {
    repository.getTodos().listen((data) {
      todos.value = data;
    }, onError: (_) {
    });
    super.onInit();
  }

  Future<void> onTodoSave(Todo todo) async{
    await repository.saveTodo(todo);
  }

  Future<void> onUpdateCompleted(Todo todo, bool isCompleted) async{
    final updateTodo = todo.copyWith(isCompleted: isCompleted);
    await repository.saveTodo(updateTodo);
  }
  Future<void> onDeleteTodo(String id) async{
    await repository.deleteTodo(id);
  }

  List<Todo> getCompleteTodo() {
    return todos.where((todo) => todo.isCompleted == true).toList();
  }

  List<Todo> getInCompleteTodo() {
    return todos.where((todo) => todo.isCompleted == false).toList();
  }

  Future<int> onClearCompleted() async {
    return await repository.clearCompleted();
  }

  Future<void> onToggleCompleteAll() async {
    final areAllCompleted = todos.every((todo) => todo.isCompleted);
    await repository.completeAll(isCompleted: !areAllCompleted);
  }

}