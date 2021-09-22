library enum_extension_generator;

import 'package:build/build.dart';
import 'package:enum_extension_generator/src/extension_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder enumExtensionBuilder(BuilderOptions options) =>
    SharedPartBuilder([ExtensionGenerator()], 'extension_generator');
