import 'dart:ui';

import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:alarm/model/volume_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/domain/alarm/alarm_config.dart';
import 'package:todo_alarm/services/interfaces/local_storage_service.dart';
part '../generated/repositories/alarm_storage_repository.g.dart';

@riverpod
GenericLocalStorage<AlarmConfig> alarmStorage(Ref ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return GenericLocalStorage<AlarmConfig>(
    storage,
    key: 'alarm',
    fromJson: (m) => AlarmConfig.fromJson(m),
    toJson: (t) => t.toJson(),
  );
}

@riverpod
AlarmStorageRepository alarmStorageRepository(Ref ref) {
  final storage = ref.watch(alarmStorageProvider);
  return AlarmStorageRepository(storage);
}

AlarmSettings defaultSetting() {
  return AlarmSettings(
    id: 1,
    dateTime: DateTime.now().add(const Duration(hours: 1)),
    assetAudioPath: 'assets/sounds/alarm.mp3',
    loopAudio: true,
    vibrate: true,
    warningNotificationOnKill: true,
    androidFullScreenIntent: true,
    volumeSettings: VolumeSettings.fade(
      volume: 1.0,
      fadeDuration: Duration(seconds: 5),
      volumeEnforced: true,
    ),
    notificationSettings: NotificationSettings(
      title: 'やることを読み上げてアラームを停止',
      body: '時間です！',
      iconColor: Color.fromARGB(255, 5, 89, 146),
    ),
  );
}

class AlarmStorageRepository {
  final GenericLocalStorage<AlarmConfig> storage;

  AlarmStorageRepository(this.storage);

  AlarmConfig load() {
    return storage.load() ?? AlarmConfig.defaultConfig();
  }

  Future<void> save(AlarmConfig alarmConfig) async {
    await storage.save(alarmConfig);
  }
}
