import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_alarm/repositories/models/todo_item_model.dart';

part '../../generated/ui/todo_list/todo_list_state.freezed.dart';

@freezed
abstract class TodoListState with _$TodoListState {
  const factory TodoListState({@Default([]) List<TodoItemModel> items}) =
      _TodoListState;
}
