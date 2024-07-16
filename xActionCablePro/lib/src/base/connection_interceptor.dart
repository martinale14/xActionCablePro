import 'package:x_action_cable_pro/src/base/connection_reference.dart';

abstract class ConnectionInterceptor {
  ConnectionReference beforeConnection(ConnectionReference reference);
}
