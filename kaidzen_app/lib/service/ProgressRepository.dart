import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/service/KaizenState.dart';
import 'package:sqflite/sqflite.dart';
import '../models/progress.dart';

class ProgressRepository {
  Database? db;
  ProgressRepository();

  Future open() async {
    db = await KaizenDb.getDb();
  }

  Future<Map<DevelopmentCategory, Progress>> getProgress() async {
    if (db == null) {
      await open();
    }
    final List<Map<String, dynamic>> maps = await db!.query(tableProgress);
    return Map.fromEntries(maps.map((map) {
      return MapEntry(
          DevelopmentCategory.values
              .firstWhere((category) => category.id == map[columnProgressId]),
          Progress(map[columnProgressLevel] as int, map[columnPoints] as int));
    }));
  }

  Future<void> updateProgress(
      DevelopmentCategory category, Progress progress) async {
    if (db == null) {
      await open();
    }
    await db!.update(tableProgress, toMap(category, progress),
        where: '$columnProgressId = ?', whereArgs: [category.id]);
  }

  Map<String, Object?> toMap(DevelopmentCategory category, Progress progress) {
    return <String, Object?>{
      columnProgressId: category.id,
      columnProgressLevel: progress.level,
      columnPoints: progress.points
    };
  }

  Future close() async => db!.close();
}
