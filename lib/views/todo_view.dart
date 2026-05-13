import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/todo/todo_cubit.dart';
import '../cubits/todo/todo_state.dart';

class TodoView extends StatelessWidget {
  TodoView({super.key});

  /*----------------------------------------------*\
  |  Controller to read the text input             |
  \*----------------------------------------------*/
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*----------------------------------------------*\
        |  INPUT ROW                                     |
        \*----------------------------------------------*/
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(fontFamily: 'monospace'),
                  decoration: InputDecoration(
                    hintText: 'NEW TASK...',
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onSubmitted: (val) {
                    context.read<TodoCubit>().addTodo(val);
                    _controller.clear();
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                ),
                onPressed: () {
                  context.read<TodoCubit>().addTodo(_controller.text);
                  _controller.clear();
                },
                child: const Text('ADD', style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),

        /*----------------------------------------------*\
        |  TODO LIST                                     |
        \*----------------------------------------------*/
        Expanded(
          /*----------------------------------------------*\
          |  BlocBuilder listens to the engine and         |
          |  repaints ONLY this list when data changes     |
          \*----------------------------------------------*/
          child: BlocBuilder<TodoCubit, TodoState>(
            builder: (context, state) {
              if (state.isLoading) return const Center(child: CircularProgressIndicator());
              if (state.todos.isEmpty) return const Center(child: Text('TODO DB EMPTY', style: TextStyle(color: Colors.grey, letterSpacing: 2)));

              return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, index) {
                  final todo = state.todos[index];
                  return ListTile(
                    leading: Checkbox(
                      value: todo.isDone,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (_) => context.read<TodoCubit>().toggleTodo(todo.id),
                    ),
                    title: Text(
                      todo.text,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        decoration: todo.isDone ? TextDecoration.lineThrough : null,
                        color: todo.isDone ? Colors.grey : Colors.white,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.redAccent),
                      onPressed: () => context.read<TodoCubit>().removeTodo(todo.id),
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}