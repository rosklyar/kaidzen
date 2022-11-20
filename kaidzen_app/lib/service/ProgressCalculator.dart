import 'package:kaidzen_app/assets/constants.dart';

import '../models/progress.dart';
import '../models/task.dart';

class ProgressCalculator {
  static const int MAX_POINTS_VALUE = 10000;
  static Progress progress(Progress progress, Task task) {
    if (task.category.id == DevelopmentCategory.NO_CATEGORY.id) {
      return progress;
    }

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
    100: 2400,
    101: 2400,
    102: 2400,
    103: 2400,
    104: 2500,
    105: 2400,
    106: 2400,
    107: 2500,
    108: 2400,
    109: 2500,
    110: 2400,
    111: 2500,
    112: 2400,
    113: 2500,
    114: 2500,
    115: 2500,
    116: 2400,
    117: 2500,
    118: 2500,
    119: 2500,
    120: 2500,
    121: 2500,
    122: 2500,
    123: 2500,
    124: 2600,
    125: 2500,
    126: 2500,
    127: 2500,
    128: 2600,
    129: 2500,
    130: 2500,
    131: 2600,
    132: 2500,
    133: 2600,
    134: 2500,
    135: 2600,
    136: 2500,
    137: 2600,
    138: 2600,
    139: 2600,
    140: 2500,
    141: 2600,
    142: 2600,
    143: 2600,
    144: 2600,
    145: 2600,
    146: 2600,
    147: 2600,
    148: 2600,
    149: 2600,
    150: 2600,
    151: 2600,
    152: 2600,
    153: 2700,
    154: 2600,
    155: 2600,
    156: 2700,
    157: 2600,
    158: 2600,
    159: 2700,
    160: 2600,
    161: 2700,
    162: 2600,
    163: 2700,
    164: 2700,
    165: 2600,
    166: 2700,
    167: 2700,
    168: 2600,
    169: 2700,
    170: 2700,
    171: 2700,
    172: 2700,
    173: 2600,
    174: 2700,
    175: 2700,
    176: 2700,
    177: 2700,
    178: 2700,
    179: 2700,
    180: 2800,
    181: 2700,
    182: 2700,
    183: 2700,
    184: 2700,
    185: 2800,
    186: 2700,
    187: 2700,
    188: 2700,
    189: 2800,
    190: 2700,
    191: 2800,
    192: 2700,
    193: 2800,
    194: 2700,
    195: 2800,
    196: 2700,
    197: 2800,
    198: 2800,
    199: 2700,
    200: 2800,
    201: 2800,
    202: 2700,
    203: 2800,
    204: 2800,
    205: 2800,
    206: 2800,
    207: 2700,
    208: 2800,
    209: 2800,
    210: 2800,
    211: 2800,
    212: 2800,
    213: 2800,
    214: 2800,
    215: 2800,
    216: 2900,
    217: 2800,
    218: 2800,
    219: 2800,
    220: 2800,
    221: 2800,
    222: 2900,
    223: 2800,
    224: 2800,
    225: 2900,
    226: 2800,
    227: 2900,
    228: 2800,
    229: 2800,
    230: 2900,
    231: 2800,
    232: 2900,
    233: 2800,
    234: 2900,
    235: 2900,
    236: 2800,
    237: 2900,
    238: 2900,
    239: 2800,
    240: 2900,
    241: 2900,
    242: 2800,
    243: 2900,
    244: 2900,
    245: 2900,
    246: 2900,
    247: 2900,
    248: 2900,
    249: 2800,
    250: 2900,
    251: 2900,
    252: 2900,
    253: 2900,
    254: 2900,
    255: 2900,
    256: 3000,
    257: 2900,
    258: 2900,
    259: 2900,
    260: 2900,
    261: 2900,
    262: 3000,
    263: 2900,
    264: 2900,
    265: 2900,
    266: 3000,
    267: 2900,
    268: 2900,
    269: 3000,
    270: 2900,
    271: 3000,
    272: 2900,
    273: 3000,
    274: 2900,
    275: 3000,
    276: 2900,
    277: 3000,
    278: 2900,
    279: 3000,
    280: 2900,
    281: 3000,
    282: 3000,
    283: 2900,
    284: 3000,
    285: 3000,
    286: 3000,
    287: 2900,
    288: 3000,
    289: 3000,
    290: 3000,
    291: 3000,
    292: 2900,
    293: 3000,
    294: 3000,
    295: 3000,
    296: 3000,
    297: 3000,
    298: 3000,
    299: 3000,
    300: 3000,
    301: 3000,
    302: 3000,
    303: 3000,
    304: 3000,
    305: 3100,
    306: 3000,
    307: 3000,
    308: 3000,
    309: 3000,
    310: 3100,
    311: 3000,
    312: 3000,
    313: 3000,
    314: 3100,
    315: 3000,
    316: 3000,
    317: 3100,
    318: 3000,
    319: 3000,
    320: 3100,
    321: 3000,
    322: 3100,
    323: 3000,
    324: 3100,
    325: 3000,
    326: 3100,
    327: 3000,
    328: 3100,
    329: 3000,
    330: 3100,
    331: 3100,
    332: 3000,
    333: 3100,
    334: 3100,
    335: 3000,
    336: 3100,
    337: 3100,
    338: 3100,
    339: 3000,
    340: 3100,
    341: 3100,
    342: 3100,
    343: 3100,
    344: 3100,
    345: 3000,
    346: 3100,
    347: 3100,
    348: 3100,
    349: 3100,
    350: 3100,
    351: 3100,
    352: 3100,
    353: 3100,
    354: 3100,
    355: 3100,
    356: 3100,
    357: 3100,
    358: 3200,
    359: 3100,
    360: 3100,
    361: 3100,
    362: 3100,
    363: 3100,
    364: 3200,
    365: 3100,
    366: 3100,
    367: 3100,
    368: 3200,
    369: 3100,
    370: 3100,
    371: 3200,
    372: 3100,
    373: 3100,
    374: 3200,
    375: 3100,
    376: 3100,
    377: 3200,
    378: 3100,
    379: 3200,
    380: 3100,
    381: 3200,
    382: 3100,
    383: 3200,
    384: 3100,
    385: 3200,
    386: 3200,
    387: 3100,
    388: 3200,
    389: 3100,
    390: 3200,
    391: 3200,
    392: 3100,
    393: 3200,
    394: 3200,
    395: 3200,
    396: 3100,
    397: 3200,
    398: 3200,
    399: 3200,
    400: 3100,
    401: 3200,
    402: 3200,
    403: 3200,
    404: 3200,
    405: 3200,
    406: 3200,
    407: 3200,
    408: 3200,
    409: 3100,
    410: 3200,
    411: 3200,
    412: 3200,
    413: 3200,
    414: 3200,
    415: 3300,
    416: 3200,
    417: 3200,
    418: 3200,
    419: 3200,
    420: 3200,
    421: 3200,
    422: 3200,
    423: 3200,
    424: 3300,
    425: 3200,
    426: 3200,
    427: 3200,
    428: 3300,
    429: 3200,
    430: 3200,
    431: 3200,
    432: 3300,
    433: 3200,
    434: 3200,
    435: 3300,
    436: 3200,
    437: 3200,
    438: 3300,
    439: 3200,
    440: 3300,
    441: 3200,
    442: 3300,
    443: 3200,
    444: 3200,
    445: 3300,
    446: 3200,
    447: 3300,
    448: 3300,
    449: 3200,
    450: 3300,
    451: 3200,
    452: 3300,
    453: 3200,
    454: 3300,
    455: 3300,
    456: 3200,
    457: 3300,
    458: 3300,
    459: 3200,
    460: 3300,
    461: 3300,
    462: 3300,
    463: 3200,
    464: 3300,
    465: 3300,
    466: 3300,
    467: 3300,
    468: 3200,
    469: 3300,
    470: 3300,
    471: 3300,
    472: 3300,
    473: 3300,
    474: 3300,
    475: 3300,
    476: 3200,
    477: 3300,
    478: 3300,
    479: 3300,
    480: 3300,
    481: 3300,
    482: 3300,
    483: 3300,
    484: 3300,
    485: 3400,
    486: 3300,
    487: 3300,
    488: 3300,
    489: 3300,
    490: 3300,
    491: 3300,
    492: 3300,
    493: 3400,
    494: 3300,
    495: 3300,
    496: 3300,
    497: 3300,
    498: 3400,
    499: 3300,
    500: 3300,
    501: 3300,
    502: 3400,
    503: 3300,
    504: 3300,
    505: 3400,
    506: 3300,
    507: 3300,
    508: 3400,
    509: 3300,
    510: 3300,
    511: 3400,
    512: 3300,
    513: 3400,
    514: 3300,
    515: 3400,
    516: 3300,
    517: 3400,
    518: 3300,
    519: 3400,
    520: 3300,
    521: 3400,
    522: 3300,
    523: 3400,
    524: 3300,
    525: 3400,
    526: 3400,
    527: 3300,
    528: 3400,
    529: 3300,
    530: 3400,
    531: 3400,
    532: 3300,
    533: 3400,
    534: 3400,
    535: 3400,
    536: 3300,
    537: 3400,
    538: 3400,
    539: 3400,
    540: 3300,
    541: 3400,
    542: 3400,
    543: 3400,
    544: 3400,
    545: 3300,
    546: 3400,
    547: 3400,
    548: 3400,
    549: 3400,
    550: 3400,
    551: 3400,
    552: 3400,
    553: 3400,
    554: 3400,
    555: 3400,
    556: 3400,
    557: 3400,
    558: 3400,
    559: 3400,
    560: 3400,
    561: 3400,
    562: 3400,
    563: 3400,
    564: 3400,
    565: 3400,
    566: 3400,
    567: 3400,
    568: 3400,
    569: 3400,
    570: 3500,
    571: 3400,
    572: 3400,
    573: 3400,
    574: 3400,
    575: 3400,
    576: 3500,
    577: 3400,
    578: 3400,
    579: 3400,
    580: 3500,
    581: 3400,
    582: 3400,
    583: 3500,
    584: 3400,
    585: 3400,
    586: 3500,
    587: 3400,
    588: 3400,
    589: 3500,
    590: 3400,
    591: 3400,
    592: 3500,
    593: 3400,
    594: 3500,
    595: 3400,
    596: 3500,
    597: 3400,
    598: 3400,
    599: 3500,
    600: 3400,
    601: 3500,
    602: 3500,
    603: 3400,
    604: 3500,
    605: 3400,
    606: 3500,
    607: 3400,
    608: 3500,
    609: 3500,
    610: 3400,
    611: 3500,
    612: 3400,
    613: 3500,
    614: 3500,
    615: 3400,
    616: 3500,
    617: 3500,
    618: 3400,
    619: 3500,
    620: 3500,
    621: 3500,
    622: 3400,
    623: 3500,
    624: 3500,
    625: 3500,
    626: 3400,
    627: 3500,
    628: 3500,
    629: 3500,
    630: 3500,
    631: 3500,
    632: 3500,
    633: 3400,
    634: 3500,
    635: 3500,
    636: 3500,
    637: 3500,
    638: 3500,
    639: 3500,
    640: 3500,
    641: 3500,
    642: 3500,
    643: 3500,
    644: 3500,
    645: 3500,
    646: 3500,
    647: 3500,
    648: 3500,
    649: 3500,
    650: 3500,
    651: 3500,
    652: 3500,
    653: 3500,
    654: 3500,
    655: 3500,
    656: 3500,
    657: 3600,
    658: 3500,
    659: 3500,
    660: 3500,
    661: 3500,
    662: 3500,
    663: 3600,
    664: 3500,
    665: 3500,
    666: 3500,
    667: 3600,
    668: 3500,
    669: 3500,
    670: 3500,
    671: 3600,
    672: 3500,
    673: 3500,
    674: 3500,
    675: 3600,
    676: 3500,
    677: 3500,
    678: 3600,
    679: 3500,
    680: 3600,
    681: 3500,
    682: 3500,
    683: 3600,
    684: 3500,
    685: 3600,
    686: 3500,
    687: 3600,
    688: 3500,
    689: 3500,
    690: 3600,
    691: 3500,
    692: 3600,
    693: 3500,
    694: 3600,
    695: 3500,
    696: 3600,
    697: 3600,
    698: 3500,
    699: 3600,
    700: 3500,
    701: 3600,
    702: 3500,
    703: 3600,
    704: 3600,
    705: 3500,
    706: 3600,
    707: 3600,
    708: 3500,
    709: 3600,
    710: 3600,
    711: 3500,
    712: 3600,
    713: 3600,
    714: 3500,
    715: 3600,
    716: 3600,
    717: 3600,
    718: 3500,
    719: 3600,
    720: 3600,
    721: 3600,
    722: 3600,
    723: 3500,
    724: 3600,
    725: 3600,
    726: 3600,
    727: 3600,
    728: 3600,
    729: 3600,
    730: 3500,
    731: 3600,
    732: 3600,
    733: 3600,
    734: 3600,
    735: 3600,
    736: 3600,
    737: 3600,
    738: 3600,
    739: 3600,
    740: 3600,
    741: 3600,
    742: 3600,
    743: 3600,
    744: 3600,
    745: 3600,
    746: 3600,
    747: 3600,
    748: 3600,
    749: 3600,
    750: 3600,
    751: 3600,
    752: 3600,
    753: 3600,
    754: 3600,
    755: 3700,
    756: 3600,
    757: 3600,
    758: 3600,
    759: 3600,
    760: 3600,
    761: 3700,
    762: 3600,
    763: 3600,
    764: 3600,
    765: 3600,
    766: 3700,
    767: 3600,
    768: 3600,
    769: 3600,
    770: 3700,
    771: 3600,
    772: 3600,
    773: 3600,
    774: 3700,
    775: 3600,
    776: 3600,
    777: 3700,
    778: 3600,
    779: 3600,
    780: 3700,
    781: 3600,
    782: 3700,
    783: 3600,
    784: 3600,
    785: 3700,
    786: 3600,
    787: 3700,
    788: 3600,
    789: 3600,
    790: 3700,
    791: 3600,
    792: 3700,
    793: 3600,
    794: 3700,
    795: 3600,
    796: 3700,
    797: 3600,
    798: 3700,
    799: 3600,
    800: 3700,
    801: 3700,
    802: 3600,
    803: 3700,
    804: 3600,
    805: 3700,
    806: 3600,
    807: 3700,
    808: 3700,
    809: 3600,
    810: 3700,
    811: 3700,
    812: 3600,
    813: 3700,
    814: 3700,
    815: 3600,
    816: 3700,
    817: 3700,
    818: 3600,
    819: 3700,
    820: 3700,
    821: 3700,
    822: 3600,
    823: 3700,
    824: 3700,
    825: 3700,
    826: 3600,
    827: 3700,
    828: 3700,
    829: 3700,
    830: 3700,
    831: 3600,
    832: 3700,
    833: 3700,
    834: 3700,
    835: 3700,
    836: 3700,
    837: 3700,
    838: 3600,
    839: 3700,
    840: 3700,
    841: 3700,
    842: 3700,
    843: 3700,
    844: 3700,
    845: 3700,
    846: 3700,
    847: 3700,
    848: 3700,
    849: 3700,
    850: 3700,
    851: 3700,
    852: 3700,
    853: 3700,
    854: 3700,
    855: 3700,
    856: 3700,
    857: 3700,
    858: 3700,
    859: 3700,
    860: 3700,
    861: 3700,
    862: 3700,
    863: 3700,
    864: 3800,
    865: 3700,
    866: 3700,
    867: 3700,
    868: 3700,
    869: 3700,
    870: 3700,
    871: 3800,
    872: 3700,
    873: 3700,
    874: 3700,
    875: 3700,
    876: 3800,
    877: 3700,
    878: 3700,
    879: 3700,
    880: 3700,
    881: 3800,
    882: 3700,
    883: 3700,
    884: 3800,
    885: 3700,
    886: 3700,
    887: 3700,
    888: 3800,
    889: 3700,
    890: 3700,
    891: 3800,
    892: 3700,
    893: 3700,
    894: 3800,
    895: 3700,
    896: 3800,
    897: 3700,
    898: 3700,
    899: 3800,
    900: 3700,
    901: 3800,
    902: 3700,
    903: 3800,
    904: 3700,
    905: 3700,
    906: 3800,
    907: 3700,
    908: 3800,
    909: 3700,
    910: 3800,
    911: 3700,
    912: 3800,
    913: 3700,
    914: 3800,
    915: 3700,
    916: 3800,
    917: 3800,
    918: 3700,
    919: 3800,
    920: 3700,
    921: 3800,
    922: 3800,
    923: 3700,
    924: 3800,
    925: 3700,
    926: 3800,
    927: 3800,
    928: 3700,
    929: 3800,
    930: 3800,
    931: 3700,
    932: 3800,
    933: 3800,
    934: 3700,
    935: 3800,
    936: 3800,
    937: 3700,
    938: 3800,
    939: 3800,
    940: 3800,
    941: 3700,
    942: 3800,
    943: 3800,
    944: 3800,
    945: 3800,
    946: 3700,
    947: 3800,
    948: 3800,
    949: 3800,
    950: 3800,
    951: 3700,
    952: 3800,
    953: 3800,
    954: 3800,
    955: 3800,
    956: 3800,
    957: 3800,
    958: 3700,
    959: 3800,
    960: 3800,
    961: 3800,
    962: 3800,
    963: 3800,
    964: 3800,
    965: 3800,
    966: 3800,
    967: 3800,
    968: 3800,
    969: 3800,
    970: 3800,
    971: 3800,
    972: 3800,
    973: 3800,
    974: 3800,
    975: 3800,
    976: 3800,
    977: 3800,
    978: 3800,
    979: 3800,
    980: 3800,
    981: 3800,
    982: 3800,
    983: 3800,
    984: 3800,
    985: 3800,
    986: 3800,
    987: 3900,
    988: 3800,
    989: 3800,
    990: 3800,
    991: 3800,
    992: 3800,
    993: 3800,
    994: 3900,
    995: 3800,
    996: 3800,
    997: 3800,
    998: 3800,
    999: 3900,
    1000: 3800
  };
}
