import 'package:meta/meta.dart';

abstract class ConnectionInterceptor {
  @mustBeOverridden
  Uri beforeConnection(Uri uri);
}
