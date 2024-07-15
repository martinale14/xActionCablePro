import 'package:x_action_cable/models/models.dart';

class CableAction<T> {
  String code;
  dynamic Function(T? data, String? error)? action;
  final T Function(Map<String, dynamic> json)? converter;
  late final ActionCallback actionCallback;

  CableAction({
    required this.code,
    this.action,
    this.converter,
  }) {
    actionCallback = ActionCallback(
      name: code,
      callback: _realAction,
    );
  }

  void _realAction(ActionResponse response) {
    if (response.data != null && converter != null) {
      final T? data = converter!(response.data!);
      action?.call(data, response.error);

      return;
    }

    action?.call(response.data as dynamic, response.error);
  }
}
