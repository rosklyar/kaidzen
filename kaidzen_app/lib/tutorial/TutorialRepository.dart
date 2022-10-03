import 'package:flutter/cupertino.dart';
import 'package:kaidzen_app/service/KaizenState.dart';
import 'package:kaidzen_app/tutorial/tutorialProgress.dart';
import 'package:sqflite/sqflite.dart';

class TutorialRepository {
  Database? db;
  TutorialRepository();

  Future open() async {
    db = await KaizenDb.getDb();
  }

  Future close() async => db!.close();

  Future<Set<TutorialStep>> getAll() async {
    if (db == null) {
      await open();
    }
    List<Map> maps = await db!.query(tableTutorialSteps, columns: [
      columnTutorialStepId,
      columnTutorialUpdateTs,
    ]);
    Set<TutorialStep> steps = maps
        .map((element) => TutorialStep.fromMap(element as Map<String, Object?>))
        .toSet();
    return steps;
  }

  Future<void> addStep(TutorialStep step) async {
    if (db == null) {
      await open();
    }
    await db!.insert(tableTutorialSteps, TutorialStep.toMap(step));
  }
}
