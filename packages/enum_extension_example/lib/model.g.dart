// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// ExtensionGenerator
// **************************************************************************

const _$ExampleEnumDescMap = {
  Example.first: 'first',
  Example.second: 'second',
  Example.third: 'third',
  Example.fourth: 5
};

extension ExampleExt on Example {
  String get value => _$ExampleEnumMap[this]!;
  Object get desc => _$ExampleEnumDescMap[this]!;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

A _$AFromJson(Map<String, dynamic> json) => A(
      json['b'] as String,
      _$enumDecode(_$ExampleEnumMap, json['example']),
    );

Map<String, dynamic> _$AToJson(A instance) => <String, dynamic>{
      'b': instance.b,
      'example': _$ExampleEnumMap[instance.example],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ExampleEnumMap = {
  Example.first: 'first',
  Example.second: 'second',
  Example.third: 'ttt',
  Example.fourth: 'fourth',
};
