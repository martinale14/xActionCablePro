import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:x_action_cable_pro/src/base/cable_action.dart';
import 'package:x_action_cable_v2/models/action_channel.dart';

abstract class Channel {
  ActionChannel? channel;

  Map<String, dynamic> get params => {};
  String get name => runtimeType.toString();
  List<CableAction> get actions => [];

  Channel();

  void unsuscribe() {
    channel?.unsubscribe();
  }

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
