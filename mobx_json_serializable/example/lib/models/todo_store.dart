import 'package:mobx/mobx.dart';
import 'package:mobx_json_serializable/mobx_json_serializable.dart';
import 'todo.dart';

part 'todo_store.g.dart';

@JsonSerializable()
class TodoStore with Store {
  TodoStore();

  /// List of all todos - automatically serialized by TypeHelper
  @observable
  ObservableList<Todo> todos = ObservableList<Todo>();

  /// Map of todo categories to counts - automatically serialized by TypeHelper
  @observable
  ObservableMap<String, int> categoryCounts = ObservableMap<String, int>();

  /// Set of active tags - automatically serialized by TypeHelper
  @observable
  ObservableSet<String> activeTags = ObservableSet<String>();

  /// Current filter setting - automatically serialized by TypeHelper
  @observable
  Observable<String?> currentFilter = Observable(null);

  /// Statistics computed from todos - complex nested observables
  @observable
  ObservableMap<String, Observable<int>> stats = ObservableMap<String, Observable<int>>();

  @action
  void addTodo(Todo todo) {
    todos.add(todo);
    _updateStats();
  }

  @action
  void removeTodo(String id) {
    todos.removeWhere((todo) => todo.id == id);
    _updateStats();
  }

  @action
  void toggleTodo(String id) {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final todo = todos[index];
      todos[index] = todo.copyWith(completed: !todo.completed);
      _updateStats();
    }
  }

  @action
  void setFilter(String? filter) {
    currentFilter.value = filter;
  }

  @action
  void addTag(String tag) {
    activeTags.add(tag);
  }

  @action
  void removeTag(String tag) {
    activeTags.remove(tag);
  }

  void _updateStats() {
    final completed = todos.where((todo) => todo.completed).length;
    final pending = todos.length - completed;

    stats['completed'] = Observable(completed);
    stats['pending'] = Observable(pending);
    stats['total'] = Observable(todos.length);
  }

  // Standard json_serializable methods - no custom converters needed!
  factory TodoStore.fromJson(Map<String, dynamic> json) => _$TodoStoreFromJson(json);
  Map<String, dynamic> toJson() => _$TodoStoreToJson(this);
}