import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/data/models/todo_item_model.dart';
import 'package:todo_alarm/ui/todo_list/todo_list_view_model.dart';

part '../../generated/ui/todo_item/todo_item_provider.g.dart';

@riverpod
TodoItemModel? todoItem(Ref ref, String id) {
  final state = ref.watch(
    todoListViewModelProvider.select(
      (value) => value.items.firstWhere((item) => item.id == id),
    ),
  );
  return state;
}
