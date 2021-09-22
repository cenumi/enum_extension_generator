import 'package:enum_extension_annotation/enum_extension_annotation.dart';

part 'model.g.dart';

@EnumExtension(skipValueMapGeneration: true)
enum Example {
  first,
  @DescValue('second')
  second,
  @DescValue('third')
  @JsonValue('ttt')
  third,
  @DescValue(5)
  fourth
}

@JsonSerializable()
class A {
  final String b;
  final Example example;

  A(this.b, this.example);
}
