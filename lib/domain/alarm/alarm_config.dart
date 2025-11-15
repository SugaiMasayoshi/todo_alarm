import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_alarm/repositories/models/alarm_model.dart';
import 'package:todo_alarm/repositories/models/alarm_sound_setting_model.dart';

part '../../generated/domain/alarm/alarm_config.freezed.dart';
part '../../generated/domain/alarm/alarm_config.g.dart';

@freezed
abstract class AlarmConfig with _$AlarmConfig {
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

  factory AlarmConfig.fromJson(Map<String, dynamic> json) =>
      _$AlarmConfigFromJson(json);
}
