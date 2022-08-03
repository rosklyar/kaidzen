import 'package:kaidzen_app/assets/constants.dart';

import '../models/progress.dart';
import '../models/task.dart';

class ProgressCalculator {
  static Progress progress(Progress progress, Task task) {
    var nextLevelCap = _levelToPointsMap[progress.level + 1]!;
    var totalPoints = _difficultyPointsMap[task.difficulty]! + progress.points;
    if (totalPoints >= nextLevelCap) {
      return Progress(
        progress.level + 1,
        totalPoints - nextLevelCap,
      );
    } else {
      return Progress(
        progress.level,
        totalPoints,
      );
    }
  }

  static double getLevelFraction(
      DevelopmentCategory category, Progress progress) {
    var cap = _levelToPointsMap[progress.level + 1]!;
    return progress.points / cap;
  }

  static final Map<Difficulty, int> _difficultyPointsMap = {
    Difficulty.EASY: 15,
    Difficulty.MEDIUM: 30,
    Difficulty.HARD: 60
  };

  static final Map<int, int> _levelToPointsMap = {
    1: 100,
    2: 200,
    3: 270,
    4: 360,
    5: 370,
    6: 450,
    7: 500,
    8: 525,
    9: 600,
    10: 600,
    11: 825,
    12: 800,
    13: 800,
    14: 900,
    15: 800,
    16: 900,
    17: 900,
    18: 900,
    19: 1000,
    20: 900,
    21: 1000,
    22: 1000,
    23: 1000,
    24: 1000,
    25: 1000,
    26: 1800,
    27: 1900,
    28: 1800,
    29: 1900,
    30: 1900,
    31: 1900,
    32: 1900,
    33: 1900,
    34: 2000,
    35: 1900,
    36: 2000,
    37: 2000,
    38: 1900,
    39: 2000,
    40: 2000,
    41: 2100,
    42: 2000,
    43: 2000,
    44: 2100,
    45: 2000,
    46: 2100,
    47: 2000,
    48: 2100,
    49: 2100,
    50: 2100,
    51: 2100,
    52: 2100,
    53: 2100,
    54: 2200,
    55: 2100,
    56: 2100,
    57: 2200,
    58: 2100,
    59: 2200,
    60: 2200,
    61: 2200,
    62: 2200,
    63: 2100,
    64: 2200,
    65: 2300,
    66: 2200,
    67: 2200,
    68: 2200,
    69: 2300,
    70: 2200,
    71: 2300,
    72: 2200,
    73: 2300,
    74: 2200,
    75: 2300,
    76: 2300,
    77: 2300,
    78: 2300,
    79: 2300,
    80: 2300,
    81: 2300,
    82: 2300,
    83: 2300,
    84: 2300,
    85: 2400,
    86: 2300,
    87: 2300,
    88: 2400,
    89: 2300,
    90: 2400,
    91: 2400,
    92: 2300,
    93: 2400,
    94: 2400,
    95: 2400,
    96: 2400,
    97: 2400,
    98: 2400,
    99: 2400,
    100: 2400
  };
}
