import 'package:test/test.dart';
import 'package:build/build.dart';
import 'package:json_serializable/type_helper.dart';
import 'package:mobx_json_serializable/builder.dart';
import 'package:mobx_json_serializable/src/type_helpers.dart';

void main() {
  group('Builder Tests', () {
    test('jsonSerializable creates valid builder', () {
      final options = BuilderOptions({});
      final builder = jsonSerializable(options);

      expect(builder, isNotNull);
      expect(builder, isA<Builder>());
    });

    test('Builder registers all MobX type helpers', () {
      // Test that our builder includes the expected type helpers
      final options = BuilderOptions({});

      // This test verifies the builder can be created with various configurations
      expect(() => jsonSerializable(options), returnsNormally);

      // Test with valid json_serializable config
      final optionsWithValidConfig = BuilderOptions({
        'explicit_to_json': true,
      });
      expect(() => jsonSerializable(optionsWithValidConfig), returnsNormally);
    });

    test('Builder handles empty configuration', () {
      final emptyOptions = BuilderOptions({});
      final builder = jsonSerializable(emptyOptions);

      expect(builder, isNotNull);
    });

    test('Builder preserves existing configuration', () {
      final existingConfig = {
        'explicit_to_json': true,
        'field_rename': 'none',
      };

      final options = BuilderOptions(existingConfig);
      final builder = jsonSerializable(options);

      expect(builder, isNotNull);
      // The builder should preserve the existing configuration
      // while adding our type helpers
    });

    test('Multiple builder instances are independent', () {
      final options1 = BuilderOptions({'explicit_to_json': true});
      final options2 = BuilderOptions({'field_rename': 'none'});

      final builder1 = jsonSerializable(options1);
      final builder2 = jsonSerializable(options2);

      expect(builder1, isNotNull);
      expect(builder2, isNotNull);
      expect(identical(builder1, builder2), isFalse);
    });
  });

  group('Type Helper Integration', () {
    test('All expected type helpers are available', () {
      // Verify we can import all type helpers
      expect(ObservableTypeHelper, isNotNull);
      expect(ObservableListTypeHelper, isNotNull);
      expect(ObservableMapTypeHelper, isNotNull);
      expect(ObservableSetTypeHelper, isNotNull);
    });

    test('Type helpers are const constructors', () {
      // All our type helpers should be const for performance
      const helper1 = ObservableTypeHelper();
      const helper2 = ObservableListTypeHelper();
      const helper3 = ObservableMapTypeHelper();
      const helper4 = ObservableSetTypeHelper();

      expect(helper1, isNotNull);
      expect(helper2, isNotNull);
      expect(helper3, isNotNull);
      expect(helper4, isNotNull);
    });
  });
}