import 'package:analyzer/dart/element/type.dart';
import 'package:json_serializable/type_helper.dart';

/// Base class for all MobX TypeHelper implementations.
///
/// Provides common functionality for handling MobX observable types
/// in json_serializable code generation.
abstract class MobxTypeHelper extends TypeHelper {
  const MobxTypeHelper();

  /// Check if this helper can handle the given type
  bool canHandle(DartType type);

  /// Extract generic type arguments from MobX observable types
  List<DartType> extractTypeArguments(DartType type) {
    if (type is ParameterizedType) {
      return type.typeArguments;
    }
    return <DartType>[];
  }

  /// Check if a type is a MobX observable type by checking its name
  bool isMobxObservableType(DartType type, String typeName) {
    final displayString = type.getDisplayString();
    return displayString == typeName || displayString.startsWith('$typeName<');
  }

  /// Generate null-safe casting code with fallback
  String generateNullSafeCast(String expression, String castType, {String? fallback}) {
    if (fallback != null) {
      return '($expression as $castType?) ?? $fallback';
    }
    return '($expression as $castType?)';
  }

  /// Generate list item serialization code
  String generateListItemSerialization(
    DartType itemType,
    String itemExpression,
    TypeHelperContext context,
  ) {
    final itemSerialization = context.serialize(itemType, itemExpression);
    if (itemSerialization != null && itemSerialization.toString() != itemExpression) {
      return itemSerialization.toString();
    }
    // Fallback to toJson() method or direct value
    if (_hasToJsonMethod(itemType)) {
      return '$itemExpression.toJson()';
    }
    return itemExpression;
  }

  /// Generate list item deserialization code
  String generateListItemDeserialization(
    DartType itemType,
    String itemExpression,
    TypeHelperContext context,
  ) {
    final itemDeserialization = context.deserialize(itemType, itemExpression);
    if (itemDeserialization != null) {
      return itemDeserialization.toString();
    }
    // Fallback to fromJson() factory or direct value
    if (_hasFromJsonFactory(itemType)) {
      final typeName = itemType.getDisplayString();
      return '$typeName.fromJson($itemExpression as Map<String, dynamic>)';
    }
    return '$itemExpression as ${itemType.getDisplayString()}';
  }

  /// Check if a type has a toJson() method
  bool _hasToJsonMethod(DartType type) {
    final typeString = type.getDisplayString();

    // Primitive types that don't have toJson methods
    if (typeString == 'String' || typeString == 'String?' ||
        typeString == 'int' || typeString == 'int?' ||
        typeString == 'double' || typeString == 'double?' ||
        typeString == 'num' || typeString == 'num?' ||
        typeString == 'bool' || typeString == 'bool?' ||
        typeString == 'DateTime' || typeString == 'DateTime?' ||
        typeString == 'dynamic') {
      return false;
    }

    // For all other types, assume they have toJson methods
    // This includes custom classes like SimpleModel
    return true;
  }

  /// Check if a type has a fromJson() factory constructor
  bool _hasFromJsonFactory(DartType type) {
    // Simplified version - assume common types have fromJson() factories
    // This can be improved later with proper analyzer API usage
    return true; // Conservative approach - let the generated code handle the error
  }
}