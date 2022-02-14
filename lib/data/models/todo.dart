import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Todo extends Equatable {

  Todo({
    String? id,
    required this.title,
    this.desc = '',
    this.isCompleted = false,
  }) : assert(id == null || id.isNotEmpty,
      'id cannot be null and should be empty'),
      id = id ?? const Uuid().v4();

  final String id;
  final String title;
  final String desc;
  final bool isCompleted;

  Todo copyWith({
    String? id,
    String? title,
    String? desc,
    bool? isCompleted
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      isCompleted: isCompleted ?? this.isCompleted
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        id: json['id'] as String?,
        title: json['title'] as String,
        desc: json['desc'] as String? ?? '',
        isCompleted: json['isCompleted'] as bool? ?? false
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'desc': desc,
    'isCompleted': isCompleted
  };

  @override
  List<Object?> get props => [id, title, desc, isCompleted];
}