import 'package:flutter/foundation.dart';
import 'package:kaidzen_app/assets/constants.dart';

import '../models/habit.dart';
import '../models/progress.dart';
import '../models/task.dart';

class ProgressCalculator {
  static const int MAX_POINTS_VALUE = 10000;

  static Progress progress(Progress progress, Task task) {
    if (noProgressFilter(task)) {
      return progress;
    }

    var nextLevelCap = _levelToPointsMap[progress.level + 1]!;
    var totalPoints =
        getEarnedPoints(task) + adjustPoints(progress, nextLevelCap);
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

  static Progress habitProgress(Progress progress, Habit habit) {
    if (noProgressHabitFilter(habit)) {
      return progress;
    }

    var nextLevelCap = _levelToPointsMap[progress.level + 1]!;
    var totalPoints =
        getEarnedHabitPoints(habit) + adjustPoints(progress, nextLevelCap);

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

  static bool noProgressFilter(Task task) {
    return task.category.id == DevelopmentCategory.NO_CATEGORY.id ||
        (task.status == Status.DONE && task.doneTs != null) ||
        (task.status == Status.DOING && task.inProgressTs != null);
  }

  static bool noProgressHabitFilter(Habit habit) {
    return habit.task.category.id == DevelopmentCategory.NO_CATEGORY.id ||
        (habit.task.status == Status.DONE && habit.task.doneTs != null);
  }

  static int getEarnedPoints(Task task) {
    if (task.status == Status.DOING) {
      return 5;
    } else if (task.status == Status.TODO) {
      return 10;
    }
    return _difficultyPointsMap[task.difficulty]!;
  }

  static int getEarnedHabitPoints(Habit habit) {
    if (habit.task.status == Status.DONE) {
      return _difficultyPointsMap[habit.task.difficulty]! * 3;
    }
    if (habit.task.status == Status.DOING &&
        habit.stage == 1 &&
        habit.stageCount == 0) {
      return 5;
    }
    if (habit.task.status == Status.TODO) {
      return 10;
    }
    return _difficultyPointsMap[Difficulty.EASY]!;
  }

  static double getLevelFraction(
      DevelopmentCategory category, Progress progress) {
    var cap = _levelToPointsMap[progress.level + 1]!;
    return adjustPoints(progress, cap) / cap;
  }

  static int adjustPoints(Progress progress, int cap) => progress.points % cap;

  static int getMaxLevelPoints(int level) {
    return _levelToPointsMap.containsKey(level)
        ? _levelToPointsMap[level]!
        : MAX_POINTS_VALUE;
  }

  static final Map<Difficulty, int> _difficultyPointsMap = {
    Difficulty.EASY: 15,
    Difficulty.MEDIUM: 30,
    Difficulty.HARD: 60
  };

  static final Map<int, int> _levelToPointsMap = {
    1: 60,
    2: 60,
    3: 75,
    4: 75,
    5: 60,
    6: 60,
    7: 60,
    8: 90,
    9: 60,
    10: 60,
    11: 120,
    12: 90,
    13: 120,
    14: 90,
    15: 120,
    16: 120,
    17: 120,
    18: 120,
    19: 60,
    20: 120,
    21: 120,
    22: 120,
    23: 120,
    24: 120,
    25: 120,
    26: 210,
    27: 150,
    28: 225,
    29: 225,
    30: 225,
    31: 225,
    32: 225,
    33: 150,
    34: 225,
    35: 225,
    36: 225,
    37: 225,
    38: 255,
    39: 180,
    40: 270,
    41: 180,
    42: 270,
    43: 180,
    44: 270,
    45: 180,
    46: 270,
    47: 270,
    48: 180,
    49: 270,
    50: 180,
    51: 270,
    52: 270,
    53: 180,
    54: 270,
    55: 270,
    56: 180,
    57: 270,
    58: 270,
    59: 270,
    60: 240,
    61: 240,
    62: 240,
    63: 240,
    64: 240,
    65: 240,
    66: 240,
    67: 240,
    68: 240,
    69: 240,
    70: 240,
    71: 360,
    72: 240,
    73: 240,
    74: 240,
    75: 240,
    76: 240,
    77: 240,
    78: 240,
    79: 360,
    80: 240,
    81: 240,
    82: 240,
    83: 240,
    84: 240,
    85: 360,
    86: 240,
    87: 240,
    88: 240,
    89: 240,
    90: 360,
    91: 240,
    92: 240,
    93: 240,
    94: 360,
    95: 240,
    96: 240,
    97: 240,
    98: 240,
    99: 360,
    100: 240,
    101: 240,
    102: 360,
    103: 240,
    104: 240,
    105: 240,
    106: 360,
    107: 240,
    108: 240,
    109: 360,
    110: 240,
    111: 240,
    112: 240,
    113: 360,
    114: 240,
    115: 240,
    116: 360,
    117: 240,
    118: 240,
    119: 360,
    120: 240,
    121: 240,
    122: 360,
    123: 240,
    124: 240,
    125: 360,
    126: 240,
    127: 360,
    128: 240,
    129: 240,
    130: 360,
    131: 240,
    132: 240,
    133: 360,
    134: 240,
    135: 360,
    136: 240,
    137: 240,
    138: 360,
    139: 240,
    140: 360,
    141: 240,
    142: 360,
    143: 240,
    144: 240,
    145: 360,
    146: 240,
    147: 360,
    148: 240,
    149: 360,
    150: 240,
    151: 360,
    152: 240,
    153: 240,
    154: 360,
    155: 240,
    156: 360,
    157: 240,
    158: 360,
    159: 240,
    160: 360,
    161: 240,
    162: 360,
    163: 240,
    164: 360,
    165: 240,
    166: 360,
    167: 240,
    168: 360,
    169: 240,
    170: 360,
    171: 240,
    172: 360,
    173: 240,
    174: 360,
    175: 240,
    176: 360,
    177: 240,
    178: 360,
    179: 240,
    180: 360,
    181: 360,
    182: 240,
    183: 360,
    184: 240,
    185: 360,
    186: 240,
    187: 360,
    188: 240,
    189: 360,
    190: 360,
    191: 240,
    192: 360,
    193: 240,
    194: 360,
    195: 240,
    196: 360,
    197: 360,
    198: 240,
    199: 360,
    200: 240,
    201: 360,
    202: 360,
    203: 240,
    204: 360,
    205: 240,
    206: 360,
    207: 360,
    208: 240,
    209: 360,
    210: 360,
    211: 240,
    212: 360,
    213: 240,
    214: 360,
    215: 360,
    216: 240,
    217: 360,
    218: 360,
    219: 240,
    220: 360,
    221: 360,
    222: 240,
    223: 360,
    224: 240,
    225: 360,
    226: 360,
    227: 240,
    228: 360,
    229: 360,
    230: 240,
    231: 360,
    232: 360,
    233: 240,
    234: 360,
    235: 360,
    236: 360,
    237: 240,
    238: 360,
    239: 360,
    240: 240,
    241: 360,
    242: 360,
    243: 240,
    244: 360,
    245: 360,
    246: 240,
    247: 360,
    248: 360,
    249: 360,
    250: 240,
    251: 360,
    252: 360,
    253: 240,
    254: 360,
    255: 360,
    256: 360,
    257: 240,
    258: 360,
    259: 360,
    260: 360,
    261: 240,
    262: 360,
    263: 360,
    264: 360,
    265: 240,
    266: 360,
    267: 360,
    268: 360,
    269: 240,
    270: 360,
    271: 360,
    272: 360,
    273: 240,
    274: 360,
    275: 360,
    276: 360,
    277: 240,
    278: 360,
    279: 360,
    280: 360,
    281: 240,
    282: 360,
    283: 360,
    284: 360,
    285: 360,
    286: 240,
    287: 360,
    288: 360,
    289: 360,
    290: 360,
    291: 240,
    292: 360,
    293: 360,
    294: 360,
    295: 360,
    296: 240,
    297: 360,
    298: 360,
    299: 360,
    300: 360,
    301: 240,
    302: 360,
    303: 360,
    304: 360,
    305: 360,
    306: 360,
    307: 240,
    308: 360,
    309: 360,
    310: 360,
    311: 360,
    312: 360,
    313: 240,
    314: 360,
    315: 360,
    316: 360,
    317: 360,
    318: 360,
    319: 360,
    320: 240,
    321: 360,
    322: 360,
    323: 360,
    324: 360,
    325: 360,
    326: 360,
    327: 240,
    328: 360,
    329: 360,
    330: 360,
    331: 360,
    332: 360,
    333: 360,
    334: 240,
    335: 360,
    336: 360,
    337: 360,
    338: 360,
    339: 360,
    340: 360,
    341: 360,
    342: 360,
    343: 240,
    344: 360,
    345: 360,
    346: 360,
    347: 360,
    348: 360,
    349: 360,
    350: 360,
    351: 360,
    352: 360,
    353: 240,
    354: 360,
    355: 360,
    356: 360,
    357: 360,
    358: 360,
    359: 360,
    360: 360,
    361: 360,
    362: 360,
    363: 360,
    364: 360,
    365: 240,
    366: 360,
    367: 360,
    368: 360,
    369: 360,
    370: 360,
    371: 360,
    372: 360,
    373: 360,
    374: 360,
    375: 360,
    376: 360,
    377: 360,
    378: 360,
    379: 360,
    380: 360,
    381: 360,
    382: 240,
    383: 360,
    384: 360,
    385: 360,
    386: 360,
    387: 360,
    388: 360,
    389: 360,
    390: 360,
    391: 360,
    392: 360,
    393: 360,
    394: 360,
    395: 360,
    396: 360,
    397: 360,
    398: 360,
    399: 360,
    400: 360,
    401: 360,
    402: 360,
    403: 360,
    404: 360,
    405: 360,
    406: 360,
    407: 360,
    408: 360,
    409: 360,
    410: 360,
    411: 360,
    412: 360,
    413: 360,
    414: 360,
    415: 360,
    416: 360,
    417: 360,
    418: 360,
    419: 360,
    420: 360,
    421: 360,
    422: 360,
    423: 360,
    424: 360,
    425: 360,
    426: 360,
    427: 360,
    428: 360,
    429: 360,
    430: 360,
    431: 360,
    432: 360,
    433: 360,
    434: 360,
    435: 360,
    436: 360,
    437: 360,
    438: 360,
    439: 360,
    440: 360,
    441: 360,
    442: 480,
    443: 360,
    444: 360,
    445: 360,
    446: 360,
    447: 360,
    448: 360,
    449: 360,
    450: 360,
    451: 360,
    452: 360,
    453: 360,
    454: 360,
    455: 360,
    456: 360,
    457: 360,
    458: 360,
    459: 360,
    460: 480,
    461: 360,
    462: 360,
    463: 360,
    464: 360,
    465: 360,
    466: 360,
    467: 360,
    468: 360,
    469: 360,
    470: 360,
    471: 360,
    472: 360,
    473: 360,
    474: 480,
    475: 360,
    476: 360,
    477: 360,
    478: 360,
    479: 360,
    480: 360,
    481: 360,
    482: 360,
    483: 360,
    484: 480,
    485: 360,
    486: 360,
    487: 360,
    488: 360,
    489: 360,
    490: 360,
    491: 360,
    492: 360,
    493: 360,
    494: 480,
    495: 360,
    496: 360,
    497: 360,
    498: 360,
    499: 360,
    500: 360,
    501: 360,
    502: 360,
    503: 480,
    504: 360,
    505: 360,
    506: 360,
    507: 360,
    508: 360,
    509: 360,
    510: 480,
    511: 360,
    512: 360,
    513: 360,
    514: 360,
    515: 360,
    516: 360,
    517: 360,
    518: 480,
    519: 360,
    520: 360,
    521: 360,
    522: 360,
    523: 360,
    524: 360,
    525: 480,
    526: 360,
    527: 360,
    528: 360,
    529: 360,
    530: 360,
    531: 480,
    532: 360,
    533: 360,
    534: 360,
    535: 360,
    536: 360,
    537: 360,
    538: 480,
    539: 360,
    540: 360,
    541: 360,
    542: 360,
    543: 480,
    544: 360,
    545: 360,
    546: 360,
    547: 360,
    548: 360,
    549: 480,
    550: 360,
    551: 360,
    552: 360,
    553: 360,
    554: 360,
    555: 480,
    556: 360,
    557: 360,
    558: 360,
    559: 360,
    560: 480,
    561: 360,
    562: 360,
    563: 360,
    564: 360,
    565: 480,
    566: 360,
    567: 360,
    568: 360,
    569: 360,
    570: 480,
    571: 360,
    572: 360,
    573: 360,
    574: 360,
    575: 480,
    576: 360,
    577: 360,
    578: 360,
    579: 360,
    580: 480,
    581: 360,
    582: 360,
    583: 360,
    584: 360,
    585: 480,
    586: 360,
    587: 360,
    588: 360,
    589: 480,
    590: 360,
    591: 360,
    592: 360,
    593: 360,
    594: 480,
    595: 360,
    596: 360,
    597: 360,
    598: 480,
    599: 360,
    600: 360,
    601: 360,
    602: 480,
    603: 360,
    604: 360,
    605: 360,
    606: 480,
    607: 360,
    608: 360,
    609: 360,
    610: 480,
    611: 360,
    612: 360,
    613: 360,
    614: 360,
    615: 480,
    616: 360,
    617: 360,
    618: 480,
    619: 360,
    620: 360,
    621: 360,
    622: 480,
    623: 360,
    624: 360,
    625: 360,
    626: 480,
    627: 360,
    628: 360,
    629: 360,
    630: 480,
    631: 360,
    632: 360,
    633: 360,
    634: 480,
    635: 360,
    636: 360,
    637: 480,
    638: 360,
    639: 360,
    640: 360,
    641: 480,
    642: 360,
    643: 360,
    644: 360,
    645: 480,
    646: 360,
    647: 360,
    648: 480,
    649: 360,
    650: 360,
    651: 360,
    652: 480,
    653: 360,
    654: 360,
    655: 480,
    656: 360,
    657: 360,
    658: 360,
    659: 480,
    660: 360,
    661: 360,
    662: 480,
    663: 360,
    664: 360,
    665: 480,
    666: 360,
    667: 360,
    668: 480,
    669: 360,
    670: 360,
    671: 360,
    672: 480,
    673: 360,
    674: 360,
    675: 480,
    676: 360,
    677: 360,
    678: 480,
    679: 360,
    680: 360,
    681: 480,
    682: 360,
    683: 360,
    684: 480,
    685: 360,
    686: 360,
    687: 360,
    688: 480,
    689: 360,
    690: 360,
    691: 480,
    692: 360,
    693: 360,
    694: 480,
    695: 360,
    696: 360,
    697: 480,
    698: 360,
    699: 360,
    700: 480,
    701: 360,
    702: 360,
    703: 480,
    704: 360,
    705: 360,
    706: 480,
    707: 360,
    708: 360,
    709: 480,
    710: 360,
    711: 480,
    712: 360,
    713: 360,
    714: 480,
    715: 360,
    716: 360,
    717: 480,
    718: 360,
    719: 360,
    720: 480,
    721: 360,
    722: 360,
    723: 480,
    724: 360,
    725: 360,
    726: 480,
    727: 360,
    728: 480,
    729: 360,
    730: 360,
    731: 480,
    732: 360,
    733: 360,
    734: 480,
    735: 360,
    736: 360,
    737: 480,
    738: 360,
    739: 480,
    740: 360,
    741: 360,
    742: 480,
    743: 360,
    744: 360,
    745: 480,
    746: 360,
    747: 480,
    748: 360,
    749: 360,
    750: 480,
    751: 360,
    752: 480,
    753: 360,
    754: 360,
    755: 480,
    756: 360,
    757: 360,
    758: 480,
    759: 360,
    760: 480,
    761: 360,
    762: 360,
    763: 480,
    764: 360,
    765: 480,
    766: 360,
    767: 360,
    768: 480,
    769: 360,
    770: 480,
    771: 360,
    772: 360,
    773: 480,
    774: 360,
    775: 480,
    776: 360,
    777: 360,
    778: 480,
    779: 360,
    780: 480,
    781: 360,
    782: 360,
    783: 480,
    784: 360,
    785: 480,
    786: 360,
    787: 480,
    788: 360,
    789: 360,
    790: 480,
    791: 360,
    792: 480,
    793: 360,
    794: 360,
    795: 480,
    796: 360,
    797: 480,
    798: 360,
    799: 480,
    800: 360,
    801: 360,
    802: 480,
    803: 360,
    804: 480,
    805: 360,
    806: 480,
    807: 360,
    808: 360,
    809: 480,
    810: 360,
    811: 480,
    812: 360,
    813: 480,
    814: 360,
    815: 360,
    816: 480,
    817: 360,
    818: 480,
    819: 360,
    820: 480,
    821: 360,
    822: 480,
    823: 360,
    824: 360,
    825: 480,
    826: 360,
    827: 480,
    828: 360,
    829: 480,
    830: 360,
    831: 480,
    832: 360,
    833: 480,
    834: 360,
    835: 360,
    836: 480,
    837: 360,
    838: 480,
    839: 360,
    840: 480,
    841: 360,
    842: 480,
    843: 360,
    844: 480,
    845: 360,
    846: 480,
    847: 360,
    848: 360,
    849: 480,
    850: 360,
    851: 480,
    852: 360,
    853: 480,
    854: 360,
    855: 480,
    856: 360,
    857: 480,
    858: 360,
    859: 480,
    860: 360,
    861: 480,
    862: 360,
    863: 480,
    864: 360,
    865: 360,
    866: 480,
    867: 360,
    868: 480,
    869: 360,
    870: 480,
    871: 360,
    872: 480,
    873: 360,
    874: 480,
    875: 360,
    876: 480,
    877: 360,
    878: 480,
    879: 360,
    880: 480,
    881: 360,
    882: 480,
    883: 360,
    884: 480,
    885: 360,
    886: 480,
    887: 360,
    888: 480,
    889: 360,
    890: 480,
    891: 360,
    892: 480,
    893: 360,
    894: 480,
    895: 360,
    896: 480,
    897: 360,
    898: 480,
    899: 360,
    900: 480,
    901: 360,
    902: 480,
    903: 360,
    904: 480,
    905: 360,
    906: 480,
    907: 360,
    908: 480,
    909: 360,
    910: 480,
    911: 360,
    912: 480,
    913: 360,
    914: 480,
    915: 480,
    916: 360,
    917: 480,
    918: 360,
    919: 480,
    920: 360,
    921: 480,
    922: 360,
    923: 480,
    924: 360,
    925: 480,
    926: 360,
    927: 480,
    928: 360,
    929: 480,
    930: 360,
    931: 480,
    932: 360,
    933: 480,
    934: 480,
    935: 360,
    936: 480,
    937: 360,
    938: 480,
    939: 360,
    940: 480,
    941: 360,
    942: 480,
    943: 360,
    944: 480,
    945: 360,
    946: 480,
    947: 480,
    948: 360,
    949: 480,
    950: 360,
    951: 480,
    952: 360,
    953: 480,
    954: 360,
    955: 480,
    956: 360,
    957: 480,
    958: 480,
    959: 360,
    960: 480,
    961: 360,
    962: 480,
    963: 360,
    964: 480,
    965: 360,
    966: 480,
    967: 480,
    968: 360,
    969: 480,
    970: 360,
    971: 480,
    972: 360,
    973: 480,
    974: 360,
    975: 480,
    976: 480,
    977: 360,
    978: 480,
    979: 360,
    980: 480,
    981: 360,
    982: 480,
    983: 480,
    984: 360,
    985: 480,
    986: 360,
    987: 480,
    988: 360,
    989: 480,
    990: 480,
    991: 360,
    992: 480,
    993: 360,
    994: 480,
    995: 480,
    996: 360,
    997: 480,
    998: 360,
    999: 480
  };
}
