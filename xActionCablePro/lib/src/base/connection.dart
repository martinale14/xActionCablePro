import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:x_action_cable_pro/src/base/connection_reference.dart';
import 'package:x_action_cable_pro/x_action_cable_pro.dart';
import 'package:meta/meta.dart';

import 'connection_interceptor.dart';

class Connection {
  final int retries;
  final Duration retryDelay;
  late Uri _uri;
  late final List<ConnectionInterceptor> _interceptors;
  late final Map<String, String> _headers;

  bool connected = false;
  int _retryCount = 0;
  ActionCable? _cable;
  final Map<String, Channel> _subscriptions = {};

  ActionCable? get cable => _cable;
  Map<String, dynamic> get subscriptions => Map.unmodifiable(_subscriptions);

  Connection({
    required String url,
    this.retries = 3,
    this.retryDelay = const Duration(seconds: 3),
    List<ConnectionInterceptor> interceptors = const [],
    Map<String, String> headers = const {},
  }) {
    _uri = Uri.parse(url);
    _interceptors = interceptors;
    _headers = headers;
  }

  Future<void> connect() async {
    do {
      try {
        _log('try #$_retryCount');
        await _connect();
      } catch (_) {
        _retryCount++;
        await Future.delayed(retryDelay);
      }
    } while (_retryCount <= retries && !connected);
  }

  Future<void> _connect() async {
    Completer completer = Completer<void>();
    var reference = ConnectionReference(
      headers: _headers,
      uri: _uri,
    );

    for (final interceptor in _interceptors) {
      reference = interceptor.beforeConnection(reference);
    }

    _headers = reference.headers;
    _uri = reference.uri;

    _cable = runZonedGuarded<ActionCable>(
      () => ActionCable.connect(
        _uri.toString(),
        headers: _headers,
        onConnected: () {
          _log('Connection established to $_uri');
          _retryCount = 0;
          connected = true;
          onConnected();
          completer.complete();
        },
        onConnectionLost: onConnectionLost,
        onCannotConnect: (e) {
          onCannotConnect();
          completer.completeError(FailedConnectionException());
        },
      ),
      (e, __) {
        if (e is SocketException) {
          _log('Error connecting to socket');
        }
      },
    );

    return completer.future;
  }

  void _onConnectionFailure() {
    connected = false;
    if (retries == 0) {
      throw Exception('Connection Failure');
    }

    if (_retryCount < retries) {
      _retry();

      return;
    }

    throw Exception('Max retries reached connection Failure');
  }

  void _log(String message) {
    log(message, name: runtimeType.toString());
  }

  Future<void> _retry() async {
    _retryCount++;
    _log('Retry #$_retryCount');
    await Future.delayed(retryDelay);
    try {
      await _connect();
    } catch (_) {
      _onConnectionFailure();
    }
  }

  @mustCallSuper
  void onConnected() {
    if (_subscriptions.isNotEmpty) {
      final List<Channel> retryChannels =
          _subscriptions.entries.map((entry) => entry.value).toList();
      _subscriptions.clear();
      for (final channel in retryChannels) {
        addSubscription(channel);
      }
    }
  }

  @mustCallSuper
  void onCannotConnect() {
    _log('$_uri cannot connect');
  }

  @mustCallSuper
  void onConnectionLost() {
    _log('$_uri connection lost');
    _onConnectionFailure();
  }

  void addSubscription(Channel channel) {
    final newChannel = cable?.subscribe(
      channel.channelName,
      channelParams: channel.channelParams,
      onSubscribed: () {
        assert(!_subscriptions.containsKey(channel.channelName));
        _subscriptions[channel.channelName] = channel;
        channel.onSubscribed();
      },
      onDisconnected: () {
        assert(_subscriptions.containsKey(channel.channelName));
        _subscriptions.remove(channel.channelName);
        channel.onDisconnected();
      },
      callbacks:
          channel.actions.map((action) => action.actionCallback).toList(),
    );
    channel.channel = newChannel;
  }

  void removeSubscription(String channelName) {
    _subscriptions[channelName]?.channel?.unsubscribe();
    _subscriptions[channelName]?.onDisconnected();
    assert(_subscriptions.containsKey(channelName));
    _subscriptions.remove(channelName);
  }
}

class FailedConnectionException extends Error {}
