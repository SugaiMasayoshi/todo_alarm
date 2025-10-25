import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/repositories/models/alarm_sound_setting_model.freezed.dart';
part '../../generated/repositories/models/alarm_sound_setting_model.g.dart';

@freezed
abstract class AlarmSoundSettingModel with _$AlarmSoundSettingModel {
  factory AlarmSoundSettingModel({
    required String assetAudioPath,
    required double volume,
    required bool vibrate,
  }) = _AlarmSoundSettingModel;

  factory AlarmSoundSettingModel.fromJson(Map<String, dynamic> json) =>
      _$AlarmSoundSettingModelFromJson(json);
}
