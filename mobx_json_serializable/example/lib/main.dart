import 'dart:convert';
import 'package:mobx_json_serializable_example/models/todo.dart';
import 'package:mobx_json_serializable_example/models/todo_store.dart';

void main() {
  print('MobX JSON Serializable Example');
  print('===============================');

  // Create a new TodoStore
  final store = TodoStore();

  // Add some sample todos
  store.addTodo(Todo(
    id: '1',
    title: 'Learn MobX',
    description: 'Study reactive programming with MobX',
  ));

  store.addTodo(Todo(
    id: '2',
    title: 'Build Flutter app',
    description: 'Create an awesome Flutter application',
    completed: true,
  ));

  store.addTodo(Todo(
    id: '3',
    title: 'Test JSON serialization',
    description: 'Verify that MobX observables serialize correctly',
  ));

  // Add some categories
  store.categoryCounts['Work'] = 2;
  store.categoryCounts['Personal'] = 1;

  // Add some tags
  store.addTag('flutter');
  store.addTag('mobx');
  store.addTag('dart');

  // Set current filter
  store.setFilter('active');

  print('\n1. Original TodoStore:');
  print('  - Todos: ${store.todos.length}');
  print('  - Categories: ${store.categoryCounts.keys.join(', ')}');
  print('  - Tags: ${store.activeTags.join(', ')}');
  print('  - Filter: ${store.currentFilter.value}');

  // Serialize to JSON
  final jsonMap = store.toJson();
  final jsonString = const JsonEncoder.withIndent('  ').convert(jsonMap);

  print('\n2. Serialized JSON:');
  print(jsonString);

  // Deserialize from JSON
  final deserializedStore = TodoStore.fromJson(jsonMap);

  print('\n3. Deserialized TodoStore:');
  print('  - Todos: ${deserializedStore.todos.length}');
  print('  - Categories: ${deserializedStore.categoryCounts.keys.join(', ')}');
  print('  - Tags: ${deserializedStore.activeTags.join(', ')}');
  print('  - Filter: ${deserializedStore.currentFilter.value}');

  // Verify that deserialized observables work correctly
  print('\n4. Testing reactive functionality:');
  print('  - Adding new todo to deserialized store...');

  deserializedStore.addTodo(Todo(
    id: '4',
    title: 'Verify deserialized store works',
    description: 'Make sure the deserialized store is fully functional',
  ));

  print('  - Todos after addition: ${deserializedStore.todos.length}');

  deserializedStore.addTag('testing');
  print('  - Tags after addition: ${deserializedStore.activeTags.join(', ')}');

  print('\n✅ MobX JSON Serialization completed successfully!');
  print('   All observable types were automatically handled without custom converters.');
}