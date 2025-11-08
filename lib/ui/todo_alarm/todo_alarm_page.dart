import 'package:flutter/material.dart';
import 'package:todo_alarm/routes/router_extension.dart';
import 'package:todo_alarm/ui/alarm/alarm.dart';
import 'package:todo_alarm/ui/todo_list/todo_list.dart';

class TodoAlarmPage extends StatelessWidget {
  const TodoAlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.goToSettings();
          },
          icon: Icon(Icons.settings),
        ),
        title: Center(
          child: Image.asset('assets/images/app_banner.png', height: 40),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.goToSpeech();
            },
            icon: Icon(Icons.mic),
          ),
        ],
      ),
      body: Column(
        children: [
          AlarmDisplay(),
          SizedBox(height: 20),
          Expanded(child: TodoList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.goToTodoAdd();
        },
      ),
    );
  }
}
