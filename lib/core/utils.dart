import 'package:flutter/cupertino.dart';

void appDebugPrint(String message, {String prefix = '', bool enable = true}) {
  assert(() {
    if (enable) {
      debugPrint('xwxw $prefix$message');
    }
    return true;
  }());
}
