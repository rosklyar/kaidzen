import 'package:kaidzen_app/assets/constants.dart';

import '../models/progress.dart';
import '../models/task.dart';

class ProgressCalculator {
  static double progressDelta(double current, Task task) {
    return 0.1;
  }

  static int levelDelta(int current, Task task) {
    return 1;
  }
}
