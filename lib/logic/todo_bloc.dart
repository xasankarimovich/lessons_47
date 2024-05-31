import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/todo_model.dart';
import '../viewmodels/todo_view_model.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoViewModel todoViewModel;

  TodoBloc(this.todoViewModel) : super(TodoState([])) {
    on<LoadTodos>((event, emit) async {
      final todos = await todoViewModel.list;
      emit(TodoState(todos ?? []));
    });

    on<ToggleTodoCompletion>((event, emit) {
      final todos = List<TodoModel>.from(state.todos);
      todos[event.index].isDone = !todos[event.index].isDone;
      emit(TodoState(todos));
    });

    on<AddTodo>((event, emit) async {
      await todoViewModel.addTodo(event.title, event.time);

      final todos = await todoViewModel.list;

      emit(TodoState(todos));
    });

    on<EditTodo>((event, emit) async {
      await todoViewModel.editTask(event.id, event.title, event.time);

      final todos = await todoViewModel.list;

      emit(TodoState(todos));
    });

    on<DeleteTodo>((event, emit) async {
      await todoViewModel.deleteTask(event.id);
      final todos = await todoViewModel.list;
      emit(TodoState(todos));
    });
  }
}