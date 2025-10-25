import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/models/todo_item_model.dart';
import 'package:todo_alarm/repositories/models/todo_list_model.dart';
import 'package:todo_alarm/repositories/todo_repository.dart';
import 'package:uuid/uuid.dart';

part '../../generated/ui/todo_list/todo_list_view_model.g.dart';

@riverpod
class TodoListViewModel extends _$TodoListViewModel {
  @override
  TodoListModel build() {
    final todoListState = ref.watch(todoRepositoryProvider);
    return todoListState;
  }

  Future<void> addTodo({required String title}) async {
    final todo = TodoItemModel(
      id: const Uuid().v4(),
      title: title,
      status: TodoStatus.todo,
    );
    await ref.read(todoRepositoryProvider.notifier).addTodo(todo);
  }

  Future<void> updateTodo(TodoItemModel updatedTodo) async {
    await ref.read(todoRepositoryProvider.notifier).updateTodo(updatedTodo);
  }

  Future<void> deleteTodo(String id) async {
    await ref.read(todoRepositoryProvider.notifier).deleteTodo(id);
  }
}
