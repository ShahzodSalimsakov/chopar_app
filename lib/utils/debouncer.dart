
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'dart:async';
class Debouncer {
  final int milliseconds;
  Timer? timer;

  Debouncer({ required this.milliseconds, this.timer });

  run(VoidCallback action) {
    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}