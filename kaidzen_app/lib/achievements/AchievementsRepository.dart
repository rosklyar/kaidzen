import 'package:kaidzen_app/service/KaizenState.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kaidzen_app/achievements/achievementStatus.dart';

class AchievementsRepository {
  Database? db;
  AchievementsRepository();

  Future open() async {
    db = await KaizenDb.getDb();
  }

  Future close() async => db!.close();

  Future<int> updateAchievementState(AchievementState achievementState) async {
    if (db == null) {
      await open();
    }
    return await db!.update(
        tableAchievements, AchievementState.toMap(achievementState),
        where: '$columnAchievementId = ?', whereArgs: [achievementState.id]);
  }

  Future<List<AchievementState>> getAchievementStates() async {
    if (db == null) {
      await open();
    }
    final List<Map<String, dynamic>> maps = await db!.query(tableAchievements);
    return maps.map((map) => AchievementState.fromMap(map)).toList();
  }
}
