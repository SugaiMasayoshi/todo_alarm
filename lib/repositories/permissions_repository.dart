import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/models/permissions_model.dart';
import 'package:todo_alarm/services/permissions_service.dart';

part '../generated/repositories/permissions_repository.g.dart';

@riverpod
class PermissionsRepository extends _$PermissionsRepository {
  late final PermissionsService _service = ref.watch(
    permissionsServiceProvider,
  );

  @override
  Future<PermissionsModel> build() async {
    return await _service.fetchCorePermissionsStatus();
  }

  Future<PermissionsModel> refreshCorePermissionsStatus() async {
    final permissions = await _service.fetchCorePermissionsStatus();
    if (!ref.mounted) {
      return permissions;
    }

    state = AsyncValue.data(permissions);
    return permissions;
  }

  Future<PermissionsModel> requestCorePermissions() async {
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
