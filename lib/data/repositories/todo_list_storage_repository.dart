import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/data/models/todo_list_model.dart';
import 'package:todo_alarm/data/services/interfaces/local_storage_service.dart';

part '../../generated/data/repositories/todo_list_storage_repository.g.dart';

@riverpod
GenericLocalStorage<TodoListModel> todoListStorage(Ref ref) {
  final storage = ref.watch(localStorageServiceProvider);
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
