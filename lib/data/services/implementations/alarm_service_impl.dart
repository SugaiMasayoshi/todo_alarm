import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/domain/alarm/alarm_config.dart';
import 'package:todo_alarm/data/services/interfaces/alarm_service.dart';

final alarmRingingStreamProvider = StreamProvider<AlarmSet>((ref) {
  return Alarm.ringing;
});

class AlarmServiceImpl implements IAlarmService {
  final int _id = 1;

  @override
  Future<void> set(AlarmConfig alarmConfig) async {
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
    }

    await Alarm.set(
      alarmSettings: AlarmSettings(
        id: _id,
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
          title: "Todo Alarm",
          body: 'やることを読み上げてアラームを停止',
          iconColor: Color.fromARGB(255, 5, 89, 146),
        ),
      ),
    );
  }

  @override
  Future<AlarmConfig?> stopAndReschedule(AlarmConfig alarmConfig) async {
    final isRinging = await Alarm.isRinging();
    if (!isRinging) {
      return null;
    }

    await Alarm.stop(_id);

    final nextConfig = alarmConfig.copyWith(
      alarm: alarmConfig.alarm.copyWith(
        dateTime: alarmConfig.alarm.dateTime.add(const Duration(days: 1)),
      ),
    );

    await set(nextConfig);
    return nextConfig;
  }
}
