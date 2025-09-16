import 'package:mobx/mobx.dart';
import 'package:json_annotation/json_annotation.dart';

/// JsonConverter for Observable<T> types.
///
/// Usage:
/// ```dart
/// @JsonSerializable()
/// class MyStore {
///   @ObservableConverter()
///   final Observable<String?> currentValue;
/// }
/// ```
class ObservableConverter<T> implements JsonConverter<Observable<T>, T?> {
  const ObservableConverter();

  @override
  Observable<T> fromJson(T? json) => Observable<T>(json as T);

  @override
  T? toJson(Observable<T> object) => object.value;
}

/// JsonConverter for ObservableList<T> types.
///
/// Usage:
/// ```dart
/// @JsonSerializable()
/// class MyStore {
///   @ObservableListConverter()
///   final ObservableList<String> items;
/// }
/// ```
class ObservableListConverter<T> implements JsonConverter<ObservableList<T>, List<T>?> {
  const ObservableListConverter();

  @override
  ObservableList<T> fromJson(List<T>? json) => ObservableList<T>.of(json ?? <T>[]);

  @override
  List<T> toJson(ObservableList<T> object) => object.toList();
}

/// JsonConverter for ObservableMap<K,V> types.
///
/// Usage:
/// ```dart
/// @JsonSerializable()
/// class MyStore {
///   @ObservableMapConverter()
///   final ObservableMap<String, int> counters;
/// }
/// ```
class ObservableMapConverter<K, V> implements JsonConverter<ObservableMap<K, V>, Map<K, V>?> {
  const ObservableMapConverter();

  @override
  ObservableMap<K, V> fromJson(Map<K, V>? json) => ObservableMap<K, V>.of(json ?? <K, V>{});

  @override
  Map<K, V> toJson(ObservableMap<K, V> object) => Map<K, V>.from(object);
}

/// JsonConverter for ObservableSet<T> types.
/// Note: JSON doesn't have native Set support, so this serializes as a List.
///
/// Usage:
/// ```dart
/// @JsonSerializable()
/// class MyStore {
///   @ObservableSetConverter()
///   final ObservableSet<String> tags;
/// }
/// ```
class ObservableSetConverter<T> implements JsonConverter<ObservableSet<T>, List<T>?> {
  const ObservableSetConverter();

  @override
  ObservableSet<T> fromJson(List<T>? json) => ObservableSet<T>.of(json ?? <T>[]);

  @override
  List<T> toJson(ObservableSet<T> object) => object.toList();
}

/// Convenience converter for nullable Observable<T> types.
class NullableObservableConverter<T> implements JsonConverter<Observable<T?>, T?> {
  const NullableObservableConverter();

  @override
  Observable<T?> fromJson(T? json) => Observable<T?>(json);

  @override
  T? toJson(Observable<T?> object) => object.value;
}