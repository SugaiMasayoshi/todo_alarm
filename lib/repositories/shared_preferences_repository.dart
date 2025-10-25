import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_alarm/repositories/local_storage_repository.dart';

part '../generated/repositories/shared_preferences_repository.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError('main関数でSharedPreferencesの初期化を行ってください');
}

class SharedPreferencesRepository implements ILocalStorageRepository {
  final SharedPreferences _prefs;

  SharedPreferencesRepository(this._prefs);

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }
}
