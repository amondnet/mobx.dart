import 'package:mobx/mobx.dart';
import 'package:json_annotation/json_annotation.dart';

part 'test_models.g.dart';

/// Simple model for testing basic serialization
@JsonSerializable()
class SimpleModel {
  final String id;
  final String name;

  SimpleModel({required this.id, required this.name});

  factory SimpleModel.fromJson(Map<String, dynamic> json) => _$SimpleModelFromJson(json);
  Map<String, dynamic> toJson() => _$SimpleModelToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimpleModel && runtimeType == other.runtimeType && id == other.id && name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

/// Store with Observable<T> field
@JsonSerializable()
class ObservableStore = _ObservableStore with _$ObservableStore;

abstract class _ObservableStore with Store {
  _ObservableStore();

  @observable
  Observable<String?> currentValue = Observable(null);

  @observable
  Observable<int> counter = Observable(0);

  factory _ObservableStore.fromJson(Map<String, dynamic> json) => _$ObservableStoreFromJson(json);
  Map<String, dynamic> toJson() => _$ObservableStoreToJson(this);
}

/// Store with ObservableList<T> field
@JsonSerializable()
class ListStore = _ListStore with _$ListStore;

abstract class _ListStore with Store {
  _ListStore();

  @observable
  ObservableList<String> items = ObservableList<String>();

  @observable
  ObservableList<SimpleModel> models = ObservableList<SimpleModel>();

  factory _ListStore.fromJson(Map<String, dynamic> json) => _$ListStoreFromJson(json);
  Map<String, dynamic> toJson() => _$ListStoreToJson(this);
}

/// Store with ObservableMap<K,V> field
@JsonSerializable()
class MapStore = _MapStore with _$MapStore;

abstract class _MapStore with Store {
  _MapStore();

  @observable
  ObservableMap<String, int> counters = ObservableMap<String, int>();

  @observable
  ObservableMap<String, SimpleModel> modelMap = ObservableMap<String, SimpleModel>();

  factory _MapStore.fromJson(Map<String, dynamic> json) => _$MapStoreFromJson(json);
  Map<String, dynamic> toJson() => _$MapStoreToJson(this);
}

/// Store with ObservableSet<T> field
@JsonSerializable()
class SetStore = _SetStore with _$SetStore;

abstract class _SetStore with Store {
  _SetStore();

  @observable
  ObservableSet<String> tags = ObservableSet<String>();

  @observable
  ObservableSet<SimpleModel> modelSet = ObservableSet<SimpleModel>();

  factory _SetStore.fromJson(Map<String, dynamic> json) => _$SetStoreFromJson(json);
  Map<String, dynamic> toJson() => _$SetStoreToJson(this);
}

/// Complex store with nested observables
@JsonSerializable()
class ComplexStore = _ComplexStore with _$ComplexStore;

abstract class _ComplexStore with Store {
  _ComplexStore();

  @observable
  ObservableList<ObservableMap<String, Observable<int>>> nested =
      ObservableList<ObservableMap<String, Observable<int>>>();

  @observable
  Observable<ObservableList<String>?> optionalList = Observable(null);

  @observable
  ObservableMap<String, Observable<SimpleModel?>> complexMap =
      ObservableMap<String, Observable<SimpleModel?>>();

  factory _ComplexStore.fromJson(Map<String, dynamic> json) => _$ComplexStoreFromJson(json);
  Map<String, dynamic> toJson() => _$ComplexStoreToJson(this);
}