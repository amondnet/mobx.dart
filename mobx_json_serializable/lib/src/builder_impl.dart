import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:json_serializable/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'type_helpers/observable_type_helper.dart';
import 'type_helpers/observable_list_type_helper.dart';
import 'type_helpers/observable_map_type_helper.dart';
import 'type_helpers/observable_set_type_helper.dart';

/// Creates a json_serializable builder with MobX type helpers registered.
///
/// This builder extends json_serializable with support for MobX observable types.
Builder jsonSerializable(BuilderOptions options) {
  try {
    final config = JsonSerializable.fromJson(options.config);

    return SharedPartBuilder([
      JsonSerializableGenerator.withDefaultHelpers(
        [
          const ObservableTypeHelper(),
          const ObservableListTypeHelper(),
          const ObservableMapTypeHelper(),
          const ObservableSetTypeHelper(),
        ],
        config: config,
      ),
    ], 'json_serializable');
  } on CheckedFromJsonException catch (e) {
    final name = e.map.keys
        .where((k) => !const {
              'any_map',
              'checked',
              'constructor',
              'create_factory',
              'create_field_map',
              'create_json_keys',
              'create_per_field_to_json',
              'create_to_json',
              'disallow_unrecognized_keys',
              'explicit_to_json',
              'field_rename',
              'generic_argument_factories',
              'ignore_unannotated',
              'include_if_null'
            }.contains(k))
        .join(', ');
    throw StateError('Could not parse the options provided for '
        '`json_serializable`.\n'
        'Unrecognized keys: [$name]; supported keys: [any_map, checked, '
        'constructor, create_factory, create_field_map, create_json_keys, '
        'create_per_field_to_json, create_to_json, disallow_unrecognized_keys, '
        'explicit_to_json, field_rename, generic_argument_factories, '
        'ignore_unannotated, include_if_null]');
  }
}