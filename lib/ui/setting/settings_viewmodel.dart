import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/alarm_repository.dart';
import 'package:todo_alarm/repositories/alarm_storage_repository.dart';
import 'package:todo_alarm/repositories/models/alarm_config_model.dart';
import 'package:todo_alarm/repositories/models/settings_model.dart';
import 'package:todo_alarm/repositories/settings_storage_repository.dart';

part "../../generated/ui/setting/settings_viewmodel.g.dart";

@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  @override
  SettingsModel build() {
    final storage = ref.watch(settingsStorageProvider);
    return storage.load() ?? SettingsModel();
  }

  Future<void> setAlarm(AlarmConfigModel config) async {
    await ref.read(alarmRepositoryProvider).set(config.alarm);
    await ref.read(alarmStorageRepositoryProvider).save(config);
  }

  Future<void> saveSettings(SettingsModel settings) async {
    final storage = ref.watch(settingsStorageRepositoryProvider);
    final alarmConfig = ref.read(alarmStorageRepositoryProvider).load();

    final newAlarmConfig = alarmConfig.copyWith(
      soundSetting: alarmConfig.soundSetting.copyWith(
        volume: settings.alarmVolume,
        vibrate: settings.vibrateOnAlarm,
      ),
    );

    await setAlarm(newAlarmConfig);
    await storage.save(settings);
    state = settings;
  }

  Future<void> setAlarmVolume(double volume) async {
    final newSettings = state.copyWith(alarmVolume: volume);
    await saveSettings(newSettings);
  }

  Future<void> setVibrateOnAlarm(bool vibrate) async {
    final newSettings = state.copyWith(vibrateOnAlarm: vibrate);
    await saveSettings(newSettings);
  }

  Future<void> setSpeechSensitivity(double sensitivity) async {
    final newSettings = state.copyWith(speechSensitivity: sensitivity);
    await saveSettings(newSettings);
  }
}
