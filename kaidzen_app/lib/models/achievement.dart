import 'package:kaidzen_app/service/KaizenState.dart';

class Achievement {
  final int id;
  final String title;
  final int setId;
  final double progress;
  final String iconName;
  Achievement({
    required this.id,
    required this.title,
    required this.setId,
    required this.progress,
    required this.iconName,
  });

  static Achievement fromMap(Map<String, Object?> map) {
    return Achievement(
      id: map[columnAchievementId] as int,
      title: map[columnAchievementTitle] as String,
      setId: map[columnAchievementSet] as int,
      progress: map[columnAchievementProgress] as double,
      iconName: map[columnAchievementIcon] as String,
    );
  }
}
