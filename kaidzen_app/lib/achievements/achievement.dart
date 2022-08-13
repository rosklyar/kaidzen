import 'package:kaidzen_app/achievements/EventsRepository.dart';
import 'package:kaidzen_app/achievements/achievementStatus.dart';

import 'achievementSnaphot.dart';

abstract class Achievement {
  final EventsRepository eventsRepository;

  Achievement({required this.eventsRepository});

  Future<double> get progress;
  Future<bool> get isCompleted;
  bool get isSecret;
  String get title;
  int get setId;
  int get id;
  String get iconName;
  String get description;

  Future<AchievementSnapshot> getSnapshot(AchievementState state) async {
    return AchievementSnapshot(
        id: state.id,
        status: state.status,
        title: title,
        setId: setId,
        iconName: iconName,
        description: description,
        isSecret: isSecret,
        progress: await progress);
  }
}
