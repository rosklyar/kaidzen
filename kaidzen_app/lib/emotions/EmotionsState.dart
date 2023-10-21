import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:kaidzen_app/achievements/EventsRepository.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/emotions/EmotionPointsRepository.dart';
import 'package:kaidzen_app/emotions/emotionPoints.dart';
import 'package:kaidzen_app/tutorial/TutorialState.dart';

import '../service/AnalyticsService.dart';

class EmotionsState extends ChangeNotifier {
  EmotionPointsRepository emotionPointsRepository;
  EventsRepository eventsRepository;
  TutorialState tutorialState;
  late EmotionPoints emotionPoints;

  EmotionsState(
      this.eventsRepository, this.emotionPointsRepository, this.tutorialState);

  loadAll() async {
    emotionPoints = await emotionPointsRepository.getEmotionPoints();

    int currentPoints = emotionPoints.points;
    final lastUpdateTs = emotionPoints.updateTs;
    final now = DateTime.now();
    final daysPast = now.difference(lastUpdateTs).inDays;

    if (tutorialState.tutorialCompleted()) {
      currentPoints -= daysPast * 5;
      var events =
          await eventsRepository.getEventsAfter(emotionPoints.updateTs);
      for (var event in events) {
        currentPoints += getPointsFromEvent(event);
      }
    }

    if (currentPoints > 70) {
      currentPoints = 70;
    } else if (currentPoints < 0) {
      currentPoints = 0;
    }
    var newPoints = EmotionPoints(emotionPoints.id, currentPoints, now);
    await emotionPointsRepository.updateEmotionPoints(newPoints);
    triggerEmotionEvent(emotionPoints.points, newPoints.points);
    emotionPoints = newPoints;
    notifyListeners();
  }

  Future<void> triggerEmotionEvent(int oldPoints, int newPoints) async {
    var newEmotion = getEmotionIdFromPoints(newPoints);
    var currentEmotion = getEmotionIdFromPoints(oldPoints);
    if (newEmotion != currentEmotion) {
      await FirebaseAnalytics.instance.logEvent(
          name: AnalyticsEventType.emotion_changed.name,
          parameters: {"prev_id": currentEmotion.id, "cur_id": newEmotion.id});
    }
  }

  int getPointsFromEvent(Event event) {
    switch (event.type) {
      case EventType.taskCreated:
        return 2;
      case EventType.habitCreated:
        return 2;
      case EventType.taskInProgress:
        return 1;
      case EventType.habitInProgress:
        return 1;
      case EventType.taskCompleted:
        return 3;
      case EventType.habitCompleted:
        return 3;
      case EventType.habitTracked:
        return 3;
      default:
        return 0;
    }
  }

  Emotion getEmotionIdFromPoints(int points) {
    if (points <= 10) {
      return Emotion.VERY_SAD;
    } else if (points > 10 && points <= 20) {
      return Emotion.SAD;
    } else if (points > 20 && points <= 30) {
      return Emotion.A_BIT_SAD;
    } else if (points > 30 && points <= 40) {
      return Emotion.REGULAR;
    } else if (points > 40 && points <= 50) {
      return Emotion.A_BIT_HAPPY;
    } else if (points > 50 && points <= 60) {
      return Emotion.HAPPY;
    } else if (points > 60) {
      return Emotion.VERY_HAPPY;
    }

    return Emotion.REGULAR;
  }

  Emotion getCurrentEmotion() {
    return getEmotionIdFromPoints(emotionPoints.points);
  }
}
