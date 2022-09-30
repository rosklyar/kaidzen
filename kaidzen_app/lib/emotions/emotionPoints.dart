import 'package:kaidzen_app/service/KaizenState.dart';

class EmotionPoints {
  final int id;
  final int points;
  final DateTime updateTs;

  EmotionPoints(this.id, this.points, this.updateTs);

  factory EmotionPoints.fromMap(Map<String, dynamic> map) {
    return EmotionPoints(
      map[columnEmotionId],
      map[columnEmotionPoints],
      DateTime.parse(map[columnEmotionUpdateTs]),
    );
  }

  static Map<String, Object?> toMap(EmotionPoints emotionPoints) {
    var map = <String, Object?>{
      columnEmotionId: emotionPoints.id,
      columnEmotionPoints: emotionPoints.points,
      columnEmotionUpdateTs: emotionPoints.updateTs.toString(),
    };
    return map;
  }
}
