import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:todo_alarm/domain/permissions/permissions_status.dart';
import 'package:todo_alarm/data/services/interfaces/permissions_service.dart';

class PermissionsServiceImpl implements IPermissionsService {
  @override
  Future<PermissionsStatus> fetchCorePermissionsStatus() async {
    final notificationStatus = await Permission.notification.status;
    final accessPolicyStatus = await Permission.accessNotificationPolicy.status;

    return PermissionsStatus(
      notification: notificationStatus.isGranted,
      accessNotificationPolicy: accessPolicyStatus.isGranted,
    );
  }

  @override
  Future<PermissionsStatus> requestCorePermissions() async {
    final results = await [
      Permission.notification,
      Permission.accessNotificationPolicy,
    ].request();

    return PermissionsStatus(
      notification: results[Permission.notification]?.isGranted ?? false,
      accessNotificationPolicy:
          results[Permission.accessNotificationPolicy]?.isGranted ?? false,
    );
  }

  @override
  Future<void> openAppSettingsScreen() async {
    if (!Platform.isAndroid) {
      await openAppSettings();
      return;
    }

    await openAppSettings();
  }

  @override
  Future<void> requestFullScreenPermission() async {
    await openAppSettingsScreen();
  }
}
