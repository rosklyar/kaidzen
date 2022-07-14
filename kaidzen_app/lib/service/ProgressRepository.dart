import 'package:kaidzen_app/assets/constants.dart';
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
    db = await openDatabase('kaizen.db', version: 3,
        onCreate: (Database db, int version) async {
      await db.execute('''
            create table $tableProgress ( 
            $columnProgressId integer primary key, 
            $columnProgressCategory varchar(40) not null unique,
            $columnProgressLevel integer not null,
            $columnProgressValue double not null)
          ''');
      await db.execute('''
            insert into $tableProgress values
                (1, ${Category.CAREER_AND_FINANCES.name}, 1, 0.0),
                (2, ${Category.HEALTH.name}, 2, 0.0),
                (3, ${Category.PERSONAL_DEVELOPMENT.name}, 3, 0.0),
                (4, ${Category.RELATIONSHIPS.name}, 4, 0.0),
                (5, ${Category.LEISURE.name}, 5, 0.0);
          ''');
    });
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
}
