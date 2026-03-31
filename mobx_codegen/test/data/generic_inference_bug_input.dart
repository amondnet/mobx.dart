library generator_sample;

import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

// Define a constraint type 
abstract interface class Subtype {
  int get value;
}

// Generic class with type constraint
class GeneratedModelWithGeneric<T extends Subtype> {
  final T subtype;
  GeneratedModelWithGeneric({required this.subtype});
}

// Store that uses the generic without explicit type arguments
// This should infer GeneratedModelWithGeneric<Subtype> but Subtype is defined
// in the same file, so it should be accessible
class TestStore = _TestStore with _$TestStore;

abstract class _TestStore with Store {
  @computed
  GeneratedModelWithGeneric? get someValue => null;
}