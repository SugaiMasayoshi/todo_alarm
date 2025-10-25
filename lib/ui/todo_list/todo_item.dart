import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/ui/todo_list/todo_item_provider.dart';
import 'package:todo_alarm/ui/todo_list/todo_list_view_model.dart';

class TodoItem extends ConsumerWidget {
  const TodoItem({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(todoItemProvider(id));

    if (todo == null) {
      return const SizedBox.shrink();
    }

    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(context),
      onDismissed: (direction) {
        ref.read(todoListViewModelProvider.notifier).deleteTodo(todo.id);
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(todo.title),
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
