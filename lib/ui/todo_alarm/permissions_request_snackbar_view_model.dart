import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/models/permissions_model.dart';
import 'package:todo_alarm/repositories/permissions_repository.dart';

part '../../generated/ui/todo_alarm/permissions_request_snackbar_view_model.g.dart';

@riverpod
class PermissionsRequestSnackbarViewModel
    extends _$PermissionsRequestSnackbarViewModel {
  @override
  AsyncValue<PermissionsModel> build() {
    final state = ref.watch(permissionsRepositoryProvider);
    return state;
  }

  Future<PermissionsModel?> refreshPermissionsStatus() async {
    final result = await AsyncValue.guard(() async {
      return await ref
          .read(permissionsRepositoryProvider.notifier)
          .refreshCorePermissionsStatus();
    });

    if (!ref.mounted) {
      return result.asData?.value;
    }

    state = result;
    return result.asData?.value;
  }

  Future<PermissionsModel?> requestPermissions() async {
    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(() async {
      return await ref
          .read(permissionsRepositoryProvider.notifier)
          .requestCorePermissions();
    });

    final permissions = result.asData?.value;

    if (!ref.mounted) {
      return permissions;
    }

    state = result;

    if (permissions == null) {
      return null;
    }

    if (!permissions.notification || !permissions.accessNotificationPolicy) {
      await ref
          .read(permissionsRepositoryProvider.notifier)
          .openPermissionSettings();
      return await refreshPermissionsStatus();
    }

    return permissions;
  }

  Future<void> openPermissionSettings() async {
    await ref
        .read(permissionsRepositoryProvider.notifier)
        .openPermissionSettings();
  }
}
