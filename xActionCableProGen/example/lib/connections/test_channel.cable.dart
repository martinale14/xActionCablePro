// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_channel.dart';

// **************************************************************************
// ChannelGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class TestChannel extends _TestChannel {
  TestChannel({super.bookingId});

  final _onMessageStreamController = StreamController<Map<String, dynamic>>();

  final _replaceStreamController = StreamController<TestModel>();

  @override
  Map<String, dynamic> get channelParams => {
        'id': bookingId,
      };

  Stream<Map<String, dynamic>> get onMessageStream =>
      _onMessageStreamController.stream;

  Stream<TestModel> get replaceStream => _replaceStreamController.stream;

  @override
  List<CableAction> get actions => [
        CableAction<Map<String, dynamic>>(
          code: 'message',
          action: (data, error) {
            if (data != null) {
              _onMessageStreamController.add(data);
            }
            _onMessage(data, error);
          },
        ),
        CableAction<TestModel>(
          code: '_replace',
          action: (data, error) {
            if (data != null) {
              _replaceStreamController.add(data);
            }
            _replace(data, error);
          },
          converter: TestModel.fromJson,
        ),
      ];
}
