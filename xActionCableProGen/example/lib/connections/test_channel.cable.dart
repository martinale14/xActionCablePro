// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_channel.dart';

// **************************************************************************
// ChannelGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class TestChannel extends _TestChannel {
  TestChannel({super.bookingId});

  final onMessageStreamController = StreamController<Map<String, dynamic>>();

  final loqQueYoQuieraStreamController = StreamController<TestModel>();

  final onReceiveStreamController = StreamController<dynamic>();

  @override
  Map<String, dynamic> get params => {
        'id': bookingId,
      };

  Stream<Map<String, dynamic>> get onMessageStream =>
      onMessageStreamController.stream;

  Stream<TestModel> get loqQueYoQuieraStream =>
      loqQueYoQuieraStreamController.stream;

  Stream<dynamic> get onReceiveStream => onReceiveStreamController.stream;

  @override
  List<CableAction> get actions => [
        CableAction<Map<String, dynamic>>(
          code: 'message',
          action: onMessage,
        ),
        CableAction<TestModel>(
          code: 'loqQueYoQuiera',
          action: loqQueYoQuiera,
          converter: TestModel.fromJson,
        ),
        CableAction(code: 'on_receive', action: onReceive),
      ];

  @override
  void onMessage(
    Map<String, dynamic>? data,
    String? error,
  ) {
    if (data == null) return;
    onMessageStreamController.add(data);
  }

  @override
  void loqQueYoQuiera(
    TestModel? data,
    String? error,
  ) {
    if (data == null) return;
    loqQueYoQuieraStreamController.add(data);
  }

  @override
  void onReceive(
    dynamic data,
    String? error,
  ) {
    if (data == null) return;
    onReceiveStreamController.add(data);
  }
}
