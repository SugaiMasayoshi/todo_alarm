import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:todo_alarm/repositories/alarm_repository.dart';
import 'package:todo_alarm/repositories/models/alarm_model.dart';

class AlarmPluginRepository implements IAlarmRepository {
  final int id = 1;

  @override
  Future<void> set(AlarmModel alarm) {
    return Alarm.set(
      alarmSettings: AlarmSettings(
        id: id,
        dateTime: alarm.dateTime,
        assetAudioPath: 'assets/alarm.mp3',
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
