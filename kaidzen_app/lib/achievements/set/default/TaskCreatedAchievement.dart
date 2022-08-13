import 'package:kaidzen_app/achievements/event.dart';

import '../../achievement.dart';

class TaskCreatedAchievement extends Achievement {
  TaskCreatedAchievement({required super.eventsRepository});

  @override
  Future<bool> get isCompleted async => await progress >= 1.0;

  @override
  bool get isSecret => false;

  @override
  Future<double> get progress async =>
      await eventsRepository.getLatestEventByType(EventType.taskCreated) != null
          ? 1.0
          : 0.0;

  @override
  String get description => "Create any task and get Rabbit origami";

  @override
  String get iconName => "first.png";

  @override
  int get setId => 0;

  @override
  String get title => "Rabbit";

  @override
  int get id => 0;
}
