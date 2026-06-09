import 'package:mobx/mobx.dart';
import 'package:json_annotation/json_annotation.dart';

import 'observable_converters.dart';

/// JsonConverter for ObservableList<ObservableMap<K,V>> nested types.
///
/// Handles complex nested structures like lists of observable maps.
class ObservableListOfMapsConverter<K, V>
    implements JsonConverter<ObservableList<ObservableMap<K, V>>, List<Map<K, V>>?> {
  const ObservableListOfMapsConverter();

  @override
  ObservableList<ObservableMap<K, V>> fromJson(List<Map<K, V>>? json) {
    if (json == null) return ObservableList<ObservableMap<K, V>>();
    return ObservableList<ObservableMap<K, V>>.of(
      json.map((map) => ObservableMap<K, V>.of(map))
    );
  }

  @override
  List<Map<K, V>> toJson(ObservableList<ObservableMap<K, V>> object) {
    return object.map((observableMap) => Map<K, V>.from(observableMap)).toList();
  }
}

/// JsonConverter for ObservableMap<K, ObservableList<V>> nested types.
///
/// Handles maps where values are observable lists.
class ObservableMapOfListsConverter<K, V>
    implements JsonConverter<ObservableMap<K, ObservableList<V>>, Map<K, List<V>>?> {
  const ObservableMapOfListsConverter();

  @override
  ObservableMap<K, ObservableList<V>> fromJson(Map<K, List<V>>? json) {
    if (json == null) return ObservableMap<K, ObservableList<V>>();
    final result = ObservableMap<K, ObservableList<V>>();
    json.forEach((key, list) {
      result[key] = ObservableList<V>.of(list);
    });
    return result;
  }

  @override
  Map<K, List<V>> toJson(ObservableMap<K, ObservableList<V>> object) {
    final result = <K, List<V>>{};
    object.forEach((key, observableList) {
      result[key] = observableList.toList();
    });
    return result;
  }
}

/// JsonConverter for Observable<ObservableList<T>> nested types.
///
/// Handles cases where an Observable contains an ObservableList.
class ObservableOfListConverter<T>
    implements JsonConverter<Observable<ObservableList<T>?>, List<T>?> {
  const ObservableOfListConverter();

  @override
  Observable<ObservableList<T>?> fromJson(List<T>? json) {
    return Observable<ObservableList<T>?>(
      json != null ? ObservableList<T>.of(json) : null
    );
  }

  @override
  List<T>? toJson(Observable<ObservableList<T>?> object) {
    return object.value?.toList();
  }
}

/// JsonConverter for ObservableMap<K, Observable<V>> nested types.
///
/// Handles maps where values are observables.
class ObservableMapOfObservablesConverter<K, V>
    implements JsonConverter<ObservableMap<K, Observable<V>>, Map<K, V>?> {
  const ObservableMapOfObservablesConverter();

  @override
  ObservableMap<K, Observable<V>> fromJson(Map<K, V>? json) {
    if (json == null) return ObservableMap<K, Observable<V>>();
    final result = ObservableMap<K, Observable<V>>();
    json.forEach((key, value) {
      result[key] = Observable<V>(value);
    });
    return result;
  }

  @override
  Map<K, V> toJson(ObservableMap<K, Observable<V>> object) {
    final result = <K, V>{};
    object.forEach((key, observable) {
      result[key] = observable.value;
    });
    return result;
  }
}

/// Generic converter factory for creating type-specific converters.
///
/// This class provides factory methods for creating converters with specific types
/// to avoid generic type issues in annotations.
class MobxConverters {
  /// Creates an ObservableConverter for String types.
  static const observableString = ObservableConverter<String>();

  /// Creates an ObservableConverter for int types.
  static const observableInt = ObservableConverter<int>();

  /// Creates an ObservableConverter for bool types.
  static const observableBool = ObservableConverter<bool>();

  /// Creates an ObservableListConverter for String types.
  static const observableStringList = ObservableListConverter<String>();

  /// Creates an ObservableListConverter for int types.
  static const observableIntList = ObservableListConverter<int>();

  /// Creates an ObservableMapConverter for String keys and int values.
  static const observableStringIntMap = ObservableMapConverter<String, int>();

  /// Creates an ObservableSetConverter for String types.
  static const observableStringSet = ObservableSetConverter<String>();
}