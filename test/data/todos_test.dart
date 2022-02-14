import 'package:test/test.dart';
import 'package:test_app/data/models/todo.dart';

void main() {
  group('Testing for Todo', () {
    Todo createSubject({
      String? id = '1',
      String title = 'title',
      String desc = 'desc',
      bool isCompleted = true
    }) {
      return Todo(
        id: id,
        title: title,
        desc: desc,
        isCompleted: isCompleted
      );
    }

    group('constructor', () {
      test('works correctly', () {
        expect(createSubject, returnsNormally);
      });

      test('sets id if not provided', () {
        expect(
          createSubject(id: null).id,
          isNotEmpty,
        );
      });

      test('supports value equality', () {
        expect(
          createSubject(),
          equals(createSubject()),
        );
      });

      test('props are correct', ()
      {
        expect(
          createSubject().props,
          equals([
            '1', // id
            'title', // title
            'desc', // description
            true, // isCompleted
          ]),
        );
      });
    });

    group('copyWith', () {
      test('return same object if no args provided', (){
        expect(
            createSubject().copyWith(),
            equals(createSubject())
        );
      });

      test('replaces every value with provided parameter', () {
        expect(
          createSubject().copyWith(
            id: '2',
            title: 'new title',
            desc: 'new description',
            isCompleted: false,
          ),
          equals(
            createSubject(
              id: '2',
              title: 'new title',
              desc: 'new description',
              isCompleted: false,
            ),
          ),
        );
      });
    });

    group('fromJson', () {
      test('work correctly', () {
        expect(
          Todo.fromJson(<String, dynamic>{
            'id': '1',
            'title': 'title',
            'desc': 'desc',
            'isCompleted': true,
          }),
          equals(createSubject())
        );
      });
    });

    group('toJson', () {
      test('works correctly', () {
        expect(
          createSubject().toJson(),
          equals(<String, dynamic>{
            'id': '1',
            'title': 'title',
            'desc': 'desc',
            'isCompleted': true,
          }),
        );
      });
    });
  });
}