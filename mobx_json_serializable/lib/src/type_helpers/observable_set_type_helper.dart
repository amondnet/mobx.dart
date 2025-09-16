import 'package:analyzer/dart/element/type.dart';
import 'package:json_serializable/type_helper.dart';

import '../mobx_type_helper.dart';

/// TypeHelper for MobX ObservableSet<T> types.
///
/// Handles serialization and deserialization of ObservableSet<T> to/from JSON arrays.
///
/// Example transformations:
/// - ObservableSet<String> -> JSON: converts to List<String> (JSON arrays)
/// - JSON -> ObservableSet<String>: creates ObservableSet.of(List<String>)
class ObservableSetTypeHelper extends MobxTypeHelper {
  const ObservableSetTypeHelper();

  @override
  bool canHandle(DartType type) {
    return isMobxObservableType(type, 'ObservableSet');
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
      // ObservableSet without type parameter - treat as Set<dynamic>
      return '$expression.toList()';
    }

    final itemType = typeArgs.first;
    final itemSerialization = context.serialize(itemType, 'e');

    if (itemSerialization != null && itemSerialization.toString() != 'e') {
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
      // ObservableSet without type parameter - treat as Set<dynamic>
      return 'ObservableSet.of(${generateNullSafeCast(expression, 'List<dynamic>', fallback: '<dynamic>[]')})';
    }

    final itemType = typeArgs.first;
    final itemDeserialization = context.deserialize(itemType, 'e');

    if (itemDeserialization != null) {
      return 'ObservableSet.of((${generateNullSafeCast(expression, 'List<dynamic>', fallback: '<dynamic>[]')}).map((e) => $itemDeserialization))';
    }

    // Fallback: use helper method for item deserialization
    final deserializedItem = generateListItemDeserialization(itemType, 'e', context);
    return 'ObservableSet.of((${generateNullSafeCast(expression, 'List<dynamic>', fallback: '<dynamic>[]')}).map((e) => $deserializedItem))';
  }
}