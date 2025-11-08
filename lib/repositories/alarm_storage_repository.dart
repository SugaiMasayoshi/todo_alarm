import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/local_storage_repository.dart';
import 'package:todo_alarm/repositories/models/alarm_config_model.dart';
import 'package:todo_alarm/repositories/models/alarm_model.dart';
import 'package:todo_alarm/repositories/models/alarm_sound_setting_model.dart';

part '../generated/repositories/alarm_storage_repository.g.dart';

@riverpod
GenericLocalStorage<AlarmConfigModel> alarmStorage(Ref ref) {
  final storage = ref.watch(localStorageRepositoryProvider);
  return GenericLocalStorage<AlarmConfigModel>(
    storage,
    key: 'alarm',
    fromJson: (m) => AlarmConfigModel.fromJson(m),
    toJson: (t) => t.toJson(),
  );
}

@riverpod
AlarmStorageRepository alarmStorageRepository(Ref ref) {
  final storage = ref.watch(alarmStorageProvider);
  return AlarmStorageRepository(storage);
}

class AlarmStorageRepository {
  final GenericLocalStorage<AlarmConfigModel> storage;

  AlarmStorageRepository(this.storage);

  AlarmConfigModel load() {
    // Todo: 設定がない場合のデフォルト値を共通化
    return storage.load() ??
        AlarmConfigModel(
          soundSetting: AlarmSoundSettingModel(
            assetAudioPath: "assets/sounds/alarm.mp3",
            volume: 0.3,
            vibrate: true,
          ),
          alarm: AlarmModel(
            dateTime: DateTime.now().subtract(const Duration(hours: 1)),
            title: 'Alarm Title',
          ),
        );
  }

  Future<void> save(AlarmConfigModel alarm) async {
    await storage.save(alarm);
  }
}
