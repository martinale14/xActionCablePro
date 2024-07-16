import 'package:example/models/test_model.dart';
import 'package:flutter/foundation.dart';
import 'package:x_action_cable_pro/x_action_cable_pro.dart';
import 'package:injectable/injectable.dart';

part 'test_channel.cable.dart';

@CableChannel(extraAnnotations: ['lazySingleton'])
abstract class _TestChannel extends Channel {
  @ChannelParam(key: 'id')
  final String? bookingId;

  _TestChannel({this.bookingId});

  @ChannelAction(code: 'message')
  void onMessage(TestModel? data, String? error) {
    debugPrint(data?.message);
  }
}
