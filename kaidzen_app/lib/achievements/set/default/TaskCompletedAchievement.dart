import 'package:kaidzen_app/achievements/event.dart';

import '../../achievement.dart';

class TaskCompletedAchievement extends Achievement {
  TaskCompletedAchievement({required super.eventsRepository});

  @override
  Future<double> get progress async =>
      await eventsRepository.getLatestEventByType(EventType.taskCompleted) !=
              null
          ? 1.0
          : 0.0;

  @override
  int get id => 1;
}
