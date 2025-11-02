import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/ui/todo_item/todo_item.dart';
import 'package:todo_alarm/ui/todo_list/todo_list_view_model.dart';

class TodoList extends ConsumerWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      todoListViewModelProvider.select((state) => state.items),
    );

    final todoIds = state.keys.toList();

    return ReorderableListView.builder(
      itemBuilder: (context, index) {
        final todo = state[todoIds[index]]!;
        return Column(
          key: ValueKey(todo.id),
          children: [
            TodoItem(id: todo.id, index: index),
            const Divider(height: 0),
          ],
        );
      },
      itemCount: todoIds.length,
      onReorder: (int oldIndex, int newIndex) {
        ref
            .read(todoListViewModelProvider.notifier)
            .reorderTodos(oldIndex, newIndex);
      },
    );
  }
}
