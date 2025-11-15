import 'dart:ui';

import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:alarm/model/volume_settings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_alarm/repositories/models/alarm_model.dart';
import 'package:todo_alarm/repositories/models/alarm_sound_setting_model.dart';

part '../../generated/domain/alarm/alarm_config.freezed.dart';
part '../../generated/domain/alarm/alarm_config.g.dart';

@freezed
abstract class AlarmConfig with _$AlarmConfig {
  const AlarmConfig._();

  const factory AlarmConfig({
    required AlarmSoundSettingModel soundSetting,
    required AlarmModel alarm,
  }) = _AlarmConfig;

  factory AlarmConfig.defaultConfig() => AlarmConfig(
    soundSetting: AlarmSoundSettingModel(
      assetAudioPath: "assets/sounds/alarm.mp3",
      volume: 0.5,
      vibrate: true,
    ),
    alarm: AlarmModel(
      dateTime: DateTime.now().add(const Duration(hours: 1)),
      title: 'Alarm Title',
    ),
  );

  AlarmSettings toAlarmSettings() {
    return AlarmSettings(
      id: 1,
      dateTime: alarm.dateTime,
      assetAudioPath: soundSetting.assetAudioPath,
      loopAudio: true,
      vibrate: soundSetting.vibrate,
      warningNotificationOnKill: true,
      androidFullScreenIntent: true,
      volumeSettings: VolumeSettings.fade(
        volume: soundSetting.volume,
        fadeDuration: Duration(seconds: 5),
        volumeEnforced: true,
      ),
      notificationSettings: NotificationSettings(
        title: alarm.title,
        body: '時間です！',
        iconColor: const Color.fromARGB(255, 5, 89, 146),
      ),
    );
  }

  factory AlarmConfig.fromJson(Map<String, dynamic> json) =>
      _$AlarmConfigFromJson(json);
}
