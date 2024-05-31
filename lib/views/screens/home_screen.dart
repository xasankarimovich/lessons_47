import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/todo_bloc.dart';
import '../../models/todo_model.dart';
import '../../viewmodels/todo_view_model.dart';
import '../widgets/dialog_box.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  TodoViewModel todoViewModel = TodoViewModel();

  void addTodo(BuildContext context) async {
    final data = await showDialog(
        context: context,
        builder: (_) {
          return const TodoDialogBox();
        });

    if (data != null) {
      // todoViewModel.addTodo(data['title'], data['time']);
      context
          .read<TodoBloc>()
          .add(AddTodo(title: data['title'], time: data['time']));
    }
  }

  void editTasks(BuildContext context, TodoModel todos) async {
    final data = await showDialog(
        context: context,
        builder: (_) {
          return TodoDialogBox(
            todo: todos,
          );
        });

    if (data != null) {
      // todoViewModel.editTask(todos.id, data['title'], data['time']);
      context.read<TodoBloc>().add(
          EditTodo(id: todos.id, title: data['title'], time: data['time']));
    }
  }

  void deleteTaasks(TodoModel todos, BuildContext context) async {
    final response = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("ishonchingiz komilmi?"),
          content: Text("Siz ${todos.title} mahsulotini o'chirmoqchisiz."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Bekor qilish"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Ha, ishonchim komil"),
            ),
          ],
        );
      },
    );

    if (response) {
      context.read<TodoBloc>().add(DeleteTodo(todos.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(TodoViewModel())..add(LoadTodos()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("TO DO"),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (_, index) {
                final todo = state.todos[index];
                return ListTile(
                  leading: Checkbox(
                    value: todo.isDone,
                    onChanged: (value) {
                      context.read<TodoBloc>().add(ToggleTodoCompletion(index));
                    },
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: todo.isDone ? Colors.grey : null,
                    ),
                  ),
                  subtitle: Text(
                    todo.time,
                    style: TextStyle(
                      color: todo.isDone ? Colors.grey : null,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          editTasks(context, todo);
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.teal,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteTaasks(todo, context);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red[900],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addTodo(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}