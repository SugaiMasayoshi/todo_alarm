import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

SnackBar buildPermissionsRequestSnackBar() {
  return SnackBar(
    backgroundColor: Colors.red,
    content: Text('必要な権限が許可されていません。設定から権限を付与してください。'),
    action: SnackBarAction(
      textColor: Colors.white,
      label: '設定',
      onPressed: () {
        openAppSettings();
      },
    ),
    duration: Duration(seconds: 5),
  );
}
