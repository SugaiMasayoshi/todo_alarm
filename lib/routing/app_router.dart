import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/ui/setting/settings_page.dart';
import 'package:todo_alarm/ui/speech/speech_page.dart';
import 'package:todo_alarm/ui/todo_add/todo_add_page.dart';
import 'package:todo_alarm/ui/todo_alarm/todo_alarm_page.dart';

part '../generated/routes/app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        path: '/',
        name: RouteName.todoAlarm,
        builder: (context, state) => const TodoAlarmPage(),
        routes: [
          GoRoute(
            path: '/todo_add',
            name: RouteName.todoAdd,
            builder: (context, state) => const TodoAddPage(),
          ),
          GoRoute(
            path: '/speech',
            name: RouteName.speech,
            builder: (context, state) => const SpeechPage(),
          ),
          GoRoute(
            path: '/settings',
            name: RouteName.settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('エラー')),
      body: Center(child: Text('ページが見つかりません: ${state.uri}')),
    ),
  );
}

class RouteName {
  RouteName._();

  static const String todoAlarm = 'todo_alarm';
  static const String todoAdd = 'todo_add';
  static const String speech = 'speech';
  static const String settings = 'settings';
}
