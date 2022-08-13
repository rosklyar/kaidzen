import 'package:kaidzen_app/achievements/event.dart';

import '../../achievement.dart';

class AnyFiveTasksCompletedAchievement extends Achievement {
  AnyFiveTasksCompletedAchievement({required super.eventsRepository});

  @override
  Future<bool> get isCompleted async => await progress >= 1.0;

  @override
  bool get isSecret => false;

  @override
  Future<double> get progress async {
    var eventsNumber =
        await eventsRepository.getEventsNumberByType(EventType.taskCompleted);
    return (eventsNumber / 5.0).clamp(0.0, 1.0);
  }

  @override
  String get description => "Complete any task and get Whale origami";

  @override
  String get iconName => "third.png";

  @override
  int get setId => 0;

  @override
  String get title => "Whale";

  @override
  int get id => 2;
}
