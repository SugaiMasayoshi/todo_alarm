import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/models/todo_item_model.dart';
import 'package:todo_alarm/repositories/models/todo_list_model.dart';
import 'package:todo_alarm/repositories/todo_list_repository.dart';
import 'package:uuid/uuid.dart';

part '../../generated/ui/todo_list/todo_list_view_model.g.dart';

@riverpod
class TodoListViewModel extends _$TodoListViewModel {
  @override
  TodoListModel build() {
    final todoListState = ref.watch(todoListRepositoryProvider);
    return todoListState;
  }

  Future<void> addTodo(String title) async {
    final todo = TodoItemModel(
      id: const Uuid().v4(),
      title: title,
      status: TodoStatus.todo,
    );

    final newItems = Map<String, TodoItemModel>.from(state.items)
      ..[todo.id] = todo;

    await ref
        .read(todoListRepositoryProvider.notifier)
        .save(state.copyWith(items: newItems));
  }

  // 存在していないTodoを更新しようとした場合は追加されます
  Future<void> updateTodo(TodoItemModel updatedTodo) async {
    final newItems = Map<String, TodoItemModel>.from(state.items)
      ..[updatedTodo.id] = updatedTodo;

    await ref
        .read(todoListRepositoryProvider.notifier)
        .save(state.copyWith(items: newItems));
  }

  Future<void> deleteTodo(String id) async {
    await ref
        .read(todoListRepositoryProvider.notifier)
        .save(state.copyWith(items: {...state.items}..remove(id)));
  }
}
