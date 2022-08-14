import '../service/KaizenState.dart';

class AchievementSnapshot {
  final int id;
  final AchievementStatus status;
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

  static Map<String, Object?> toMap(AchievementSnapshot achievementSnapshot) {
    return {
      columnAchievementId: achievementSnapshot.id,
      columnAchievementState: achievementSnapshot.status.id,
      columnAchievementTitle: achievementSnapshot.title,
      columnAchievementSetId: achievementSnapshot.setId,
      columnAchievementIconName: achievementSnapshot.iconName,
      columnAchievementDescription: achievementSnapshot.description,
      columnAchievementIsSecret: achievementSnapshot.isSecret,
      columnAchievementProgress: achievementSnapshot.progress,
    };
  }

  static AchievementSnapshot fromMap(Map<String, dynamic> map) {
    return AchievementSnapshot(
      id: map[columnAchievementId] as int,
      status: AchievementStatus.values[map[columnAchievementState] as int],
      title: map[columnAchievementTitle] as String,
      setId: map[columnAchievementSetId] as int,
      iconName: map[columnAchievementIconName] as String,
      description: map[columnAchievementDescription] as String,
      isSecret: map[columnAchievementIsSecret] == 1,
      progress: map[columnAchievementProgress] as double,
    );
  }

  static Future<AchievementSnapshot> updateProgress(
      AchievementSnapshot snaphot, Future<double> progress) {
    return progress.then((double progress) {
      return AchievementSnapshot(
        id: snaphot.id,
        status:
            snaphot.status == AchievementStatus.notCompleted && progress >= 1.0
                ? AchievementStatus.completed
                : snaphot.status,
        title: snaphot.title,
        setId: snaphot.setId,
        iconName: snaphot.iconName,
        description: snaphot.description,
        isSecret: snaphot.isSecret,
        progress: progress,
      );
    });
  }

  static AchievementSnapshot updateStatus(
      AchievementSnapshot achievement, AchievementStatus status) {
    return AchievementSnapshot(
      id: achievement.id,
      status: status,
      title: achievement.title,
      setId: achievement.setId,
      iconName: achievement.iconName,
      description: achievement.description,
      isSecret: achievement.isSecret,
      progress: achievement.progress,
    );
  }
}

enum AchievementStatus {
  notCompleted(0),
  completed(1),
  completedAndShown(2);

  const AchievementStatus(this.id);
  final int id;
}
