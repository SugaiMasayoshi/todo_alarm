import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/services/implementations/local_storage_service_impl.dart';

part '../../generated/services/interfaces/local_storage_service.g.dart';

@Riverpod(keepAlive: true)
ILocalStorageService localStorageService(Ref ref) {
  return LocalStorageServiceImpl(ref.watch(sharedPreferencesProvider));
}

abstract class ILocalStorageService {
  Future<void> setString(String key, String value);
  String? getString(String key);
  Future<void> remove(String key);
}

class GenericLocalStorage<T> {
  final ILocalStorageService _storage;
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

    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) return null;

    final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(decoded);
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
