# MobX JSON Serializable Example

This example demonstrates how to use `mobx_json_serializable` to automatically serialize and deserialize MobX observable types with `json_serializable`.

## Features Demonstrated

- **ObservableList<T>**: Automatic serialization of todo lists
- **ObservableMap<K,V>**: Automatic serialization of category counts and statistics
- **ObservableSet<T>**: Automatic serialization of active tags
- **Observable<T>**: Automatic serialization of simple observables like current filter
- **Nested Observables**: Complex nested structures like `ObservableMap<String, Observable<int>>`

## Key Benefits

1. **Zero Configuration**: No custom converters needed
2. **Type Safe**: Full generic type support with proper type inference
3. **Seamless Integration**: Works with existing `@JsonSerializable()` classes
4. **Automatic Detection**: MobX types are automatically detected and handled

## Running the Example

```bash
# Install dependencies
dart pub get

# Generate code (including MobX stores and JSON serialization)
dart run build_runner build --delete-conflicting-outputs

# Run the example
dart run lib/main.dart
```

## What You'll See

The example will:
1. Create a `TodoStore` with various MobX observable types
2. Serialize it to JSON automatically
3. Deserialize it back to a new `TodoStore` instance
4. Verify that the deserialized store works correctly

## Code Structure

- `models/todo.dart`: Simple data model with standard JSON serialization
- `models/todo_store.dart`: MobX store using various observable types **without any custom converters**
- `main.dart`: Example usage showing serialization/deserialization

## Before vs After

### Before (with custom converters)
```dart
@observable
@ObservableTodoListConverter()
ObservableList<Todo> todos = ObservableList<Todo>();

class ObservableTodoListConverter extends JsonConverter<ObservableList<Todo>, List<Map<String, dynamic>>> {
  // Lots of boilerplate code...
}
```

### After (with mobx_json_serializable)
```dart
@observable
ObservableList<Todo> todos = ObservableList<Todo>(); // No converter needed!
```

The magic happens automatically during code generation! 🎉