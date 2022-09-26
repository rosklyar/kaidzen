import 'package:flutter/cupertino.dart';
import 'package:kaidzen_app/achievements/EventsRepository.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/emotions/EmotionPointsRepository.dart';
import 'package:kaidzen_app/emotions/emotionPoints.dart';

class EmotionsState extends ChangeNotifier {
  EmotionPointsRepository emotionPointsRepository;
  EventsRepository eventsRepository;
  EmotionPoints emotionPoints = EmotionPoints(1, 0, DateTime.now());

  EmotionsState(this.eventsRepository, this.emotionPointsRepository);

  loadAll() async {
    debugPrint('Init points');
    emotionPoints = await emotionPointsRepository.getEmotionPoints();

    int currentPoints = emotionPoints.points;
    final lastUpdateTs = emotionPoints.updateTs;
    final now = DateTime.now();
    final daysPast = now.difference(lastUpdateTs).inDays;
    currentPoints -= daysPast * 2;

    var events = await eventsRepository.getEventsAfter(emotionPoints.updateTs);
    for (var event in events) {
      currentPoints += getPointFromEvent(event);
    }
    if (currentPoints > 70) {
      currentPoints = 70;
    } else if (currentPoints < 0) {
      currentPoints = 0;
    }
    await emotionPointsRepository.updateEmotionPoints(
        EmotionPoints(emotionPoints.id, currentPoints, now));
    emotionPoints = await emotionPointsRepository.getEmotionPoints();
    debugPrint('Current points $currentPoints');
    notifyListeners();
  }

  Future<EmotionPoints> updateEmotionPoints(Event event) async {
    int points = getPointFromEvent(event);
    debugPrint('updating points $points');
    if (points != 0) {
      await emotionPointsRepository.updateEmotionPoints(EmotionPoints(
          emotionPoints.id, emotionPoints.points + points, DateTime.now()));
      emotionPoints = await emotionPointsRepository.getEmotionPoints();
    }
    notifyListeners();
    return emotionPoints;
  }

  int getPointFromEvent(Event event) {
    switch (event.type) {
      case EventType.taskCreated:
        return 5;
      case EventType.taskInProgress:
        return 5;
      case EventType.taskCompleted:
        return 5;
      default:
        return 0;
    }
  }
}
