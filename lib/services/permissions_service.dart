import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/models/permissions_model.dart';

part '../generated/services/permissions_service.g.dart';

@riverpod
PermissionsService permissionsService(Ref ref) {
  return PermissionsService();
}

class PermissionsService {
  Future<PermissionsModel> fetchCorePermissionsStatus() async {
    final notificationStatus = await Permission.notification.status;
    final accessPolicyStatus = await Permission.accessNotificationPolicy.status;

    return PermissionsModel(
      notification: notificationStatus.isGranted,
      accessNotificationPolicy: accessPolicyStatus.isGranted,
    );
  }

  Future<PermissionsModel> requestCorePermissions() async {
    final results = await [
      Permission.notification,
      Permission.accessNotificationPolicy,
    ].request();

    return PermissionsModel(
      notification: results[Permission.notification]?.isGranted ?? false,
      accessNotificationPolicy:
          results[Permission.accessNotificationPolicy]?.isGranted ?? false,
    );
  }

  Future<void> openAppSettingsScreen() async {
    if (!Platform.isAndroid) {
      await openAppSettings();
      return;
    }

    await openAppSettings();
  }

  Future<void> requestFullScreenPermission() async {
    await openAppSettingsScreen();
  }
}
