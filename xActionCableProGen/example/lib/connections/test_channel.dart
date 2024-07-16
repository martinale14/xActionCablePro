import 'package:x_action_cable_pro/x_action_cable_pro.dart';

part 'test_channel.cable.dart';

@CableChannel()
class _TestChannel extends Channel {
  @ChannelParam(key: 'id')
  final String? bookingId;

  _TestChannel({this.bookingId});

  @ChannelAction(code: 'message')
  void onMessage(dynamic data, String? error) {
    print(data);
  }
}
