import 'package:equatable/equatable.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  Basic Todo Model with JSON support.           |
\*----------------------------------------------*/
class Todo extends Equatable {
  final String id;
  final String text;
  final bool isDone;

  const Todo({
    required this.id,
    required this.text,
    this.isDone = false,
  });

  Todo copyWith({String? text, bool? isDone}) {
    return Todo(
      id: id,
      text: text ?? this.text,
      isDone: isDone ?? this.isDone,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      text: json['text'],
      isDone: json['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isDone': isDone,
    };
  }

  @override
  List<Object?> get props => [id, text, isDone];
}
