import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/local_storage_repository.dart';
import 'package:todo_alarm/repositories/models/settings_model.dart';

part '../generated/repositories/settings_storage_repository.g.dart';

@riverpod
GenericLocalStorage<SettingsModel> settingsStorage(Ref ref) {
  final storage = ref.watch(localStorageRepositoryProvider);
  return GenericLocalStorage<SettingsModel>(
    storage,
    key: 'settings',
    fromJson: (m) => SettingsModel.fromJson(m),
    toJson: (t) => t.toJson(),
  );
}

@riverpod
SettingsStorageRepository settingsStorageRepository(Ref ref) {
  final storage = ref.watch(settingsStorageProvider);
  return SettingsStorageRepository(storage);
}

class SettingsStorageRepository {
  final GenericLocalStorage<SettingsModel> storage;

  SettingsStorageRepository(this.storage);

  SettingsModel load() {
    return storage.load() ?? SettingsModel();
  }

  Future<void> save(SettingsModel settings) async {
    await storage.save(settings);
  }
}
