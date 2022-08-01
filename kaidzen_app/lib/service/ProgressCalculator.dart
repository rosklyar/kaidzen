import 'package:kaidzen_app/assets/constants.dart';

import '../models/progress.dart';
import '../models/task.dart';

class ProgressCalculator {
  static final Map<DevelopmentCategory, double> _progressDeltaMap = {
    DevelopmentCategory.ENERGY: 0.1,
    DevelopmentCategory.HEALTH: 0.2,
    DevelopmentCategory.WEALTH: 0.15,
    DevelopmentCategory.RELATIONS: 0.25,
    DevelopmentCategory.MIND: 0.05
  };

  static double progressDelta(double current, Task task) {
    return _progressDeltaMap[task.category]! * (1 + task.difficulty.id);
  }

  static int levelDelta(int current, Task task) {
    return 1 + task.difficulty.id;
  }
}
