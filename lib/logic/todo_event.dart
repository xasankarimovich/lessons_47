part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

class LoadTodos extends TodoEvent {}

class ToggleTodoCompletion extends TodoEvent {
  final int index;

  ToggleTodoCompletion(this.index);
}

class AddTodo extends TodoEvent {
  final String title;
  final String time;

  AddTodo({required this.title, required this.time});
}

class EditTodo extends TodoEvent {
  final String id;
  final String title;
  final String time;

  EditTodo({required this.id, required this.title, required this.time});
}

class DeleteTodo extends TodoEvent {
  final String id;

  DeleteTodo(this.id);
}