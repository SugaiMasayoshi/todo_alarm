import 'package:freezed_annotation/freezed_annotation.dart';

part "../../generated/data/models/settings_model.freezed.dart";
part '../../generated/data/models/settings_model.g.dart';

@freezed
abstract class SettingsModel with _$SettingsModel {
  const factory SettingsModel({
    @Default(1.0) double alarmVolume,
    @Default(true) bool vibrateOnAlarm,
    @Default(0.5) double speechSensitivity,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
}
