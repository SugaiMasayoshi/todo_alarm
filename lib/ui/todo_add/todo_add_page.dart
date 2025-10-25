import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/ui/todo_list/todo_list_view_model.dart';

class TodoAddPage extends ConsumerWidget {
  const TodoAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoListViewModel = ref.read(todoListViewModelProvider.notifier);
    final titleEditingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('やることを追加')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleEditingController,
              decoration: const InputDecoration(
                labelText: 'やること',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                todoListViewModel.addTodo(title: titleEditingController.text);
                context.pop();
              },
              child: const Text('追加'),
            ),
          ],
        ),
      ),
    );
  }
}
