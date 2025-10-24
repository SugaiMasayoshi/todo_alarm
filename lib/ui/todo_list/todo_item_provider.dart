import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/models/todo_item_model.dart';
import 'package:todo_alarm/repositories/todo_repository.dart';

part '../../generated/ui/todo_list/todo_item_provider.g.dart';

@riverpod
TodoItemModel? todoItem(Ref ref, String id) {
  final state = ref.watch(todoRepositoryProvider.select((s) => s.items));
  return state[id];
}
