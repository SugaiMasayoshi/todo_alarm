import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/data/models/alarm_model.freezed.dart';
part '../../generated/data/models/alarm_model.g.dart';

@freezed
abstract class AlarmModel with _$AlarmModel {
  factory AlarmModel({required DateTime dateTime}) = _AlarmModel;

  factory AlarmModel.fromJson(Map<String, dynamic> json) =>
      _$AlarmModelFromJson(json);
}
