import 'package:x_action_cable_pro/x_action_cable_pro.dart';

part 'booking_routes_channel.cable.dart';

@CableChannel()
abstract class _BookingRoutesChannel extends Channel {
  @ChannelParam(key: 'id')
  final String bookingId;

  _BookingRoutesChannel(this.bookingId);

  @ChannelAction(code: 'update_route')
  void onUpdateRoute(dynamic data, String? error) {
    //TODO: Implement updateRoute
  }
}
