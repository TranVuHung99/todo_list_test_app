import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/data/todo_repository/todo_repository.dart';

class MockTodosRepository extends Mock implements TodoRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
      Widget widget, {
      TodoRepository? repository,
  }) {
    Get.lazyPut<TodoRepository>(() => repository ?? MockTodosRepository());
    return pumpWidget(
      GetMaterialApp(
        home: Scaffold(body: widget),
      )
    );
  }
}