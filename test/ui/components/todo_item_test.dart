import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/data/models/todo.dart';
import 'package:test_app/ui/components/todo_item.dart';
import '../helper/pump_app.dart';
void main() {
  group('TodoItem', () {
    final unCompletedTodo = Todo(
      id: '1',
      title: 'title 1',
      desc: 'description 1'
    );

    final completedTodo = Todo(
      id: '2',
      title: 'title 2',
      desc: 'description 2',
      isCompleted: true
    );

    final onToggleCompletedCall = <bool>[];
    final dismissibleKey = Key('todoListItem_dismissible_${unCompletedTodo.id}');

    late int onDismissedCallCount;
    late int onTapCallCount;

    Widget buildSubject({Todo? todo}) {
      return TodoItem(
        todo: todo ?? unCompletedTodo,
        onToggle: onToggleCompletedCall.add,
        onDismissed: (_) => onDismissedCallCount++,
        onTap: () => onTapCallCount++,
      );
    }

    setUp(() {
      onDismissedCallCount = 0;
      onTapCallCount = 0;
    });

    group('constructor', () {
      test('work correctly', () {
        expect(
          () => TodoItem(todo: unCompletedTodo),
          returnsNormally
        );
      });
    });

    group('checkbox', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        final checkBoxFinder = find.byType(Checkbox);
        expect(checkBoxFinder, findsOneWidget);
      });

      testWidgets('is check when todo is completed', (tester) async {
        await tester.pumpApp(buildSubject(todo: completedTodo));
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, isTrue);
      });

      testWidgets('calls onToggle with correct value when tap', (tester) async {
        await tester.pumpApp(buildSubject(todo: unCompletedTodo));

        await tester.tap(find.byType(Checkbox));

        expect(onToggleCompletedCall, equals([true]));
      });
    });

    group('dismissible',() {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(Dismissible), findsOneWidget);
        expect(find.byKey(dismissibleKey), findsOneWidget);
      });

      testWidgets('calls onDismissed when swiped to left', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.fling(
            find.byKey(dismissibleKey),
            const Offset(-300, 0),
            3000,
        );

        await tester.pumpAndSettle();

        expect(onDismissedCallCount, equals(1));
      });

      testWidgets('calls onTab when pressed', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.byType(TodoItem));

        expect(onTapCallCount, equals(1));
      });
    });

    group('todo title', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.text(unCompletedTodo.title), findsOneWidget);
      });

      testWidgets('is strikethrough when todo is completed', (tester) async {
        await tester.pumpApp(
          buildSubject(todo: completedTodo),
        );

        final text = tester.widget<Text>(find.text(completedTodo.title));
        expect(
          text.style,
          isA<TextStyle>().having(
                (s) => s.decoration,
            'decoration',
            TextDecoration.lineThrough,
          ),
        );
      });
    });

    group('todo description', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.text(unCompletedTodo.desc), findsOneWidget);
      });
    });
  });
}