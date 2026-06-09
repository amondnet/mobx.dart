# MobX JSON Serializable

[![pub package](https://img.shields.io/pub/v/mobx_json_serializable.svg)](https://pub.dev/packages/mobx_json_serializable)
[![Build Status](https://github.com/mobxjs/mobx.dart/workflows/Build/badge.svg)](https://github.com/mobxjs/mobx.dart/actions)

JSON serialization support for MobX observable types with `json_serializable`. Provides **JsonConverter** classes and **TypeHelper** support for seamless serialization.

## Features

- ✅ **JsonConverters** for `Observable<T>`, `ObservableList<T>`, `ObservableMap<K,V>`, `ObservableSet<T>`
- ✅ **TypeHelper** support for automatic detection (advanced)
- ✅ Support for complex nested observable structures
- ✅ Type-safe serialization with proper null handling
- ✅ Seamless integration with existing `json_serializable` workflow
- ✅ Support for generic types with proper type inference
- ✅ Compatible with custom `equals` functions
- ✅ Two approaches: annotation-based and automatic detection

## Installation

Add `mobx_json_serializable` to your dependencies:

```yaml
dependencies:
  mobx: ^2.5.0
  json_annotation: ^4.8.1
  mobx_json_serializable: ^1.0.0

dev_dependencies:
  build_runner: ^2.6.0
  json_serializable: ^6.7.1
  mobx_codegen: ^2.7.2
```

## Quick Start (JsonConverter Approach - Recommended)

```dart
import 'package:mobx_json_serializable/mobx_json_serializable.dart';

part 'todo_store.g.dart';

@JsonSerializable()
class TodoStore = _TodoStore with _$TodoStore;

abstract class _TodoStore with Store {
  @observable
  @ObservableListConverter()
  ObservableList<String> todos = ObservableList<String>();

  @observable
  @ObservableMapConverter()
  ObservableMap<String, int> counts = ObservableMap<String, int>();

  @observable
  @ObservableConverter()
  Observable<String?> filter = Observable(null);

  @observable
  @ObservableSetConverter()
  ObservableSet<String> tags = ObservableSet<String>();

  // Standard json_serializable methods
  factory _TodoStore.fromJson(Map<String, dynamic> json) => _$TodoStoreFromJson(json);
  Map<String, dynamic> toJson() => _$TodoStoreToJson(this);
}
```

### Code Generation

Run the standard build_runner command:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Advanced Usage (TypeHelper Approach)

For automatic detection without annotations, configure your `build.yaml`:

```yaml
targets:
  $default:
    builders:
      mobx_json_serializable|mobx_json_serializable_generator:
        enabled: true
```

Then use stores without converter annotations (TypeHelper will detect MobX types automatically).

## Before vs After

### Before (with custom converters) 😰

```dart
class TodoStore {
  @observable
  @ObservableTodoListConverter()  // Custom converter required
  ObservableList<Todo> todos = ObservableList<Todo>();
}

// Lots of boilerplate code
class ObservableTodoListConverter extends JsonConverter<ObservableList<Todo>, List<Map<String, dynamic>>> {
  const ObservableTodoListConverter();

  @override
  ObservableList<Todo> fromJson(List<Map<String, dynamic>> json) =>
      ObservableList.of(json.map(Todo.fromJson));

  @override
  List<Map<String, dynamic>> toJson(ObservableList<Todo> object) =>
      object.map((element) => element.toJson()).toList();
}
```

### After (with mobx_json_serializable) 🎉

```dart
@JsonSerializable()
class TodoStore = _TodoStore with _$TodoStore;

abstract class _TodoStore with Store {
  @observable
  ObservableList<Todo> todos = ObservableList<Todo>(); // No converter needed!

  // Standard json_serializable methods work automatically
  factory TodoStore.fromJson(Map<String, dynamic> json) => _$TodoStoreFromJson(json);
  Map<String, dynamic> toJson() => _$TodoStoreToJson(this);
}
```

## Supported Types

| MobX Type | JSON Representation | Example |
|-----------|-------------------|---------|
| `Observable<T>` | Direct value | `"value"` or `42` |
| `ObservableList<T>` | Array | `["item1", "item2"]` |
| `ObservableMap<K,V>` | Object | `{"key": "value"}` |
| `ObservableSet<T>` | Array (unique values) | `["item1", "item2"]` |

## Advanced Usage

### Nested Observables

```dart
abstract class _ComplexStore with Store {
  @observable
  ObservableList<ObservableMap<String, Observable<int>>> nested =
      ObservableList<ObservableMap<String, Observable<int>>>();

  @observable
  Observable<ObservableList<String>?> optionalList = Observable(null);
}
```

### Custom Types

The package works seamlessly with your custom types that have `fromJson`/`toJson` methods:

```dart
abstract class _MyStore with Store {
  @observable
  ObservableList<CustomModel> models = ObservableList<CustomModel>();
}
```

## Migration from Custom Converters

1. Remove custom converter class definitions
2. Remove converter annotations from observable fields
3. Add `mobx_json_serializable` to `dev_dependencies`
4. Update `build.yaml` configuration
5. Run `dart run build_runner clean && dart run build_runner build`

## Troubleshooting

### Build Issues

If you encounter build issues:

1. Clean previous builds: `dart run build_runner clean`
2. Rebuild with conflicts resolution: `dart run build_runner build --delete-conflicting-outputs`
3. Check that `build.yaml` is properly configured

### Type Issues

- Ensure your custom types have proper `fromJson`/`toJson` methods
- For complex generic types, verify type constraints are properly defined
- Check that all dependencies are properly versioned

## Contributing

Contributions are welcome! Please read our [contributing guide](https://github.com/mobxjs/mobx.dart/blob/master/CONTRIBUTING.md) and submit pull requests to the main MobX.dart repository.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Related Packages

- [mobx](https://pub.dev/packages/mobx) - Core MobX reactive state management
- [flutter_mobx](https://pub.dev/packages/flutter_mobx) - Flutter widgets for MobX
- [mobx_codegen](https://pub.dev/packages/mobx_codegen) - Code generation for MobX stores
- [json_serializable](https://pub.dev/packages/json_serializable) - JSON code generation