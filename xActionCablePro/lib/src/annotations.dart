import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

@immutable
@Target({TargetKind.classType})
final class CableChannel {
  final String? name;
  final List<String> extraAnnotations;

  const CableChannel({
    this.name,
    this.extraAnnotations = const [],
  });
}

@immutable
@Target({TargetKind.field})
final class ChannelParam {
  final String? key;

  const ChannelParam({this.key});
}

@immutable
@Target({TargetKind.method})
final class ChannelAction {
  final String? code;

  const ChannelAction({this.code});
}
