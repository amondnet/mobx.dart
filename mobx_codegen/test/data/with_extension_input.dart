library generator_sample;

import 'package:mobx/mobx.dart';

part 'store_with_extension.g.dart';

// ignore: library_private_types_in_public_api
class Foo = _Foo with _$Foo;

abstract class _Foo with Store {
  @observable
  late String name;
}

extension on int {}