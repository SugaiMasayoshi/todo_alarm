import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/local_storage_repository.dart';
import 'package:todo_alarm/repositories/models/todo_list_model.dart';

part '../generated/repositories/todo_list_repository.g.dart';

@riverpod
class TodoListRepository extends _$TodoListRepository {
  static const String _todoListKey = 'todo_list';

  @override
  TodoListModel build() {
    final storage = ref.watch(localStorageRepositoryProvider);
    final jsonString = storage.getString(_todoListKey);
    if (jsonString == null) return TodoListModel();

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    return TodoListModel.fromJson(jsonMap);
  }

  Future<void> save(TodoListModel todoList) async {
    final storage = ref.read(localStorageRepositoryProvider);
    final jsonMap = todoList.toJson();
    final jsonString = jsonEncode(jsonMap);
    await storage.setString(_todoListKey, jsonString);
    state = todoList;
  }
}
