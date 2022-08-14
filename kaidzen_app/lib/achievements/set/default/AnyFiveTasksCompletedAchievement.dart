import 'package:kaidzen_app/achievements/event.dart';

import '../../achievement.dart';

class AnyFiveTasksCompletedAchievement extends Achievement {
  AnyFiveTasksCompletedAchievement({required super.eventsRepository});

  @override
  Future<double> get progress async {
    var eventsNumber =
        await eventsRepository.getEventsNumberByType(EventType.taskCompleted);
    return (eventsNumber / 5.0).clamp(0.0, 1.0);
  }

  @override
  int get id => 2;
}
