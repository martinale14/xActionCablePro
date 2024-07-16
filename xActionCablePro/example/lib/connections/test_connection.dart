import 'dart:async';
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

  final _messageStreamController = StreamController<Message>();
  Stream<Message> get messageStream => _messageStreamController.stream;

  @override
  Map<String, dynamic> get channelParams => {
        'id': bookingId,
      };

  @override
  List<CableAction> get actions => [
        CableAction<Message>(
          code: 'message',
          action: (message, error) {
            if (message != null) {
              _messageStreamController.add(message);
            }
            onMessage(message, error);
          },
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
