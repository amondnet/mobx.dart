import 'package:analyzer/dart/element/type.dart';
import 'package:json_serializable/type_helper.dart';

import '../mobx_type_helper.dart';

/// TypeHelper for MobX ObservableMap<K,V> types.
///
/// Handles serialization and deserialization of ObservableMap<K,V> to/from JSON objects.
///
/// Example transformations:
/// - ObservableMap<String, int> -> JSON: converts to regular Map<String, int>
/// - JSON -> ObservableMap<String, int>: creates ObservableMap.of(Map<String, int>)
class ObservableMapTypeHelper extends MobxTypeHelper {
  const ObservableMapTypeHelper();

  @override
  bool canHandle(DartType type) {
    return isMobxObservableType(type, 'ObservableMap');
  }

  @override
  Object? serialize(
    DartType targetType,
    String expression,
    TypeHelperContext context,
  ) {
    if (!canHandle(targetType)) return null;

    final typeArgs = extractTypeArguments(targetType);
    if (typeArgs.isEmpty) {
      // ObservableMap without type parameters - treat as Map<dynamic, dynamic>
      return 'Map<String, dynamic>.from($expression)';
    }

    final keyType = typeArgs.first;
    final valueType = typeArgs.length > 1 ? typeArgs[1] : typeArgs.first;

    // For string keys (most common case in JSON)
    if (_isStringType(keyType)) {
      final valueSerialization = context.serialize(valueType, 'v');
      if (valueSerialization != null) {
        return 'Map<String, dynamic>.from($expression.map((k, v) => MapEntry(k, $valueSerialization)))';
      }
      // Fallback
      final serializedValue = generateListItemSerialization(valueType, 'v', context);
      return 'Map<String, dynamic>.from($expression.map((k, v) => MapEntry(k, $serializedValue)))';
    }

    // For non-string keys, we need to serialize both key and value
    final keySerialization = context.serialize(keyType, 'k');
    final valueSerialization = context.serialize(valueType, 'v');

    if (keySerialization != null && valueSerialization != null) {
      return 'Map<String, dynamic>.from($expression.map((k, v) => MapEntry($keySerialization.toString(), $valueSerialization)))';
    }

    // Fallback for complex key types - convert to string representation
    final serializedKey = generateListItemSerialization(keyType, 'k', context);
    final serializedValue = generateListItemSerialization(valueType, 'v', context);
    return 'Map<String, dynamic>.from($expression.map((k, v) => MapEntry($serializedKey.toString(), $serializedValue)))';
  }

  @override
  Object? deserialize(
    DartType targetType,
    String expression,
    TypeHelperContext context,
    bool defaultProvided,
  ) {
    if (!canHandle(targetType)) return null;

    final typeArgs = extractTypeArguments(targetType);
    if (typeArgs.isEmpty) {
      // ObservableMap without type parameters - treat as Map<dynamic, dynamic>
      return 'ObservableMap.of(${generateNullSafeCast(expression, 'Map<String, dynamic>')})';
    }

    final keyType = typeArgs.first;
    final valueType = typeArgs.length > 1 ? typeArgs[1] : typeArgs.first;

    // For string keys (most common case in JSON)
    if (_isStringType(keyType)) {
      final valueDeserialization = context.deserialize(valueType, 'v');
      if (valueDeserialization != null) {
        return 'ObservableMap.of(Map<String, ${valueType.getDisplayString()}>.from((${generateNullSafeCast(expression, 'Map<String, dynamic>')}).map((k, v) => MapEntry(k, $valueDeserialization))))';
      }
      // Fallback
      final deserializedValue = generateListItemDeserialization(valueType, 'v', context);
      return 'ObservableMap.of(Map<String, ${valueType.getDisplayString()}>.from((${generateNullSafeCast(expression, 'Map<String, dynamic>')}).map((k, v) => MapEntry(k, $deserializedValue))))';
    }

    // For non-string keys, we need to deserialize both key and value
    final keyDeserialization = context.deserialize(keyType, 'k');
    final valueDeserialization = context.deserialize(valueType, 'v');

    if (keyDeserialization != null && valueDeserialization != null) {
      return 'ObservableMap.of(Map<${keyType.getDisplayString()}, ${valueType.getDisplayString()}>.from((${generateNullSafeCast(expression, 'Map<String, dynamic>')}).map((k, v) => MapEntry($keyDeserialization, $valueDeserialization))))';
    }

    // Fallback for complex types
    final deserializedKey = generateListItemDeserialization(keyType, 'k', context);
    final deserializedValue = generateListItemDeserialization(valueType, 'v', context);
    return 'ObservableMap.of(Map<${keyType.getDisplayString()}, ${valueType.getDisplayString()}>.from((${generateNullSafeCast(expression, 'Map<String, dynamic>')}).map((k, v) => MapEntry($deserializedKey, $deserializedValue))))';
  }

  /// Check if a type is String or String?
  bool _isStringType(DartType type) {
    final displayString = type.getDisplayString();
    return displayString == 'String' || displayString == 'String?';
  }
}