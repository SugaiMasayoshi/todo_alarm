import 'dart:convert';

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

class GenericLocalStorage<T> {
  final ILocalStorageRepository _storage;
  final String key;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  GenericLocalStorage(
    this._storage, {
    required this.key,
    required this.fromJson,
    required this.toJson,
  });

  T? load() {
    final jsonString = _storage.getString(key);
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(
      jsonDecode(jsonString),
    );
    return fromJson(jsonMap);
  }

  Future<void> save(T value) async {
    final jsonMap = toJson(value);
    final jsonString = jsonEncode(jsonMap);
    await _storage.setString(key, jsonString);
  }

  Future<void> remove() async {
    await _storage.remove(key);
  }
}
