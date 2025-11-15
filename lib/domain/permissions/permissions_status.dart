import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/domain/permissions/permissions_status.freezed.dart';

@freezed
abstract class PermissionsStatus with _$PermissionsStatus {
  const factory PermissionsStatus({
    @Default(false) bool notification,
    @Default(false) bool accessNotificationPolicy,
  }) = _PermissionsStatus;
}
