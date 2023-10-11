import 'package:kaidzen_app/service/KaizenState.dart';

class TutorialProgress {
  Set<TutorialStep> completedSteps;

  TutorialProgress(this.completedSteps);

  addStep(TutorialStep step) {
    completedSteps.add(step);
  }

  int completedStepsCount() {
    return completedSteps.length;
  }
}

class TutorialStep {
  final int stepId;
  final DateTime updateTs;

  TutorialStep(this.stepId, this.updateTs);

  factory TutorialStep.fromMap(Map<String, dynamic> map) {
    return TutorialStep(
      map[columnTutorialStepId],
      DateTime.parse(map[columnTutorialUpdateTs]),
    );
  }

  static Map<String, Object?> toMap(TutorialStep tutorialProgress) {
    var map = <String, Object?>{
      columnTutorialStepId: tutorialProgress.stepId,
      columnTutorialUpdateTs: tutorialProgress.updateTs.toString(),
    };
    return map;
  }
}
