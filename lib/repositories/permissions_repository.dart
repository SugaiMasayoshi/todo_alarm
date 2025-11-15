import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/domain/permissions/permissions_status.dart';
import 'package:todo_alarm/services/interfaces/permissions_service.dart';

part '../generated/repositories/permissions_repository.g.dart';

@riverpod
class PermissionsRepository extends _$PermissionsRepository {
  late final IPermissionsService _service = ref.watch(
    permissionsServiceProvider,
  );

  @override
  Future<PermissionsStatus> build() async {
    return await _service.fetchCorePermissionsStatus();
  }

  Future<PermissionsStatus> refreshCorePermissionsStatus() async {
    final permissions = await _service.fetchCorePermissionsStatus();
    if (!ref.mounted) {
      return permissions;
    }

    state = AsyncValue.data(permissions);
    return permissions;
  }

  Future<PermissionsStatus> requestCorePermissions() async {
    final permissions = await _service.requestCorePermissions();
    if (!ref.mounted) {
      return permissions;
    }

    state = AsyncValue.data(permissions);
    return permissions;
  }

  Future<void> openPermissionSettings() async {
    await _service.openAppSettingsScreen();
  }

  Future<void> requestFullScreenPermission() async {
    await _service.requestFullScreenPermission();
  }
}
