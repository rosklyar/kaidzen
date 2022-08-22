import 'package:kaidzen_app/achievements/event.dart';

import '../../achievement.dart';

class TaskCompletedInAllSpheresAchievement extends Achievement {
  final int numberOfTasks;
  final int achievementId;
  TaskCompletedInAllSpheresAchievement(this.achievementId, this.numberOfTasks,
      {required super.eventsRepository});

  @override
  Future<double> get progress async {
    var value = await eventsRepository
            .getMinEventsNumberAmongAllCategories(EventType.taskCompleted) /
        numberOfTasks;
    return value.clamp(0.0, 1.0);
  }

  @override
  int get id => achievementId;
}
