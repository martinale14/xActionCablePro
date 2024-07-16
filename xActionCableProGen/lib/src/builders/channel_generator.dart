import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:logging/logging.dart';
import 'package:x_action_cable_pro/x_action_cable_pro.dart' as pro;
import 'package:source_gen/source_gen.dart';
import 'package:x_action_cable_pro_gen/src/consts.dart';
import 'package:code_builder/code_builder.dart';

final class ChannelGenerator extends GeneratorForAnnotation<pro.CableChannel> {
  static TypeChecker _typeChecker(Type type) => TypeChecker.fromRuntime(type);

  static bool _extendsChannel(InterfaceType type) =>
      _typeChecker(pro.Channel).isExactlyType(type);

  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'Generator cannot target `${element.displayName}`. Remove the [CableChannel] annotation from `${element.displayName}`',
      );
    }

    return build(element, annotation);
  }

  String build(ClassElement element, ConstantReader annotation) {
    if (!element.displayName.startsWith('_')) {
      throw InvalidGenerationSourceError(
        'Generator cannot target `${element.displayName}`. Add underscore to class like this `_${element.displayName}',
      );
    }

    if (!element.allSupertypes.any(_extendsChannel)) {
      throw InvalidGenerationSourceError(
        'Generator cannot target `${element.displayName}`.',
        todo:
            'Class must extends Channel from x_action_cable_pro `_${element.displayName}`.',
      );
    }

    final className = element.displayName.substring(1);
    final ConstantReader? channelNameReader = annotation.peek(Consts.name.name);

    String channelName = className;

    if (channelNameReader != null) {
      channelName = channelNameReader.stringValue;
    }

    channelName =
        channelName.endsWith('Channel') ? channelName : '${channelName}Channel';

    final classBuilder = Class((builder) {
      builder
        ..modifier = ClassModifier.final$
        ..name = className
        ..extend = refer(element.displayName)
        ..constructors.add(_generateConstructor(element))
        ..methods.add(_generateChannelParamsGetterMethod(element))
        ..methods.add(_generateChannelActionsGetterMethod(element));
    });

    const String ignore = '// coverage:ignore-file\n'
        '// ignore_for_file: type=lint';

    final DartEmitter emitter = DartEmitter(useNullSafetySyntax: true);

    return DartFormatter().format('$ignore\n${classBuilder.accept(emitter)}');
  }

  Method _generateChannelParamsGetterMethod(ClassElement element) =>
      Method((MethodBuilder builder) {
        StringBuffer params = StringBuffer('{');

        for (final field in element.fields) {
          final DartObject? annotation = _typeChecker(pro.ChannelParam)
              .firstAnnotationOf(field, throwOnUnresolved: false);

          if (annotation == null) continue;

          ConstantReader reader = ConstantReader(annotation);
          String key =
              reader.peek(Consts.key.name)?.stringValue ?? field.displayName;

          params.write('\'$key\': ${field.displayName},');
        }

        params.write('}');

        builder
          ..annotations.add(const CodeExpression(Code('override')))
          ..returns =
              TypeReference((TypeReferenceBuilder typeReferenceBuilder) {
            typeReferenceBuilder.symbol = 'Map<String, dynamic>';
          })
          ..name = 'channelParams'
          ..type = MethodType.getter
          ..lambda = true
          ..body = Code(params.toString());
      });

  Method _generateChannelActionsGetterMethod(ClassElement element) =>
      Method((MethodBuilder builder) {
        StringBuffer actions = StringBuffer('[');

        for (final method in element.methods) {
          final DartObject? annotation = _typeChecker(pro.ChannelAction)
              .firstAnnotationOf(method, throwOnUnresolved: false);

          if (annotation == null) continue;

          ConstantReader reader = ConstantReader(annotation);
          String code =
              reader.peek(Consts.code.name)?.stringValue ?? method.displayName;

          actions.write(
            'CableAction(code: \'$code\', action: ${method.displayName}),',
          );
        }

        actions.write(']');

        builder
          ..annotations.add(const CodeExpression(Code('override')))
          ..returns =
              TypeReference((TypeReferenceBuilder typeReferenceBuilder) {
            typeReferenceBuilder.symbol = 'List<CableAction>';
          })
          ..name = 'actions'
          ..type = MethodType.getter
          ..lambda = true
          ..body = Code(actions.toString());
      });

  Constructor _generateConstructor(ClassElement element) =>
      Constructor((ConstructorBuilder builder) {
        for (final param in element.constructors.first.parameters) {
          final superParam = Parameter((ParameterBuilder paramBuilder) {
            paramBuilder
              ..name = param.displayName
              ..named = param.isNamed
              ..required = param.isRequired && param.isNamed
              ..toSuper = true;
          });

          if (param.isOptional || param.isNamed) {
            builder.optionalParameters.add(superParam);
          } else {
            builder.requiredParameters.add(superParam);
          }
        }
      });
}
