import 'package:equatable/equatable.dart';
import '../../models/todo_model.dart';

class TodoState extends Equatable {
  final List<Todo> todos;
  final bool isLoading;

  const TodoState({required this.todos, this.isLoading = false});

  TodoState copyWith({List<Todo>? todos, bool? isLoading}) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [todos, isLoading];
}
