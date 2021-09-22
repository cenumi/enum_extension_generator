library enum_extension_annotation;

export 'package:json_annotation/json_annotation.dart';

class EnumExtension {
  const EnumExtension({this.desc = true, this.value = true, this.skipValueMapGeneration = false});
  final bool desc;
  final bool value;

  /// set to true if JsonSerializable generate the same value;
  ///
  /// change it only if you get an error
  final bool skipValueMapGeneration;
}

class DescValue {
  const DescValue(this.value);

  /// The value to use when serializing and deserializing.
  ///
  /// Can be a [String] or an [int].
  final Object? value;
}
