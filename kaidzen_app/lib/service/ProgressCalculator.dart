import 'package:kaidzen_app/assets/constants.dart';

import '../models/progress.dart';
import '../models/task.dart';

class ProgressCalculator {
  Map<DevelopmentCategory, double> progressDeltaMap = {
    DevelopmentCategory.PERSONAL_DEVELOPMENT: 0.1,
    DevelopmentCategory.HEALTH: 0.2,
    DevelopmentCategory.LEISURE: 0.15,
    DevelopmentCategory.RELATIONSHIPS: 0.25,
    DevelopmentCategory.CAREER_AND_FINANCES: 0.05
  };

  static double progressDelta(double current, Task task) {
    return 0.1;
  }

  static int levelDelta(int current, Task task) {
    return 1;
  }
}
