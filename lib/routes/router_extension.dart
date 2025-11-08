import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';

extension GoRouterExtension on BuildContext {
  void goToTodoAlarm() => goNamed(RouteName.todoAlarm);
  void goToTodoAdd() => goNamed(RouteName.todoAdd);
  void goToSpeech() => goNamed(RouteName.speech);
  void goToSettings() => goNamed(RouteName.settings);
}
