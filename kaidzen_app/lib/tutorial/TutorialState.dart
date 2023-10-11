import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:kaidzen_app/tutorial/TutorialRepository.dart';
import 'package:kaidzen_app/tutorial/tutorialProgress.dart';

import '../service/AnalyticsService.dart';

class TutorialState extends ChangeNotifier {
  TutorialRepository tutorialRepository;

  TutorialProgress tutorialProgress;

  TutorialState(this.tutorialRepository)
      : tutorialProgress = TutorialProgress(Set.identity());

  loadAll() async {
    tutorialProgress = TutorialProgress(await tutorialRepository.getAll());
    notifyListeners();
  }

  Future<void> updateTutorialState(TutorialStep step) async {
    await FirebaseAnalytics.instance.logEvent(
              name: AnalyticsEventType.tutorial_step_completed.name,
              parameters: {"id": step.stepId.toString()});
    tutorialRepository.addStep(step);
    loadAll();
  }

  TutorialProgress getTutorialProgress() {
    return tutorialProgress;
  }

  bool tutorialCompleted() {
    return tutorialProgress.completedStepsCount() == 3;
  }
}
