import 'package:example/models/test_model.dart';
import 'package:flutter/foundation.dart';
import 'package:x_action_cable_pro/x_action_cable_pro.dart';
import 'package:injectable/injectable.dart';

part 'test_channel.cable.dart';

@CableChannel()
abstract class _TestChannel extends Channel {
  @ChannelParam(key: 'id')
  final String? bookingId;

  _TestChannel({this.bookingId});

  @ChannelAction(code: 'message')
  void onMessage(Map<String, dynamic>? data, String? error) {
    debugPrint(data?.toString());
  }

  @ChannelAction()
  void replace(TestModel? data, String? error) {
    debugPrint(data?.toString());
  }
}
