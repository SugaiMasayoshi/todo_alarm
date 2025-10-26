import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/alarm_repository.dart';
import 'package:todo_alarm/repositories/alarm_storage_repository.dart';
import 'package:todo_alarm/repositories/models/alarm_config_model.dart';

part '../../generated/ui/alarm/alarm_view_model.g.dart';

@riverpod
class AlarmViewModel extends _$AlarmViewModel {
  @override
  AlarmConfigModel build() {
    final storageRepository = ref.watch(alarmStorageRepositoryProvider);
    return storageRepository.load();
  }

  String get alarmTimeString {
    final alarm = state.alarm;
    final hour = alarm.dateTime.hour.toString().padLeft(2, '0');
    final minute = alarm.dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> setAlarm(AlarmConfigModel config) async {
    await ref.read(alarmRepositoryProvider).set(config.alarm);
    await ref.read(alarmStorageRepositoryProvider).save(config);
    state = config;
  }

  Future<void> stopAlarm() async {
    await ref.read(alarmRepositoryProvider).stop();
  }

  Future<void> openTimePickerDialog(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(state.alarm.dateTime),
    );

    if (time != null) {
      final newAlarm = state.alarm.copyWith(
        dateTime: DateTime.now().copyWith(hour: time.hour, minute: time.minute),
      );
      await setAlarm(state.copyWith(alarm: newAlarm));
    }
  }
}
