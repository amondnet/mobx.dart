import 'dart:convert';
import 'package:test/test.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_json_serializable/src/converters/observable_converters.dart';
import 'package:mobx_json_serializable/src/converters/nested_observable_converters.dart';

void main() {
  group('Observable JsonConverters', () {
    group('ObservableConverter', () {
      const converter = ObservableConverter<String>();

      test('should serialize Observable<T> to T', () {
        final observable = Observable<String>('test value');
        final result = converter.toJson(observable);
        expect(result, equals('test value'));
      });

      test('should deserialize T to Observable<T>', () {
        const value = 'test value';
        final result = converter.fromJson(value);
        expect(result, isA<Observable<String>>());
        expect(result.value, equals('test value'));
      });

      test('should handle null values', () {
        const converter = ObservableConverter<String?>();
        final observable = Observable<String?>(null);

        final serialized = converter.toJson(observable);
        expect(serialized, isNull);

        final deserialized = converter.fromJson(null);
        expect(deserialized.value, isNull);
      });
    });

    group('ObservableListConverter', () {
      const converter = ObservableListConverter<String>();

      test('should serialize ObservableList<T> to List<T>', () {
        final observableList = ObservableList<String>.of(['a', 'b', 'c']);
        final result = converter.toJson(observableList);
        expect(result, equals(['a', 'b', 'c']));
        expect(result, isA<List<String>>());
      });

      test('should deserialize List<T> to ObservableList<T>', () {
        const list = ['a', 'b', 'c'];
        final result = converter.fromJson(list);
        expect(result, isA<ObservableList<String>>());
        expect(result.toList(), equals(['a', 'b', 'c']));
      });

      test('should handle null/empty lists', () {
        final emptyResult = converter.fromJson(null);
        expect(emptyResult, isA<ObservableList<String>>());
        expect(emptyResult.isEmpty, isTrue);

        final emptyList = converter.fromJson([]);
        expect(emptyList.isEmpty, isTrue);
      });

      test('should maintain reactivity after deserialization', () {
        const list = ['a', 'b'];
        final result = converter.fromJson(list);

        // Test that it's truly reactive
        result.add('c');
        expect(result.length, equals(3));
        expect(result[2], equals('c'));
      });
    });

    group('ObservableMapConverter', () {
      const converter = ObservableMapConverter<String, int>();

      test('should serialize ObservableMap<K,V> to Map<K,V>', () {
        final observableMap = ObservableMap<String, int>.of({
          'clicks': 5,
          'views': 100,
        });
        final result = converter.toJson(observableMap);
        expect(result, equals({'clicks': 5, 'views': 100}));
        expect(result, isA<Map<String, int>>());
      });

      test('should deserialize Map<K,V> to ObservableMap<K,V>', () {
        const map = {'clicks': 5, 'views': 100};
        final result = converter.fromJson(map);
        expect(result, isA<ObservableMap<String, int>>());
        expect(result['clicks'], equals(5));
        expect(result['views'], equals(100));
      });

      test('should handle null/empty maps', () {
        final emptyResult = converter.fromJson(null);
        expect(emptyResult, isA<ObservableMap<String, int>>());
        expect(emptyResult.isEmpty, isTrue);

        final emptyMap = converter.fromJson({});
        expect(emptyMap.isEmpty, isTrue);
      });
    });

    group('ObservableSetConverter', () {
      const converter = ObservableSetConverter<String>();

      test('should serialize ObservableSet<T> to List<T>', () {
        final observableSet = ObservableSet<String>.of(['a', 'b', 'c']);
        final result = converter.toJson(observableSet);
        expect(result, isA<List<String>>());
        expect(result.length, equals(3));
        expect(result, containsAll(['a', 'b', 'c']));
      });

      test('should deserialize List<T> to ObservableSet<T>', () {
        const list = ['a', 'b', 'c', 'a']; // Duplicate 'a' should be filtered
        final result = converter.fromJson(list);
        expect(result, isA<ObservableSet<String>>());
        expect(result.length, equals(3)); // Duplicates removed
        expect(result.contains('a'), isTrue);
        expect(result.contains('b'), isTrue);
        expect(result.contains('c'), isTrue);
      });

      test('should handle null/empty lists', () {
        final emptyResult = converter.fromJson(null);
        expect(emptyResult, isA<ObservableSet<String>>());
        expect(emptyResult.isEmpty, isTrue);
      });
    });
  });

  group('Nested Observable Converters', () {
    group('ObservableMapOfObservablesConverter', () {
      const converter = ObservableMapOfObservablesConverter<String, int>();

      test('should serialize nested structure', () {
        final nestedMap = ObservableMap<String, Observable<int>>();
        nestedMap['counter1'] = Observable<int>(5);
        nestedMap['counter2'] = Observable<int>(10);

        final result = converter.toJson(nestedMap);
        expect(result, equals({'counter1': 5, 'counter2': 10}));
      });

      test('should deserialize nested structure', () {
        const data = {'counter1': 5, 'counter2': 10};
        final result = converter.fromJson(data);

        expect(result, isA<ObservableMap<String, Observable<int>>>());
        expect(result['counter1']?.value, equals(5));
        expect(result['counter2']?.value, equals(10));
      });
    });

    group('ObservableOfListConverter', () {
      const converter = ObservableOfListConverter<String>();

      test('should serialize Observable<ObservableList<T>>', () {
        final observableList = ObservableList<String>.of(['a', 'b', 'c']);
        final observableOfList = Observable<ObservableList<String>?>(observableList);

        final result = converter.toJson(observableOfList);
        expect(result, equals(['a', 'b', 'c']));
      });

      test('should deserialize to Observable<ObservableList<T>>', () {
        const list = ['a', 'b', 'c'];
        final result = converter.fromJson(list);

        expect(result, isA<Observable<ObservableList<String>?>>());
        expect(result.value, isA<ObservableList<String>>());
        expect(result.value!.toList(), equals(['a', 'b', 'c']));
      });

      test('should handle null values', () {
        final observableOfNull = Observable<ObservableList<String>?>(null);
        final serialized = converter.toJson(observableOfNull);
        expect(serialized, isNull);

        final deserialized = converter.fromJson(null);
        expect(deserialized.value, isNull);
      });
    });
  });

  group('JSON Integration', () {
    test('should work with jsonEncode/jsonDecode', () {
      // Test that our converters work with standard JSON serialization
      const converter = ObservableListConverter<String>();
      final observableList = ObservableList<String>.of(['hello', 'world']);

      // Serialize to JSON
      final jsonList = converter.toJson(observableList);
      final jsonString = jsonEncode(jsonList);
      expect(jsonString, equals('["hello","world"]'));

      // Deserialize from JSON
      final decodedList = jsonDecode(jsonString) as List<dynamic>;
      final typedList = decodedList.cast<String>();
      final restoredObservableList = converter.fromJson(typedList);

      expect(restoredObservableList, isA<ObservableList<String>>());
      expect(restoredObservableList.toList(), equals(['hello', 'world']));
    });

    test('should handle complex nested JSON structures', () {
      // Test nested converter with real JSON
      const converter = ObservableMapOfObservablesConverter<String, int>();

      // Create nested structure
      final nestedMap = ObservableMap<String, Observable<int>>();
      nestedMap['clicks'] = Observable<int>(42);
      nestedMap['views'] = Observable<int>(100);

      // Serialize to JSON string
      final jsonMap = converter.toJson(nestedMap);
      final jsonString = jsonEncode(jsonMap);
      expect(jsonString, contains('42'));
      expect(jsonString, contains('100'));

      // Deserialize from JSON string
      final decodedMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final typedMap = decodedMap.cast<String, int>();
      final restored = converter.fromJson(typedMap);

      expect(restored['clicks']?.value, equals(42));
      expect(restored['views']?.value, equals(100));
    });
  });

  group('Type Safety', () {
    test('should maintain type safety for different generic types', () {
      const stringConverter = ObservableConverter<String>();
      const intConverter = ObservableConverter<int>();

      final stringObs = stringConverter.fromJson('hello');
      final intObs = intConverter.fromJson(42);

      expect(stringObs.value, isA<String>());
      expect(intObs.value, isA<int>());
      expect(stringObs.value, equals('hello'));
      expect(intObs.value, equals(42));
    });

    test('should work with MobxConverters convenience constants', () {
      final stringObs = MobxConverters.observableString.fromJson('test');
      final intObs = MobxConverters.observableInt.fromJson(123);
      final stringList = MobxConverters.observableStringList.fromJson(['a', 'b']);

      expect(stringObs.value, equals('test'));
      expect(intObs.value, equals(123));
      expect(stringList.toList(), equals(['a', 'b']));
    });
  });
}