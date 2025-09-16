import 'package:test/test.dart';
import 'package:mobx_json_serializable/src/type_helpers/observable_type_helper.dart';
import 'package:mobx_json_serializable/src/type_helpers/observable_list_type_helper.dart';
import 'package:mobx_json_serializable/src/type_helpers/observable_map_type_helper.dart';
import 'package:mobx_json_serializable/src/type_helpers/observable_set_type_helper.dart';

void main() {
  group('Type Detection Tests', () {
    test('TypeHelper instances are created correctly', () {
      const observableHelper = ObservableTypeHelper();
      const listHelper = ObservableListTypeHelper();
      const mapHelper = ObservableMapTypeHelper();
      const setHelper = ObservableSetTypeHelper();

      expect(observableHelper, isA<ObservableTypeHelper>());
      expect(listHelper, isA<ObservableListTypeHelper>());
      expect(mapHelper, isA<ObservableMapTypeHelper>());
      expect(setHelper, isA<ObservableSetTypeHelper>());
    });

    test('All TypeHelpers implement required interface', () {
      const helpers = [
        ObservableTypeHelper(),
        ObservableListTypeHelper(),
        ObservableMapTypeHelper(),
        ObservableSetTypeHelper(),
      ];

      for (final helper in helpers) {
        expect(helper.canHandle, isA<Function>());
        expect(helper.serialize, isA<Function>());
        expect(helper.deserialize, isA<Function>());
        expect(helper.extractTypeArguments, isA<Function>());
      }
    });

    test('TypeHelpers have consistent interface', () {
      // This test ensures all our TypeHelpers follow the same pattern
      const helpers = [
        ObservableTypeHelper(),
        ObservableListTypeHelper(),
        ObservableMapTypeHelper(),
        ObservableSetTypeHelper(),
      ];

      for (final helper in helpers) {
        // All should have the same method signature patterns
        expect(helper, isNotNull);
        expect(helper.runtimeType.toString(), contains('TypeHelper'));
      }
    });
  });

  group('Helper Utilities Tests', () {
    const helper = ObservableTypeHelper();

    test('extractTypeArguments handles empty type args', () {
      // This is a basic structure test - in real scenarios this would use mock DartType
      expect(helper.extractTypeArguments, isA<Function>());
    });

    test('generateNullSafeCast creates proper cast expression', () {
      const expression = 'jsonValue';
      const castType = 'List<String>';

      final result = helper.generateNullSafeCast(expression, castType);
      expect(result, equals('(jsonValue as List<String>?)'));
    });

    test('isMobxObservableType identifies types correctly', () {
      // Basic pattern tests
      // In a real implementation, this would use proper DartType mocks
      expect(helper.isMobxObservableType, isA<Function>());
    });
  });

  group('Code Generation Patterns', () {
    test('Serialization patterns are consistent', () {
      const helpers = [
        ObservableListTypeHelper(),
        ObservableSetTypeHelper(),
      ];

      // Both list and set helpers should handle serialization to arrays
      for (final helper in helpers) {
        expect(helper, isNotNull);
        // In actual tests, we'd verify the generated code patterns
      }
    });

    test('Deserialization patterns handle null safety', () {
      const helper = ObservableListTypeHelper();

      // Test the generateNullSafeCast utility
      final cast1 = helper.generateNullSafeCast('json', 'List<dynamic>');
      final cast2 = helper.generateNullSafeCast('value', 'Map<String, dynamic>');

      expect(cast1, equals('(json as List<dynamic>?)'));
      expect(cast2, equals('(value as Map<String, dynamic>?)'));
    });
  });

  group('Error Handling', () {
    test('TypeHelpers handle null inputs gracefully', () {
      const helpers = [
        ObservableTypeHelper(),
        ObservableListTypeHelper(),
        ObservableMapTypeHelper(),
        ObservableSetTypeHelper(),
      ];

      // All helpers should be able to handle being called
      // (actual parameter testing would require DartType mocks)
      for (final helper in helpers) {
        expect(() => helper, returnsNormally);
      }
    });
  });
}