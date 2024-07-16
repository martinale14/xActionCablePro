import 'package:x_action_cable_pro/x_action_cable_pro.dart';

class TestConnection extends Connection {
  TestConnection({
    required super.url,
    super.retrayDelay,
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
        CableAction(code: 'message', action: onMessage),
      ];

  TestChannel({
    required this.bookingId,
  });

  void onMessage(dynamic data, String? error) {
    print(data);
  }
}
