import 'package:kaidzen_app/models/achievement.dart';
import 'package:kaidzen_app/service/KaizenState.dart';
import 'package:sqflite/sqflite.dart';

class AchievementsRepository {
  Database? db;
  AchievementsRepository();

  Future open() async {
    db = await KaizenDb.getDb();
  }

  Future close() async => db!.close();

  Future<List<Achievement>> getAchievements([int setId = 0]) async {
    if (db == null) {
      await open();
    }
    final List<Map<String, dynamic>> maps = await db!.query(tableAchievements,
        where: '$columnAchievementSet = ?', whereArgs: [setId]);
    return maps.map((map) => Achievement.fromMap(map)).toList();
  }
}
