import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_alarm/repositories/models/alarm_model.dart';
import 'package:todo_alarm/repositories/models/alarm_sound_setting_model.dart';

part '../../generated/repositories/models/alarm_config_model.freezed.dart';
part '../../generated/repositories/models/alarm_config_model.g.dart';

@freezed
abstract class AlarmConfigModel with _$AlarmConfigModel {
  const factory AlarmConfigModel({
    required AlarmSoundSettingModel soundSetting,
    required AlarmModel alarm,
  }) = _AlarmConfigModel;

  factory AlarmConfigModel.fromJson(Map<String, dynamic> json) =>
      _$AlarmConfigModelFromJson(json);
}
