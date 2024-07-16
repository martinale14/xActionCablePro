import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:x_action_cable_pro/x_action_cable_pro.dart';

class TestConnection extends Connection {
  TestConnection({
    required super.url,
    super.headers,
    super.retries,
    super.retryDelay,
    super.interceptors,
  });
}

@module
abstract class ActionCableModule {
  @lazySingleton
  TestConnection testConnection() => TestConnection(
        url: 'ws://192.168.1.196:3000/cable',
        headers: {
          'x-test': 'Este es un header test',
        },
        interceptors: [
          AuthorizeConnectionInterceptor(),
        ],
      );
}

class AuthorizeConnectionInterceptor extends ConnectionInterceptor {
  @override
  ConnectionReference beforeConnection(ConnectionReference reference) {
    final newHeaders = Map<String, String>.from(reference.headers);
    newHeaders['x-new'] = 'Este es un nuevo header';

    final queryParameters =
        Map<String, String>.from(reference.uri.queryParameters);
    queryParameters.putIfAbsent('t', () => 'my-user-token');
    final newUri = reference.uri.replace(queryParameters: queryParameters);

    return ConnectionReference(headers: newHeaders, uri: newUri);
  }
}
