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
      currentPoints -= daysPast * 2;
      var events = await eventsRepository.getEventsAfter(emotionPoints.updateTs);
      for (var event in events) {
        currentPoints += getPointsFromEvent(event);
      }
    }

    if (currentPoints > 70) {
      currentPoints = 70;
    } else if (currentPoints < 0) {
      currentPoints = 0;
    }
    await emotionPointsRepository.updateEmotionPoints(
        EmotionPoints(emotionPoints.id, currentPoints, now));
    refreshEmotionPoints();
    notifyListeners();
  }

  Future<EmotionPoints> updateEmotionPoints(Event event) async {
    int points = getPointsFromEvent(event);
    if (points > 0 || !tutorialState.tutorialCompleted()) {
      await emotionPointsRepository.updateEmotionPoints(EmotionPoints(
          emotionPoints.id, emotionPoints.points + points, DateTime.now()));
      await refreshEmotionPoints();
    }
    notifyListeners();
    return emotionPoints;
  }

  Future<void> refreshEmotionPoints() async {
    var newPoints = await emotionPointsRepository.getEmotionPoints();
    var newEmotion = getEmotionIdFromPoints(newPoints.points);
    var currentEmotion = getEmotionIdFromPoints(emotionPoints.points);
    if (newEmotion != currentEmotion) {
      await FirebaseAnalytics.instance.logEvent(
          name: AnalyticsEventType.emotion_changed.name,
          parameters: {"prev_id": currentEmotion.id, "cur_id": newEmotion.id});
    }
    emotionPoints = newPoints;
  }

  int getPointsFromEvent(Event event) {
    switch (event.type) {
      case EventType.taskCreated:
        return 2;
      case EventType.taskInProgress:
        return 1;
      case EventType.taskCompleted:
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
