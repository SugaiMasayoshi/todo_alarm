import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/data/models/todo_item_model.freezed.dart';
part '../../generated/data/models/todo_item_model.g.dart';

enum TodoStatus { todo, doing, done }

@freezed
abstract class TodoItemModel with _$TodoItemModel {
  const factory TodoItemModel({
    required String id,
    required String title,
    @Default(TodoStatus.todo) TodoStatus status,
  }) = _TodoItemModel;

  factory TodoItemModel.fromJson(Map<String, dynamic> json) =>
      _$TodoItemModelFromJson(json);
}
