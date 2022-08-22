import 'package:kaidzen_app/achievements/event.dart';

import '../../achievement.dart';

class TaskCreatedAchievement extends Achievement {
  final int numberOfTasks;
  final int achievementId;
  TaskCreatedAchievement(this.achievementId, this.numberOfTasks,
      {required super.eventsRepository});

  @override
  Future<double> get progress async {
    var value =
        await eventsRepository.getEventsNumberByType(EventType.taskCreated) /
            numberOfTasks;
    return value.clamp(0.0, 1.0);
  }

  @override
  int get id => achievementId;
}
