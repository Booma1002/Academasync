import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/todo_model.dart';
import '../../services/storage_service.dart';
import 'todo_state.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  Manages task logic (add, toggle, delete) and  |
|  syncs it with local storage.                  |
\*----------------------------------------------*/
class TodoCubit extends Cubit<TodoState> {
  final StorageService _storage;

  TodoCubit(this._storage) : super(TodoState(todos: [], isLoading: true)) {
    refresh();
  }

  void refresh() {
    emit(state.copyWith(isLoading: true));
    final loadedTodos = _storage.loadTodos();
    emit(TodoState(todos: loadedTodos, isLoading: false));
  }

  void addTodo(String text) {
    if (text.trim().isEmpty) return;

    final newTodo = Todo(id: DateTime.now().millisecondsSinceEpoch.toString(), text: text);
    final updatedList = List<Todo>.from(state.todos)..add(newTodo);

    _updateAndSave(updatedList);
  }

  void toggleTodo(String id) {
    final updatedList = state.todos.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(isDone: !todo.isDone);
      }
      return todo;
    }).toList();

    _updateAndSave(updatedList);
  }

  void removeTodo(String id) {
    final updatedList = state.todos.where((todo) => todo.id != id).toList();
    _updateAndSave(updatedList);
  }

  void _updateAndSave(List<Todo> updatedList) {
    emit(state.copyWith(todos: updatedList));
    _storage.saveTodos(updatedList);
  }
}