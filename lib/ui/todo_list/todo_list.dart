import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/ui/todo_list/todo_item.dart';
import 'package:todo_alarm/ui/todo_list/todo_list_view_mode.dart';

class TodoList extends ConsumerWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      todoListViewModeProvider.select((state) => state.items),
    );

    final todoIds = state.keys.toList();

    return ListView.separated(
      itemCount: todoIds.length,
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final todo = state[todoIds[index]]!;
        return TodoItem(id: todo.id);
      },
    );
  }
}
