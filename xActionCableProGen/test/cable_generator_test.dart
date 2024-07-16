@TestOn('vm')
@Timeout(Duration(seconds: 120))
library;

import 'package:build_verify/build_verify.dart';
import 'package:test/test.dart';

void main() {
  test(
    'ensure_build',
    () async {
      await expectBuildClean(
        packageRelativeDirectory: 'xActionCableProGen',
        gitDiffPathArguments: [
          'test/test_channel.cable.dart',
        ],
      );
    },
  );
}
