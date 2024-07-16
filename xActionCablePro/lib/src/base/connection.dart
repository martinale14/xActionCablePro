import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:x_action_cable_pro/x_action_cable_pro.dart';
import 'package:meta/meta.dart';

abstract class Connection {
  final String url;
  final int retries;
  final Duration retrayDelay;

  bool connected = false;
  int _retryCount = 0;
  ActionCable? _cable;
  final Map<String, Channel> _subscriptions = {};

  ActionCable? get cable => _cable;
  Map<String, dynamic> get subscriptions => Map.unmodifiable(_subscriptions);

  Connection({
    required this.url,
    this.retries = 3,
    this.retrayDelay = const Duration(seconds: 3),
  });

  Future<void> connect() async {
    do {
      try {
        _log('try #$_retryCount');
        await _connect();
      } catch (_) {
        _retryCount++;
        await Future.delayed(retrayDelay);
      }
    } while (_retryCount <= retries && !connected);
  }

  Future<void> _connect() async {
    Completer completer = Completer<void>();

    _cable = runZonedGuarded<ActionCable>(
      () => ActionCable.connect(
        url,
        onConnected: () {
          _log('Connection established to $url');
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
    await Future.delayed(retrayDelay);
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
    _log('$url cannot connect');
  }

  @mustCallSuper
  void onConnectionLost() {
    _log('$url connection lost');
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
