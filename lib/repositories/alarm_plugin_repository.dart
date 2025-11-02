import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:todo_alarm/repositories/alarm_repository.dart';
import 'package:todo_alarm/repositories/models/alarm_model.dart';

class AlarmPluginRepository implements IAlarmRepository {
  final int id = 1;

  @override
  Future<void> set(AlarmModel alarm) async {
    // 既存のアラームを停止してから新しいアラームをセット
    await Alarm.stop(id);

    // 過去の時刻の場合は翌日に設定
    var alarmDateTime = alarm.dateTime;
    final now = DateTime.now();

    if (alarmDateTime.isBefore(now)) {
      // 今日の指定時刻が過ぎている場合は翌日に設定
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
        vibrate: true,
        warningNotificationOnKill: Platform.isIOS,
        androidFullScreenIntent: true,
        volumeSettings: VolumeSettings.fade(
          volume: 0.8,
          fadeDuration: Duration(seconds: 5),
          volumeEnforced: true,
        ),
        notificationSettings: NotificationSettings(
          title: '今日の目標を達成しましょう！',
          body: alarm.title,
          icon: 'notification_icon',
          iconColor: Colors.blue,
        ),
      ),
    );
  }

  @override
  Future<void> stop() async {
    await Alarm.stop(id);
  }
}
