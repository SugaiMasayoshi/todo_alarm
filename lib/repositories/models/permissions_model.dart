import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/repositories/models/permissions_state.freezed.dart';

@freezed
abstract class PermissionsModel with _$PermissionsModel {
  const factory PermissionsModel({
    @Default(false) bool notification,
    @Default(false) bool accessNotificationPolicy,
  }) = _PermissionsModel;
}
