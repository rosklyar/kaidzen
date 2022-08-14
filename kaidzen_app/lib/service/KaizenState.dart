import 'package:sqflite/sqflite.dart';
import 'package:kaidzen_app/assets/constants.dart';

const String tableProgress = 'progress';
const String columnProgressId = '_id';
const String columnProgressLevel = 'level';
const String columnPoints = 'points';

const String tableTask = 'task';
const String columnTaskId = '_id';
const String columnTaskTitle = 'title';
const String columnTaskStatus = 'status';
const String columnTaskParentId = 'parent_id';
const String columnTaskCategory = 'category_id';
const String columnTaskDifficulty = 'difficulty_id';

const String tableSubtaskMapping = 'taskToParent';
const String columnSubtaskId = '_task_id';
const String columnParentId = '_parent_id';

const String tableEvents = 'events';
const String columnEventtId = '_id';
const String columnEventType = 'type';
const String columnEventTaskId = 'task_id';
const String columnEventTs = 'event_ts';

class KaizenDb {
  static Database? _db;

  static Future<Database> getDb() async {
    _db ??= await _open();
    return _db!;
  }

  static Future<Database> _open() async {
    return await openDatabase('kaizen.db', version: 8,
        onCreate: (Database db, int version) async {
      await initDb(db);
    }, onUpgrade: (db, oldVersion, newVersion) async {
      await db.execute('''
            drop table if exists $tableProgress;
            drop table if exists $tableTask;
            ''');
      await initDb(db);
    });
  }

  static Future<void> initDb(Database db) async {
    await db.execute('''
            create table $tableProgress (
            $columnProgressId integer primary key,
            $columnProgressLevel integer not null,
            $columnPoints integer not null)
          ''');
    await db.execute('''
            insert into $tableProgress values
                (${DevelopmentCategory.MIND.id}, 0, 0.0),
                (${DevelopmentCategory.HEALTH.id}, 0, 0.0),
                (${DevelopmentCategory.ENERGY.id}, 0, 0.0),
                (${DevelopmentCategory.RELATIONS.id}, 0, 0.0),
                (${DevelopmentCategory.WEALTH.id}, 0, 0.0);
          ''');

    await db.execute('''
          create table $tableTask (
          $columnTaskId integer primary key autoincrement,
          $columnTaskTitle text not null,
          $columnTaskCategory integer not null,
          $columnTaskDifficulty integer not null,
          $columnTaskStatus integer not null,
          $columnParentId integer)
        ''');

      await db.execute('''
            create table $tableEvents (
            $columnEventtId integer primary key autoincrement,
            $columnEventType integer not null,
            $columnEventTs datetime not null)
          ''');ÏÏ
  }
}
