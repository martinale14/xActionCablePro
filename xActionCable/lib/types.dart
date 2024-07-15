import 'models/action_callback.dart';
import 'models/action_response.dart';

typedef VoidCallback = void Function();
typedef OnPingMessage = void Function(DateTime lastPing);
typedef OnMessageRecieve = void Function(ActionResponse response);
typedef SendMessageCallback = void Function(Map<String, dynamic> payload);
typedef OnMessageCallbacks = Map<String, List<ActionCallback>?>;
