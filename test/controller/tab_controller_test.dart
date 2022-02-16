
import 'package:test/test.dart';
import 'package:test_app/controllers/tab_controller.dart';

void main() {
  group('TabController', () {
    MyTabController createSubject() => MyTabController();

    group('constructor', () {
      test('work correctly', () {
        expect(createSubject, returnsNormally);
      });

      test('has correct initital tab', () {
        expect(createSubject().tab.value, equals(HomeTab.allTodos));
      });
    });

    group('setTab call', () {
      test('set tab to event value', () {
        final controller = createSubject();
        controller.setTab(HomeTab.inCompletedTodos);
        expect(controller.tab.value, equals(HomeTab.inCompletedTodos));
      });
    });
  });
}