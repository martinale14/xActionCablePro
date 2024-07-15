import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:x_action_cable_pro/src/base/cable_action.dart';
import 'package:x_action_cable/models/action_channel.dart';

abstract class Channel {
  ActionChannel? channel;

  Map<String, dynamic> get channelParams => {};
  String get channelName => runtimeType.toString();
  List<CableAction> get actions => [];

  Channel();

  @mustCallSuper
  void onSubscribed() {
    _log('Subscribed');
  }

  @mustCallSuper
  void onDisconnected() {
    _log('Unsubscribed');
  }

  void _log(String message) {
    log(message, name: runtimeType.toString());
  }
}
