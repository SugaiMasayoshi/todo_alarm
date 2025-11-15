import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/domain/permissions/permissions_status.dart';
import 'package:todo_alarm/repositories/permissions_repository.dart';

part '../../generated/ui/todo_alarm/todo_alarm_view_model.g.dart';

@riverpod
class TodoAlarmViewModel extends _$TodoAlarmViewModel {
  @override
  AsyncValue<PermissionsStatus> build() {
    return ref.watch(permissionsRepositoryProvider);
  }

  Future<PermissionsStatus> requestPermissions() async {
    final permissions = await ref
        .read(permissionsRepositoryProvider.notifier)
        .requestCorePermissions();

    if (!ref.mounted) {
      return permissions;
    }

    state = AsyncValue.data(permissions);
    return permissions;
  }
}
