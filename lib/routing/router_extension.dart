import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';

extension GoRouterExtension on BuildContext {
  void navigateTodoAlarm() => goNamed(RouteName.todoAlarm);
  void navigateTodoAdd() => goNamed(RouteName.todoAdd);
  void navigateSpeech() => goNamed(RouteName.speech);
  void navigateSettings() => goNamed(RouteName.settings);
}
