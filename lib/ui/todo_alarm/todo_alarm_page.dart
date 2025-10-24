import 'package:flutter/material.dart';
import 'package:todo_alarm/routes/router_extension.dart';
import 'package:todo_alarm/ui/todo_list/todo_list.dart';

class TodoAlarmPage extends StatelessWidget {
  const TodoAlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mokuhyo-!')),
      body: const Center(child: TodoList()),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.goToTodoAdd();
        },
      ),
    );
  }
}
