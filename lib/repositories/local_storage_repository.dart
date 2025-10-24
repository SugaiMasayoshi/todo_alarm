import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/shared_preferences_repository.dart';

part '../generated/repositories/local_storage_repository.g.dart';

abstract class ILocalStorageRepository {
  Future<void> setString(String key, String value);
  String? getString(String key);
  Future<void> remove(String key);
}

@riverpod
ILocalStorageRepository localStorageRepository(Ref ref) {
  return SharedPreferencesRepository(ref.watch(sharedPreferencesProvider));
}
