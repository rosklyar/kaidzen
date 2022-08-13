import 'package:kaidzen_app/achievements/achievementStatus.dart';

class AchievementSnapshot {
  final int id;
  AchievementStatus status;
  final String title;
  final int setId;
  final String iconName;
  final String description;
  final bool isSecret;
  final double progress;

  AchievementSnapshot(
      {required this.id,
      required this.status,
      required this.title,
      required this.setId,
      required this.iconName,
      required this.description,
      required this.isSecret,
      required this.progress});

  void setStatus(AchievementStatus status) {
    this.status = status;
  }
}
