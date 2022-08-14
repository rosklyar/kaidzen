import 'package:kaidzen_app/achievements/event.dart';

import '../../achievement.dart';

class TaskCreatedAchievement extends Achievement {
  TaskCreatedAchievement({required super.eventsRepository});

  @override
  Future<double> get progress async =>
      await eventsRepository.getLatestEventByType(EventType.taskCreated) != null
          ? 1.0
          : 0.0;

  @override
  int get id => 0;
}
