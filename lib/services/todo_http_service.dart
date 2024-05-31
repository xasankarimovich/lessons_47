import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/todo_model.dart';

class TodoHttpService {
  Future<List<TodoModel>> getTodoTasks() async {
    Uri url = Uri.parse(
        "https://lesson46-dba31-default-rtdb.firebaseio.com/todo.json");

    final response = await http.get(url);
    final data = jsonDecode(response.body);
    List<TodoModel> loadedTodoData = [];
    if (data != null) {
      data.forEach((key, value) {
        value['id'] = key;

        loadedTodoData.add(TodoModel.fromJson(value));
      });
    }
    // print(loadedTodoData);
    return loadedTodoData;
  }

  Future<TodoModel> addTodoTasks(String title, String time) async {
    Uri url = Uri.parse(
        "https://lesson46-dba31-default-rtdb.firebaseio.com/todo.json");

    Map<String, dynamic> todoTasks = {
      "title": title,
      "time": time,
    };

    final response = await http.post(
      url,
      body: jsonEncode(todoTasks),
    );

    final data = jsonDecode(response.body);
    todoTasks['id'] = data['name'];
    print(data);
    TodoModel newTodos = TodoModel.fromJson(todoTasks);
    return newTodos;
  }

  Future<void> deleteTask(String id) async {
    Uri url = Uri.parse(
        "https://lesson46-dba31-default-rtdb.firebaseio.com/todo/$id.json");

    await http.delete(url);
  }

  Future<void> editTask(String id, String newTitle, String newTime) async {
    Uri url = Uri.parse(
        "https://lesson46-dba31-default-rtdb.firebaseio.com/todo/$id.json");

    Map<String, dynamic> todoTasks = {
      "title": newTitle,
      "time": newTime,
    };

    final response = await http.patch(
      url,
      body: jsonEncode(todoTasks),
    );
    // print(response.body);
  }
}

// void main(List<String> args) {
//   TodoHttpService todoHttpService = TodoHttpService();
//   todoHttpService.editTask("-Nz8atwZUlxFgaPSh8Os", "O'zgardi", "0000-00-00");
// }