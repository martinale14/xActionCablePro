import 'package:x_action_cable_pro/x_action_cable_pro.dart';

class TestConnection extends Connection {
  @override
  String get url => 'ws://10.97.124.208:3000/cable';
}

class TestChannel extends Channel {
  final String bookingId;

  @override
  Map<String, dynamic> get channelParams => {
        'id': bookingId,
      };

  @override
  List<CableAction> get actions => [
        CableAction(code: 'message', action: onMessage),
      ];

  TestChannel({
    required this.bookingId,
  });

  void onMessage(dynamic data, String? error) {
    print(data);
  }
}
