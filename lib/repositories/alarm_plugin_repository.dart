import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/repositories/alarm_repository.dart';
import 'package:todo_alarm/repositories/models/alarm_config_model.dart';

final alarmRingingStreamProvider = StreamProvider<AlarmSet>((ref) {
  return Alarm.ringing;
});

class AlarmPluginRepository implements IAlarmRepository {
  final int id = 1;

  @override
  Future<void> set(AlarmConfigModel alarmConfig) async {
    // Alarm.set already replaces alarms with the same id or scheduled time, so
    // calling stop beforehand can surface platform errors when nothing is active.
    var alarmDateTime = alarmConfig.alarm.dateTime;
    final now = DateTime.now();

    if (alarmDateTime.isBefore(now)) {
      alarmDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        alarmDateTime.hour,
        alarmDateTime.minute,
      ).add(const Duration(days: 1));

      print(
        '⏰ Alarm time is in the past. Setting for tomorrow: $alarmDateTime',
      );
    }

    await Alarm.set(
      alarmSettings: AlarmSettings(
        id: id,
        dateTime: alarmDateTime,
        assetAudioPath: 'assets/sounds/alarm.mp3',
        loopAudio: true,
        vibrate: alarmConfig.soundSetting.vibrate,
        warningNotificationOnKill: true,
        androidFullScreenIntent: true,
        volumeSettings: VolumeSettings.fade(
          volume: alarmConfig.soundSetting.volume,
          fadeDuration: Duration(seconds: 5),
          volumeEnforced: true,
        ),
        notificationSettings: NotificationSettings(
          title: 'やることを読み上げてアラームを停止',
          body: alarmConfig.alarm.title,
          iconColor: Color.fromARGB(255, 5, 89, 146),
        ),
      ),
    );
  }

  @override
  Future<void> stop() async {
    await Alarm.stop(id);
  }
}
