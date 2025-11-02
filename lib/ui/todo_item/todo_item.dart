import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/ui/todo_item/todo_item_provider.dart';
import 'package:todo_alarm/ui/todo_list/todo_list_view_model.dart';

class TodoItem extends ConsumerWidget {
  const TodoItem({required this.id, required this.index, super.key});

  final String id;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(todoItemProvider(id));

    if (state == null) {
      return const SizedBox.shrink();
    }

    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(context),
      onDismissed: (direction) {
        ref.read(todoListViewModelProvider.notifier).deleteTodo(state.id);
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        trailing: ReorderableDragStartListener(
          index: index,
          child: const Icon(Icons.drag_handle, color: Colors.grey),
        ),
        title: Text(state.title, style: TextStyle(fontSize: 24)),
      ),
    );
  }

  Widget _buildDismissBackground(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 16),
      color: Colors.red,
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }
}
