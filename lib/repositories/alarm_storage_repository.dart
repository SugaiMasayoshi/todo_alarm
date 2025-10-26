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
class AlarmStorageRepository extends _$AlarmStorageRepository {
  @override
  AlarmConfigModel build() {
    final storage = ref.watch(alarmStorageProvider);

    return storage.load() ??
        AlarmConfigModel(
          soundSetting: AlarmSoundSettingModel(
            assetAudioPath: "assets/audios/bell.mp3",
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
    final storage = ref.read(alarmStorageProvider);
    await storage.save(alarm);
    state = alarm;
  }
}
