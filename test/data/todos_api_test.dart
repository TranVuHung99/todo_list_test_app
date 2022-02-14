import 'package:test/test.dart';
import 'package:test_app/data/todo_apis/todo_api.dart';

class TestTodosApi extends TodoApi {
  TestTodosApi() : super();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('TodosApi', () {

    TestTodosApi createSubject() => TestTodosApi();

    test('can be constructed', () {
      expect(createSubject, returnsNormally);
    });
  });
}