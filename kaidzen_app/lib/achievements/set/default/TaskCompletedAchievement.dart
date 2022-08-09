import 'package:kaidzen_app/achievements/event.dart';

import '../../achievement.dart';

class TaskCompletedAchievement extends Achievement {
  TaskCompletedAchievement({required super.eventsRepository});

  @override
  Future<bool> get isCompleted async => await progress >= 1.0;

  @override
  bool get isSecret => false;

  @override
  Future<double> get progress async =>
      await eventsRepository.getLatestEventByType(EventType.completed) != null
          ? 1.0
          : 0.0;

  @override
  String get description => "Complete any task and get Elephant origami";

  @override
  String get iconName => "second.png";

  @override
  int get setId => 0;

  @override
  String get title => "Elephant";
}
