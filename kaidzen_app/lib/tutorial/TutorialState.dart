import 'package:flutter/cupertino.dart';
import 'package:kaidzen_app/tutorial/TutorialRepository.dart';
import 'package:kaidzen_app/tutorial/tutorialProgress.dart';

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
    tutorialRepository.addStep(step);
    loadAll();
  }

  TutorialProgress getTutorialProgress() {
    return tutorialProgress;
  }
}
