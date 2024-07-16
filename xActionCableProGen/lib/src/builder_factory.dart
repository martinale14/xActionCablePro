import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:x_action_cable_pro_gen/src/builders/channel_generator.dart';
import 'package:yaml/yaml.dart';

Builder actionCableGeneratorFactory(BuilderOptions options) {
  final String buildExtension = _getBuildExtension(options);

  return PartBuilder(
    [ChannelGenerator()],
    buildExtension,
    header: options.config['header'],
    options: options.config.containsKey('build_extensions')
        ? options
        : options.overrideWith(
            BuilderOptions({
              'build_extensions': {
                '.dart': [buildExtension]
              },
            }),
          ),
  );
}

String _getBuildExtension(BuilderOptions options) {
  const String defaultExtension = '.cable.dart';

  if (!options.config.containsKey('build_extensions')) return defaultExtension;

  final YamlMap buildExtensions = options.config['build_extensions'];
  if (!buildExtensions.containsKey('.dart')) return defaultExtension;

  final YamlList dartBuildExtensions = buildExtensions['.dart'];
  if (dartBuildExtensions.isEmpty) return defaultExtension;

  return dartBuildExtensions.first;
}
