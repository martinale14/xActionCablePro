import 'dart:developer';

import 'package:flutter/foundation.dart';
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
      try {
        final T? data = converter!.call(response.data!);
        action?.call(data, response.error);

        return;
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
      }
    }

    if (response.data != null) {
      action?.call(response.data as T, response.error);

      return;
    }

    action?.call(null, response.error);
  }
}
