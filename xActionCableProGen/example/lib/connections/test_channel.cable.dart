// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_channel.dart';

// **************************************************************************
// ChannelGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class TestChannel extends _TestChannel {
  TestChannel({super.bookingId});

  @override
  Map<String, dynamic> get channelParams => {
        'id': bookingId,
      };

  @override
  List<CableAction> get actions => [
        CableAction(code: 'message', action: onMessage),
      ];
}
