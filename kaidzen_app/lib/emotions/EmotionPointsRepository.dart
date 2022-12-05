import 'package:flutter/cupertino.dart';
import 'package:kaidzen_app/service/KaizenState.dart';
import 'package:sqflite/sqflite.dart';

import 'emotionPoints.dart';

class EmotionPointsRepository {
  Database? db;
  EmotionPointsRepository();

  Future open() async {
    db = await KaizenDb.getDb();
  }

  Future close() async => db!.close();

  Future<EmotionPoints> getEmotionPoints() async {
    if (db == null) {
      await open();
    }
    final List<Map<String, dynamic>> maps =
        await db!.rawQuery('SELECT * FROM $tableEmotionPoints');
    return EmotionPoints.fromMap(maps.first);
  }

  Future<void> updateEmotionPoints(EmotionPoints emotionPoints) async {
    if (db == null) {
      await open();
    }
    await db!.update(tableEmotionPoints, EmotionPoints.toMap(emotionPoints));
  }
}
