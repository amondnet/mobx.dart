# CHANGELOG

## 1.0.0

### Initial Release 🎉

- ✅ **ObservableTypeHelper**: Automatic serialization for `Observable<T>` types
- ✅ **ObservableListTypeHelper**: Automatic serialization for `ObservableList<T>` types
- ✅ **ObservableMapTypeHelper**: Automatic serialization for `ObservableMap<K,V>` types
- ✅ **ObservableSetTypeHelper**: Automatic serialization for `ObservableSet<T>` types
- ✅ **Zero Configuration**: Works out-of-the-box with standard `@JsonSerializable()` classes
- ✅ **Generic Type Support**: Full support for generic types with proper type inference
- ✅ **Nested Observables**: Support for complex nested observable structures
- ✅ **Custom Builder**: Integrated builder that extends `json_serializable` functionality
- ✅ **Comprehensive Documentation**: Complete README with examples and migration guide
- ✅ **Example Application**: Fully working example demonstrating all features
- ✅ **Unit Tests**: Basic test structure for all TypeHelper implementations

### Breaking Changes

None - this is the initial release.

### Migration Guide

For users migrating from custom MobX converters:

1. Remove custom converter classes (e.g., `ObservableTodoListConverter`)
2. Remove converter annotations from observable fields
3. Add `mobx_json_serializable: ^1.0.0` to `dev_dependencies`
4. Update `build.yaml` to use `mobx_json_serializable_generator`
5. Run `dart run build_runner build --delete-conflicting-outputs`

### Known Limitations

- Requires `analyzer: '>=7.4.0 <8.0.0'`
- Complex generic type constraints may need manual testing
- Performance testing pending (planned for v1.1.0)

### Acknowledgments

Special thanks to the MobX.dart community and the `json_serializable` team for providing the foundation that made this package possible.