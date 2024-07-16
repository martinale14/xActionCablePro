import 'package:meta/meta.dart';
import 'package:x_action_cable_pro/src/base/connection_reference.dart';

abstract class ConnectionInterceptor {
  @mustBeOverridden
  ConnectionReference beforeConnection(ConnectionReference reference);
}
