import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/models/todo_item_model.dart';
import 'package:todo_alarm/repositories/models/todo_list_model.dart';
import 'package:todo_alarm/repositories/todo_list_repository.dart';
import 'package:uuid/uuid.dart';

part '../../generated/ui/todo_list/todo_list_view_model.g.dart';

@riverpod
class TodoListViewModel extends _$TodoListViewModel {
  late final TodoListRepository _repository;

  @override
  TodoListModel build() {
    _repository = ref.watch(todoListRepositoryProvider);
    return _repository.load();
  }

  Future<void> addTodo(String title) async {
    final todo = TodoItemModel(
      id: const Uuid().v4(),
      title: title,
      status: TodoStatus.todo,
    );

    final newItems = [...state.items, todo];
    final newState = state.copyWith(items: newItems);

    await _repository.save(newState);
    state = newState;
  }

  Future<void> updateTodo(TodoItemModel updatedTodo) async {
    final newItems = [...state.items];
    newItems[state.items.indexWhere((item) => item.id == updatedTodo.id)] =
        updatedTodo;
    final newState = state.copyWith(items: newItems);

    await _repository.save(newState);
    state = newState;
  }

  Future<void> deleteTodo(String id) async {
    final newItems = [...state.items]..removeWhere((item) => item.id == id);
    final newState = state.copyWith(items: newItems);

    await _repository.save(newState);
    state = newState;
  }

  Future<void> reorderTodos(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final movedItem = state.items[oldIndex];
    final newItems = [...state.items]
      ..removeAt(oldIndex)
      ..insert(newIndex, movedItem);

    final newState = TodoListModel(items: newItems);

    await _repository.save(newState);
    state = newState;
  }
}
