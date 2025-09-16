import 'package:analyzer/dart/element/type.dart';
import 'package:json_serializable/type_helper.dart';

import '../mobx_type_helper.dart';

/// TypeHelper for MobX Observable<T> types.
///
/// Handles serialization and deserialization of Observable<T> to/from JSON.
///
/// Example transformations:
/// - Observable<String> -> JSON: calls value property
/// - JSON -> Observable<String>: creates new Observable with value
class ObservableTypeHelper extends MobxTypeHelper {
  const ObservableTypeHelper();

  @override
  bool canHandle(DartType type) {
    return isMobxObservableType(type, 'Observable');
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
      // Observable without type parameter - treat as dynamic
      return '$expression.value';
    }

    final valueType = typeArgs.first;
    final valueSerialization = context.serialize(valueType, '$expression.value');

    if (valueSerialization != null) {
      return valueSerialization;
    }

    // Fallback: try toJson() method or direct value access
    return generateListItemSerialization(valueType, '$expression.value', context);
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
      // Observable without type parameter - treat as dynamic
      return 'Observable($expression)';
    }

    final valueType = typeArgs.first;
    final valueDeserialization = context.deserialize(valueType, expression);

    if (valueDeserialization != null) {
      return 'Observable($valueDeserialization)';
    }

    // Fallback: try fromJson() factory or direct cast
    final deserializedValue = generateListItemDeserialization(valueType, expression, context);
    return 'Observable($deserializedValue)';
  }
}