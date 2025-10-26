import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/local_storage_repository.dart';
import 'package:todo_alarm/repositories/models/todo_list_model.dart';

part '../generated/repositories/todo_list_repository.g.dart';

@riverpod
GenericLocalStorage<TodoListModel> todoListStorage(Ref ref) {
  final storage = ref.watch(localStorageRepositoryProvider);
  return GenericLocalStorage<TodoListModel>(
    storage,
    key: 'todo_list',
    fromJson: (m) => TodoListModel.fromJson(m),
    toJson: (t) => t.toJson(),
  );
}

@riverpod
TodoListRepository todoListRepository(Ref ref) {
  final storage = ref.watch(todoListStorageProvider);
  return TodoListRepository(storage);
}

class TodoListRepository {
  final GenericLocalStorage<TodoListModel> storage;

  TodoListRepository(this.storage);

  TodoListModel load() {
    return storage.load() ?? TodoListModel();
  }

  Future<void> save(TodoListModel todoList) async {
    await storage.save(todoList);
  }
}
