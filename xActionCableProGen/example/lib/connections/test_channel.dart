import 'package:example/models/test_model.dart';
import 'package:flutter/foundation.dart';
import 'package:x_action_cable_pro/x_action_cable_pro.dart';

part 'test_channel.cable.dart';

@CableChannel()
abstract class _TestChannel extends Channel {
  @ChannelParam(key: 'id')
  final String? bookingId;

  _TestChannel({this.bookingId});

  @ChannelAction(code: 'message')
  void onMessage(Map<String, dynamic>? data, String? error);

  @ChannelAction()
  void loqQueYoQuiera(TestModel? data, String? error);

  @ChannelAction(code: 'on_receive')
  void onReceive(dynamic data, String? error);
}
