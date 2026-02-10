import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/data/repositories/alarm_storage_repository.dart';
import 'package:todo_alarm/domain/alarm/alarm_config.dart';
import 'package:todo_alarm/data/services/interfaces/alarm_service.dart';

part '../../generated/ui/alarm/alarm_view_model.g.dart';

@riverpod
class AlarmViewModel extends _$AlarmViewModel {
  @override
  AlarmConfig build() {
    final alarmStorage = ref.watch(alarmStorageRepositoryProvider);
    return alarmStorage.load();
  }

  String get alarmTimeString {
    final alarm = state.alarm;
    final hour = alarm.dateTime.hour.toString().padLeft(2, '0');
    final minute = alarm.dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> setAlarm(AlarmConfig config) async {
    ref.read(alarmStorageRepositoryProvider);
    ref.read(alarmServiceProvider).set(config);
    final alarmStorage = ref.watch(alarmStorageRepositoryProvider);
    alarmStorage.save(config);
    state = config;
  }

  Future<void> stopAlarm() async {
    final nextConfig = await ref
        .read(alarmServiceProvider)
        .stopAndReschedule(state);

    if (nextConfig != null) {
      state = nextConfig;
      await ref.read(alarmStorageRepositoryProvider).save(nextConfig);
    }
  }

  Future<void> openTimePickerDialog(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(state.alarm.dateTime),
    );

    if (time != null) {
      final newAlarm = state.alarm.copyWith(
        dateTime: DateTime.now().copyWith(
          hour: time.hour,
          minute: time.minute,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        ),
      );
      await setAlarm(state.copyWith(alarm: newAlarm));
    }
  }
}
