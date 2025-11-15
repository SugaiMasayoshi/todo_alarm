import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/domain/alarm/alarm_config.dart';
import 'package:todo_alarm/services/implementations/alarm_service_impl.dart';

part '../../generated/services/interfaces/alarm_service.g.dart';

@riverpod
IAlarmService alarmService(Ref ref) {
  return AlarmServiceImpl();
}

@riverpod
Stream<AlarmSet> alarmRingingStream(Ref ref) {
  return Alarm.ringing;
}

abstract class IAlarmService {
  Future<void> set(AlarmConfig alarmConfig);
  Future<void> stop();
}
