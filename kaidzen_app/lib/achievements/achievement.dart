import 'package:kaidzen_app/achievements/EventsRepository.dart';

import 'achievementSnaphot.dart';

abstract class Achievement {
  final EventsRepository eventsRepository;

  Achievement({required this.eventsRepository});

  Future<double> get progress;
  Future<bool> get isCompleted;
  bool get isSecret;
  String get title;
  int get setId;
  String get iconName;
  String get description;

  Future<AchievementSnapshot> getSnapshot() async {
    return AchievementSnapshot(
      title: title,
      setId: setId,
      iconName: iconName,
      description: description,
      isSecret: isSecret,
      progress: await progress,
      isCompleted: await isCompleted,
    );
  }
}
