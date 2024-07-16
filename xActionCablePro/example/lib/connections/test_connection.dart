import 'dart:developer';

import 'package:x_action_cable_pro/x_action_cable_pro.dart';

class TestConnection extends Connection {
  TestConnection({
    required super.url,
    super.retryDelay,
    super.retries,
  });
}

class TestChannel extends Channel {
  final String bookingId;

  @override
  Map<String, dynamic> get channelParams => {
        'id': bookingId,
      };

  @override
  List<CableAction> get actions => [
        CableAction<Message>(
          code: 'message',
          action: onMessage,
          converter: Message.fromJson,
        ),
      ];

  TestChannel({
    required this.bookingId,
  });

  void onMessage(Message? data, String? error) {
    log(data?.test.toString() ?? 'Null');
  }
}

class Message {
  String test;

  Message(this.test);

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(json['test'] as String);
}
