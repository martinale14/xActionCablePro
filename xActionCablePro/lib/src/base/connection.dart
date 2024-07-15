import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:x_action_cable_pro/action_cable_pro.dart';
import 'package:meta/meta.dart';

abstract class Connection {
  bool connected = false;
  int _retryCount = 0;
  ActionCable? _cable;
  Map<String, Channel> subscriptions = {};

  String get url;
  int get retries => 3;
  Duration get retrayDelay => const Duration(seconds: 3);

  ActionCable? get cable => _cable;

  Connection();

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
    if (subscriptions.isNotEmpty) {
      final List<Channel> retryChannels =
          subscriptions.entries.map((entry) => entry.value).toList();
      subscriptions.clear();
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
        assert(!subscriptions.containsKey(channel.channelName));
        subscriptions[channel.channelName] = channel;
        channel.onSubscribed();
      },
      onDisconnected: () {
        assert(subscriptions.containsKey(channel.channelName));
        subscriptions.remove(channel.channelName);
        channel.onDisconnected();
      },
      callbacks:
          channel.actions.map((action) => action.actionCallback).toList(),
    );
    channel.channel = newChannel;
  }

  void removeSubscription(String channelName) {
    subscriptions[channelName]?.channel?.unsubscribe();
    subscriptions[channelName]?.onDisconnected();
    assert(subscriptions.containsKey(channelName));
    subscriptions.remove(channelName);
  }
}

class FailedConnectionException extends Error {}
