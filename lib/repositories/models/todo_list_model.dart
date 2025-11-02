import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_alarm/repositories/models/todo_item_model.dart';

part '../../generated/repositories/models/todo_list_model.freezed.dart';
part '../../generated/repositories/models/todo_list_model.g.dart';

@freezed
abstract class TodoListModel with _$TodoListModel {
  const factory TodoListModel({@Default([]) List<TodoItemModel> items}) =
      _TodoListModel;

  factory TodoListModel.fromJson(Map<String, dynamic> json) =>
      _$TodoListModelFromJson(json);
}
