import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class TodoModel {
  String id;
  String title;
  String time;
  bool isDone;
  TodoModel({
    required this.id,
    required this.title,
    required this.time,
    this.isDone = false,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return _$TodoModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$TodoModelToJson(this);
  }
}