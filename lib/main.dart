import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_app/binding/home_binding.dart';
import 'package:test_app/data/todo_repository/todo_repository.dart';
import 'package:test_app/ui/screens/home.dart';

import 'data/todo_apis/local_storage_todos_api/local_storage_todos_api.dart';

void main() async{
  await GetStorage.init();
  Get.lazyPut<TodoRepository>(
      () => TodoRepository(
          todosApi: LocalStorageTodosApi(plugin: GetStorage())
      )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo List App',
      debugShowCheckedModeBanner: false,
      initialRoute: Home.id,
      getPages: [
        GetPage(name: Home.id, page: () => Home(),
            binding: HomeBind(repository: Get.find<TodoRepository>())),
      ],
    );
  }
}
