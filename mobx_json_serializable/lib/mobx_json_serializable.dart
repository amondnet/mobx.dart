/// JSON serialization support for MobX observable types.
///
/// This library provides multiple approaches for serializing MobX observable types
/// with json_serializable:
///
/// 1. **JsonConverter approach (Recommended)**: Use provided converters with annotations
/// 2. **TypeHelper approach (Advanced)**: Automatic detection with custom builder
///
/// ## Features
///
/// - JsonConverters for `Observable<T>`, `ObservableList<T>`, `ObservableMap<K,V>`, `ObservableSet<T>`
/// - Support for complex nested observable structures
/// - Seamless integration with existing json_serializable workflow
/// - Type-safe serialization with proper null handling
///
/// ## Quick Start (JsonConverter approach)
///
/// ```dart
/// import 'package:mobx_json_serializable/mobx_json_serializable.dart';
///
/// @JsonSerializable()
/// class TodoStore {
///   @ObservableListConverter()
///   final ObservableList<String> todos = ObservableList<String>();
///
///   @ObservableMapConverter()
///   final ObservableMap<String, int> counters = ObservableMap<String, int>();
///
///   @ObservableConverter()
///   final Observable<String?> filter = Observable(null);
///
///   TodoStore();
///
///   factory TodoStore.fromJson(Map<String, dynamic> json) => _$TodoStoreFromJson(json);
///   Map<String, dynamic> toJson() => _$TodoStoreToJson(this);
/// }
/// ```
///
/// ## Advanced Usage (TypeHelper approach)
///
/// For automatic detection without annotations, see the README for builder configuration.
library mobx_json_serializable;

// Re-export commonly used json_annotation classes for convenience
export 'package:json_annotation/json_annotation.dart';

// Export JsonConverters (Primary approach)
export 'src/converters/observable_converters.dart';
export 'src/converters/nested_observable_converters.dart';

// Export TypeHelpers for advanced use cases
export 'src/type_helpers.dart';
export 'src/mobx_type_helper.dart';