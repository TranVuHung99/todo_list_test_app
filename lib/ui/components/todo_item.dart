import 'package:flutter/material.dart';
import 'package:test_app/data/models/todo.dart';

class TodoItem extends StatelessWidget {

  const TodoItem({
    Key? key,
    required this.todo,
    this.onToggle,
    this.onDismissed,
    this.onTap
  }) : super(key: key);

  final Todo todo;
  final ValueChanged<bool>? onToggle;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;


  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key('todoListItem_dismissible_${todo.id}'),
        onDismissed: onDismissed,
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          color: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Icon(
            Icons.delete,
            color: Color(0xAAFFFFFF),
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          onTap: onTap,
          title: Text(todo.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: !todo.isCompleted ? null
                : TextStyle(
                color: Color(0xA8A8A2BB),
                decoration: TextDecoration.lineThrough
            ),
          ),
          subtitle: Text(
            todo.desc,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: Checkbox(
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))
            ),
            value: todo.isCompleted,
            onChanged: onToggle == null
                ? null
                : (value) => onToggle!(value!),
          ),

        )
    );;
  }
}



