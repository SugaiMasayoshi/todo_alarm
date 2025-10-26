import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/alarm_plugin_repository.dart';
import 'package:todo_alarm/repositories/models/alarm_model.dart';

part '../generated/repositories/alarm_repository.g.dart';

abstract class IAlarmRepository {
  Future<void> set(AlarmModel alarm);
  Future<void> stop();
}

@Riverpod(keepAlive: true)
IAlarmRepository alarmRepository(Ref ref) {
  return AlarmPluginRepository();
}
