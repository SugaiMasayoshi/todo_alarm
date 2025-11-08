import 'package:alarm/alarm.dart';
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
    final storage = ref.watch(settingsStorageRepositoryProvider);
    return storage.load();
  }

  Future<void> setAlarm(AlarmConfigModel config) async {
    final alarmStorageRepo = ref.read(alarmStorageRepositoryProvider);
    final currentConfig = alarmStorageRepo.load();
    if (currentConfig == config) {
      return;
    }

    final isRinging = await Alarm.isRinging();
    if (!ref.mounted) return;

    if (!isRinging) {
      final alarmRepo = ref.read(alarmRepositoryProvider);
      await alarmRepo.set(config);
      if (!ref.mounted) return;
    }

    await alarmStorageRepo.save(config);
  }

  Future<void> saveSettings(SettingsModel settings) async {
    final storage = ref.read(settingsStorageRepositoryProvider);
    final alarmStorageRepo = ref.read(alarmStorageRepositoryProvider);
    final alarmConfig = alarmStorageRepo.load();

    final newAlarmConfig = alarmConfig.copyWith(
      soundSetting: alarmConfig.soundSetting.copyWith(
        volume: settings.alarmVolume,
        vibrate: settings.vibrateOnAlarm,
      ),
    );

    await setAlarm(newAlarmConfig);
    if (!ref.mounted) return;
    await storage.save(settings);
    if (!ref.mounted) return;
    state = settings;
  }

  Future<void> setAlarmVolume(double volume) async {
    final newSettings = state.copyWith(alarmVolume: volume);
    await saveSettings(newSettings);
    if (!ref.mounted) return;
  }

  Future<void> setVibrateOnAlarm(bool vibrate) async {
    final newSettings = state.copyWith(vibrateOnAlarm: vibrate);
    await saveSettings(newSettings);
    if (!ref.mounted) return;
  }

  Future<void> setSpeechSensitivity(double sensitivity) async {
    final newSettings = state.copyWith(speechSensitivity: sensitivity);
    await saveSettings(newSettings);
    if (!ref.mounted) return;
  }
}
