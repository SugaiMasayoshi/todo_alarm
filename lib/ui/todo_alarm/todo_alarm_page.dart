import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/domain/permissions/permissions_status.dart';
import 'package:todo_alarm/routes/router_extension.dart';
import 'package:todo_alarm/ui/alarm/alarm.dart';
import 'package:todo_alarm/ui/todo_alarm/permissions_request_snackbar.dart';
import 'package:todo_alarm/ui/todo_alarm/permissions_request_snackbar_view_model.dart';
import 'package:todo_alarm/ui/todo_list/todo_list.dart';

class TodoAlarmPage extends ConsumerWidget {
  const TodoAlarmPage({super.key});

  bool _hasAllPermissions(PermissionsStatus permissions) {
    return permissions.notification && permissions.accessNotificationPolicy;
  }

  Future<void> _refreshAndShowPermissionsSnackBar(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final notifier = ref.read(
      permissionsRequestSnackbarViewModelProvider.notifier,
    );
    var permissions = await notifier.refreshPermissionsStatus();

    if (!context.mounted || permissions == null) {
      return;
    }

    if (_hasAllPermissions(permissions)) {
      _showOrHidePermissionsSnackBar(context, permissions);
      return;
    }

    final requestedPermissions = await notifier.requestPermissions();

    if (!context.mounted) {
      return;
    }

    permissions = requestedPermissions ?? permissions;
    _showOrHidePermissionsSnackBar(context, permissions);
  }

  void _showOrHidePermissionsSnackBar(
    BuildContext context,
    PermissionsStatus permissions,
  ) {
    if (!context.mounted) {
      return;
    }

    if (_hasAllPermissions(permissions)) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      return;
    }

    final snackBar = buildPermissionsRequestSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        return;
      }
      _refreshAndShowPermissionsSnackBar(context, ref);
    });

    ref.listen<AsyncValue<PermissionsStatus>>(
      permissionsRequestSnackbarViewModelProvider,
      (previous, next) {
        final permissions = next.asData?.value;
        if (permissions == null) {
          return;
        }

        _showOrHidePermissionsSnackBar(context, permissions);
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.navigateSettings();
          },
          icon: Icon(Icons.settings),
        ),
        title: Center(
          child: Image.asset('assets/images/app_banner.png', height: 40),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.navigateSpeech();
            },
            icon: Icon(Icons.mic),
          ),
        ],
      ),
      body: Column(
        children: [
          AlarmDisplay(),
          SizedBox(height: 20),
          Expanded(child: TodoList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.navigateTodoAdd();
        },
      ),
    );
  }
}
