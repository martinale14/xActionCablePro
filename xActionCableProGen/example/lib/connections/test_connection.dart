import 'package:injectable/injectable.dart';
import 'package:x_action_cable_pro/x_action_cable_pro.dart';

class TestConnection extends Connection {
  TestConnection({
    required super.url,
    super.retries,
    super.retryDelay,
    super.interceptors,
  });
}

@module
abstract class ActionCableModule {
  @lazySingleton
  TestConnection testConnection() =>
      TestConnection(url: 'ws://192.168.1.196:3000/cable');
}
