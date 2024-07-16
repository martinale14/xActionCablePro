// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_routes_channel.dart';

// **************************************************************************
// ChannelGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class BookingRoutesChannel extends _BookingRoutesChannel {
  BookingRoutesChannel(super.bookingId);

  @override
  Map<String, dynamic> get channelParams => {
        'id': bookingId,
      };

  @override
  List<CableAction> get actions => [
        CableAction(code: 'update_route', action: onUpdateRoute),
      ];
}
