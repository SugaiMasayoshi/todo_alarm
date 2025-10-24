import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/local_storage_repository.dart';
import 'package:todo_alarm/repositories/models/todo_list_model.dart';
import 'models/todo_item_model.dart';

part '../generated/repositories/todo_repository.g.dart';

@riverpod
class TodoRepository extends _$TodoRepository {
  static const String _todoListKey = 'todo_list';

  @override
  TodoListModel build() {
    final storage = ref.watch(localStorageRepositoryProvider);
    final jsonString = storage.getString(_todoListKey);
    if (jsonString == null) return TodoListModel();

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    return TodoListModel.fromJson(jsonMap);
  }

  Future<void> _saveTodoList(TodoListModel todoList) async {
    final storage = ref.read(localStorageRepositoryProvider);
    final jsonMap = todoList.toJson();
    final jsonString = jsonEncode(jsonMap);
    await storage.setString(_todoListKey, jsonString);
    state = todoList;
  }

  Future<void> addTodo(TodoItemModel todo) async {
    await _saveTodoList(state.copyWith(items: {...state.items, todo.id: todo}));
  }

  Future<void> updateTodo(TodoItemModel updatedTodo) async {
    final newItems = Map<String, TodoItemModel>.from(state.items);
    if (newItems.containsKey(updatedTodo.id)) {
      newItems[updatedTodo.id] = updatedTodo;
    }
    await _saveTodoList(state.copyWith(items: newItems));
  }

  Future<void> deleteTodo(String id) async {
    final newItems = Map<String, TodoItemModel>.from(state.items);
    newItems.remove(id);
    await _saveTodoList(state.copyWith(items: newItems));
  }
}
