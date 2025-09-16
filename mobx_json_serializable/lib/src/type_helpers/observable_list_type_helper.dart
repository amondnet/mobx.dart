import 'package:analyzer/dart/element/type.dart';
import 'package:json_serializable/type_helper.dart';

import '../mobx_type_helper.dart';

/// TypeHelper for MobX ObservableList<T> types.
///
/// Handles serialization and deserialization of ObservableList<T> to/from JSON arrays.
///
/// Example transformations:
/// - ObservableList<String> -> JSON: converts to regular List<String>
/// - JSON -> ObservableList<String>: creates ObservableList.of(List<String>)
class ObservableListTypeHelper extends MobxTypeHelper {
  const ObservableListTypeHelper();

  @override
  bool canHandle(DartType type) {
    return isMobxObservableType(type, 'ObservableList');
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
      // ObservableList without type parameter - treat as List<dynamic>
      return '$expression.toList()';
    }

    final itemType = typeArgs.first;
    final itemSerialization = context.serialize(itemType, 'e');

    if (itemSerialization != null) {
      return '$expression.map((e) => $itemSerialization).toList()';
    }

    // Fallback: use helper method for item serialization
    return '$expression.map((e) => ${generateListItemSerialization(itemType, 'e', context)}).toList()';
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
      // ObservableList without type parameter - treat as List<dynamic>
      return 'ObservableList.of(${generateNullSafeCast(expression, 'List<dynamic>')})';
    }

    final itemType = typeArgs.first;
    final itemDeserialization = context.deserialize(itemType, 'e');

    if (itemDeserialization != null) {
      return 'ObservableList.of((${generateNullSafeCast(expression, 'List<dynamic>')}).map((e) => $itemDeserialization))';
    }

    // Fallback: use helper method for item deserialization
    final deserializedItem = generateListItemDeserialization(itemType, 'e', context);
    return 'ObservableList.of((${generateNullSafeCast(expression, 'List<dynamic>')}).map((e) => $deserializedItem))';
  }
}