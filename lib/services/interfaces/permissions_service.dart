import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/domain/permissions/permissions_status.dart';
import 'package:todo_alarm/services/implementations/permissions_service_impl.dart';

part '../../generated/services/interfaces/permissions_service.g.dart';

@riverpod
IPermissionsService permissionsService(Ref ref) {
  return PermissionsServiceImpl();
}

abstract class IPermissionsService {
  Future<PermissionsStatus> fetchCorePermissionsStatus();

  Future<PermissionsStatus> requestCorePermissions();

  Future<void> openAppSettingsScreen();

  Future<void> requestFullScreenPermission();
}
