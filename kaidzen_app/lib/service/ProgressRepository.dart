import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/service/KaizenState.dart';
import 'package:sqflite/sqflite.dart';
import '../models/progress.dart';

const String tableProgress = 'progress';
const String columnProgressId = '_id';
const String columnProgressCategory = 'category';
const String columnProgressLevel = 'level';
const String columnProgressValue = 'value';

class ProgressRepository {
  Database? db;
  ProgressRepository();

  Future open() async {
    db = await KaizenDb.getDb();
  }

  Future<Map<Category, Progress>> getProgress() async {
    if (db == null) {
      await open();
    }
    final List<Map<String, dynamic>> maps = await db!.query(tableProgress);
    return Map.fromEntries(maps.map((map) {
      return MapEntry(
          Category.values.firstWhere(
              (category) => category.name == map[columnProgressCategory]),
          Progress(map[columnProgressValue] as double,
              map[columnProgressLevel] as int));
    }));
  }

  Future<void> updateProgress(Category category, Progress progress) async {
    if (db == null) {
      await open();
    }
    await db!.update(tableProgress, toMap(category, progress),
        where: '$columnProgressCategory = ?', whereArgs: [category.name]);
  }

  Map<String, Object?> toMap(Category category, Progress progress) {
    return <String, Object?>{
      columnProgressCategory: category.name,
      columnProgressLevel: progress.level,
      columnProgressValue: progress.value
    };
  }

  Future close() async => db!.close();
}
