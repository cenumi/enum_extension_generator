import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:enum_extension_annotation/enum_extension_annotation.dart';
import 'package:source_gen/source_gen.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

class ExtensionGenerator extends GeneratorForAnnotation<EnumExtension> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) sync* {
    if (element is! ClassElement || !element.isEnum) {
      throw InvalidGenerationSourceError('this is not a enum class', element: element);
    }

    final shouldGenerateDescGetter = annotation.read('desc').boolValue;
    final shouldGenerateValueGetter = annotation.read('value').boolValue;
    final shouldSkipValueGenerator = annotation.read('skipValueMapGeneration').boolValue;

    if (!shouldGenerateValueGetter && !shouldGenerateDescGetter) {
      return;
    }

    final emitter = DartEmitter();
    final formatter = DartFormatter();

    final valueMapName = '_\$${element.name}EnumMap';
    final descMapName = '_\$${element.name}EnumDescMap';

    Reference? descGetterReference;
    Reference? valueGetterReference;

    if (shouldGenerateDescGetter) {
      final desc = _buildMap(element, mapName: descMapName, typeName: 'DescValue');
      descGetterReference = desc.item2;
      if (desc.item1 != null) {
        yield formatter.format(desc.item1!.accept(emitter).toString());
      }
    }

    if (shouldGenerateValueGetter && !shouldSkipValueGenerator) {
      final value = _buildMap(element, mapName: valueMapName, typeName: 'JsonValue');
      valueGetterReference = value.item2;
      if (value.item1 != null) {
        yield formatter.format(value.item1!.accept(emitter).toString());
      }
    }

    final extension = _buildExtension(
      element,
      shouldGenerateDescGetter: shouldGenerateDescGetter,
      shouldGenerateValueGetter: shouldGenerateValueGetter,
      valueMapName: valueMapName,
      descMapName: descMapName,
      descGetterReference: descGetterReference,
      valueGetterReference: valueGetterReference,
    ).accept(emitter);

    yield formatter.format(extension.toString());
  }

  Extension _buildExtension(
    ClassElement element, {
    required bool shouldGenerateValueGetter,
    required bool shouldGenerateDescGetter,
    required String valueMapName,
    required String descMapName,
    required Reference? descGetterReference,
    required Reference? valueGetterReference,
  }) {
    return Extension((extension) {
      extension
        ..name = '${element.name}Ext'
        ..on = refer(element.name)
        ..methods.addAll([
          if (shouldGenerateValueGetter)
            Method((method) {
              method
                ..name = 'value'
                ..type = MethodType.getter
                ..lambda = true
                ..returns = valueGetterReference
                ..body = Code('$valueMapName[this]!');
            }),
          if (shouldGenerateDescGetter)
            Method((method) {
              method
                ..name = 'desc'
                ..type = MethodType.getter
                ..lambda = true
                ..returns = descGetterReference
                ..body = Code('$descMapName[this]!');
            }),
        ]);
    });
  }

  Tuple2<Field?, Reference?> _buildMap(
    ClassElement element, {
    required String mapName,
    required String typeName,
  }) {
    final map = {};
    final set = <String>{};
    for (final field in element.fields) {
      if (!field.isEnumConstant) {
        continue;
      }

      final annotation = field.metadata
          .map((e) => e.computeConstantValue())
          .firstWhereOrNull((element) => element?.type.toString() == typeName);

      if (annotation != null) {
        final literalValue = ConstantReader(annotation).read('value').literalValue;
        set.add(literalValue.runtimeType.toString());
        map[refer(element.displayName).property(field.displayName)] = literalValue;
      } else {
        set.add('String');
        map[refer(element.displayName).property(field.displayName)] = field.displayName;
      }
    }

    if (map.isEmpty) {
      return const Tuple2(null, null);
    }

    return Tuple2(Field((field) {
      field
        ..assignment = literalMap(map).code
        ..modifier = FieldModifier.constant
        ..name = mapName;
    }), refer(set.length == 1 ? set.first : 'Object'));
  }
}
