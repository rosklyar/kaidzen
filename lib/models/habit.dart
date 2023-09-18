import 'package:equatable/equatable.dart';
import 'package:kaidzen_app/models/task.dart';

class Habit extends Equatable {
  int? id;
  Task task;
  int stage;
  int stageCount;
  int totalCount;
  int type;
  DateTime? lastCompleteTs;
  bool shouldAnimate = false;

  Habit(this.task, this.stage, this.stageCount, this.totalCount, this.type,
      {this.id, this.lastCompleteTs});

  @override
  String toString() {
    return 'id: $id, task: ${task.toString()}, stage: $stage, stageCount: $stageCount, totalCount: $totalCount, type: $type, lastCompleteTs: $lastCompleteTs';
  }

  @override
  List<Object?> get props => [
        id,
        task,
        stage,
        stageCount,
        totalCount,
        type,
        lastCompleteTs,
      ];
}
