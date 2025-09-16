import 'dart:convert';
import 'package:test/test.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_json_serializable/src/converters/observable_converters.dart';

void main() {
  group('MobX JSON Serializable Integration Tests', () {
    group('Converter Integration Tests', () {
      test('ObservableConverter works with JSON encoding/decoding', () {
        const converter = ObservableConverter<String>();

        // Create test data
        final originalValue = Observable<String>('test data');

        // Serialize
        final serialized = converter.toJson(originalValue);
        expect(serialized, equals('test data'));

        // Deserialize
        final deserialized = converter.fromJson(serialized);
        expect(deserialized, isA<Observable<String>>());
        expect(deserialized.value, equals('test data'));
      });

      test('ObservableListConverter works with JSON encoding/decoding', () {
        const converter = ObservableListConverter<String>();

        // Create test data
        final originalList = ObservableList<String>.of(['item1', 'item2', 'item3']);

        // Serialize
        final serialized = converter.toJson(originalList);
        expect(serialized, equals(['item1', 'item2', 'item3']));

        // Deserialize
        final deserialized = converter.fromJson(serialized);
        expect(deserialized, isA<ObservableList<String>>());
        expect(deserialized.toList(), equals(['item1', 'item2', 'item3']));
      });

      test('ObservableMapConverter works with JSON encoding/decoding', () {
        const converter = ObservableMapConverter<String, int>();

        // Create test data
        final originalMap = ObservableMap<String, int>.of({'key1': 1, 'key2': 2});

        // Serialize
        final serialized = converter.toJson(originalMap);
        expect(serialized, equals({'key1': 1, 'key2': 2}));

        // Deserialize
        final deserialized = converter.fromJson(serialized);
        expect(deserialized, isA<ObservableMap<String, int>>());
        expect(Map<String, int>.from(deserialized), equals({'key1': 1, 'key2': 2}));
      });

      test('ObservableSetConverter works with JSON encoding/decoding', () {
        const converter = ObservableSetConverter<String>();

        // Create test data
        final originalSet = ObservableSet<String>.of(['item1', 'item2', 'item3']);

        // Serialize (sets become lists in JSON)
        final serialized = converter.toJson(originalSet);
        expect(serialized, isA<List<String>>());
        expect(serialized.length, equals(3));
        expect(serialized.contains('item1'), isTrue);
        expect(serialized.contains('item2'), isTrue);
        expect(serialized.contains('item3'), isTrue);

        // Deserialize
        final deserialized = converter.fromJson(serialized);
        expect(deserialized, isA<ObservableSet<String>>());
        expect(deserialized.length, equals(3));
        expect(deserialized.contains('item1'), isTrue);
        expect(deserialized.contains('item2'), isTrue);
        expect(deserialized.contains('item3'), isTrue);
      });
    });

    group('Complex Serialization Scenarios', () {
      test('Handles null values correctly', () {
        const converter = ObservableConverter<String?>();

        // Test null observable
        final nullObs = Observable<String?>(null);
        final serialized = converter.toJson(nullObs);
        expect(serialized, isNull);

        final deserialized = converter.fromJson(null);
        expect(deserialized.value, isNull);
      });

      test('Handles empty collections correctly', () {
        const listConverter = ObservableListConverter<String>();
        const mapConverter = ObservableMapConverter<String, int>();
        const setConverter = ObservableSetConverter<String>();

        // Empty list
        final emptyList = ObservableList<String>();
        expect(listConverter.toJson(emptyList), equals([]));
        expect(listConverter.fromJson([]).isEmpty, isTrue);

        // Empty map
        final emptyMap = ObservableMap<String, int>();
        expect(mapConverter.toJson(emptyMap), equals({}));
        expect(mapConverter.fromJson({}).isEmpty, isTrue);

        // Empty set
        final emptySet = ObservableSet<String>();
        expect(setConverter.toJson(emptySet), equals([]));
        expect(setConverter.fromJson([]).isEmpty, isTrue);
      });

      test('Full JSON roundtrip with jsonEncode/jsonDecode', () {
        const converter = ObservableListConverter<String>();

        final original = ObservableList<String>.of(['a', 'b', 'c']);
        final serialized = converter.toJson(original);

        // Convert to JSON string and back
        final jsonString = jsonEncode(serialized);
        final decoded = jsonDecode(jsonString) as List<dynamic>;
        final typedDecoded = decoded.cast<String>();

        final deserialized = converter.fromJson(typedDecoded);
        expect(deserialized.toList(), equals(['a', 'b', 'c']));
      });
    });
  });
}