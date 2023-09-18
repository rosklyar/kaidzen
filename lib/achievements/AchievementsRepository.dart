import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/service/KaizenState.dart';
import 'package:sqflite/sqflite.dart';

class AchievementsRepository {
  Database? db;
  AchievementsRepository();

  Future open() async {
    db = await KaizenDb.getDb();
  }

  Future close() async => db!.close();

  Future<int> updateAchievementSnapshot(
      AchievementSnapshot achievementSnapshot) async {
    if (db == null) {
      await open();
    }
    return await db!.update(
        tableAchievements, AchievementSnapshot.toMap(achievementSnapshot),
        where: '$columnAchievementId = ?', whereArgs: [achievementSnapshot.id]);
  }

  Future<List<AchievementSnapshot>> getAchievementSnapshots() async {
    if (db == null) {
      await open();
    }
    final List<Map<String, dynamic>> maps = await db!.query(tableAchievements);
    return maps.map((map) => AchievementSnapshot.fromMap(map)).toList();
  }
}
