import 'package:mobx/mobx.dart';
import 'package:json_annotation/json_annotation.dart';

part 'test_models.g.dart';

/// Simple model for testing basic serialization
@JsonSerializable()
class SimpleModel {
  final String id;
  final String name;

  SimpleModel({required this.id, required this.name});

  factory SimpleModel.fromJson(Map<String, dynamic> json) =>
      _$SimpleModelFromJson(json);

  Map<String, dynamic> toJson() => _$SimpleModelToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimpleModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

/// Store with Observable<T> field
@JsonSerializable()
class ObservableStore with Store {
  ObservableStore();

  @observable
  Observable<String?> currentValue = Observable(null);

  @observable
  Observable<int> counter = Observable(0);

  factory ObservableStore.fromJson(Map<String, dynamic> json) =>
      _$ObservableStoreFromJson(json);

  Map<String, dynamic> toJson() => _$ObservableStoreToJson(this);
}

/// Store with ObservableList<T> field
@JsonSerializable()
class ListStore with Store {
  ListStore();

  @observable
  ObservableList<String> items = ObservableList<String>();

  @observable
  ObservableList<SimpleModel> models = ObservableList<SimpleModel>();

  factory ListStore.fromJson(Map<String, dynamic> json) =>
      _$ListStoreFromJson(json);

  Map<String, dynamic> toJson() => _$ListStoreToJson(this);
}

/// Store with ObservableMap<K,V> field
@JsonSerializable()
class MapStore with Store {
  MapStore();

  @observable
  ObservableMap<String, int> counters = ObservableMap<String, int>();

  @observable
  ObservableMap<String, SimpleModel> modelMap =
      ObservableMap<String, SimpleModel>();

  factory MapStore.fromJson(Map<String, dynamic> json) =>
      _$MapStoreFromJson(json);

  Map<String, dynamic> toJson() => _$MapStoreToJson(this);
}

/// Store with ObservableSet<T> field
@JsonSerializable()
class SetStore with Store {
  SetStore();

  @observable
  ObservableSet<String> tags = ObservableSet<String>();

  @observable
  ObservableSet<SimpleModel> modelSet = ObservableSet<SimpleModel>();

  factory SetStore.fromJson(Map<String, dynamic> json) =>
      _$SetStoreFromJson(json);

  Map<String, dynamic> toJson() => _$SetStoreToJson(this);
}

/// Complex store with nested observables
@JsonSerializable()
class ComplexStore with Store {
  ComplexStore();

  @observable
  ObservableList<ObservableMap<String, Observable<int>>> nested =
      ObservableList<ObservableMap<String, Observable<int>>>();

  @observable
  Observable<ObservableList<String>?> optionalList = Observable(null);

  @observable
  ObservableMap<String, Observable<SimpleModel?>> complexMap =
      ObservableMap<String, Observable<SimpleModel?>>();

  factory ComplexStore.fromJson(Map<String, dynamic> json) =>
      _$ComplexStoreFromJson(json);

  Map<String, dynamic> toJson() => _$ComplexStoreToJson(this);
}
