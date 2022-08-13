import 'package:kaidzen_app/service/KaizenState.dart';

class AchievementState {
  final int id;
  final AchievementStatus status;

  AchievementState(this.id, this.status);

  static Map<String, Object?> toMap(AchievementState achievementStatus) {
    var map = <String, Object?>{
      columnAchievementId: achievementStatus.id,
      columnAchievementState: achievementStatus.status.id,
    };
    return map;
  }

  static AchievementState fromMap(Map<String, dynamic> map) {
    return AchievementState(
      map[columnAchievementId] as int,
      AchievementStatus.values
          .firstWhere((element) => element.id == map[columnAchievementState]),
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
