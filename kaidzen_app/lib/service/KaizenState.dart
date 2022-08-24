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

const String columnEventTaskCategory = 'category';
const String columnEventTs = 'event_ts';

const String tableAchievements = 'achievements';
const String columnAchievementId = '_id';
const String columnAchievementState = 'state_id';
const String columnAchievementTitle = 'title';
const String columnAchievementDescription = 'description';
const String columnAchievementIconName = 'icon_name';
const String columnAchievementSetId = 'set_id';
const String columnAchievementIsSecret = 'is_secret';
const String columnAchievementProgress = 'progress';

class KaizenDb {
  static Database? _db;

  static Future<Database> getDb() async {
    _db ??= await _open();
    return _db!;
  }

  static Future<Database> _open() async {
    return await openDatabase('kaizen.db', version: 1,
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
                (${DevelopmentCategory.MIND.id}, 0, 0),
                (${DevelopmentCategory.HEALTH.id}, 0, 0),
                (${DevelopmentCategory.ENERGY.id}, 0, 0),
                (${DevelopmentCategory.RELATIONS.id}, 0, 0),
                (${DevelopmentCategory.WEALTH.id}, 0, 0);
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
            $columnEventTaskCategory integer not null,
            $columnEventTs datetime not null)
          ''');

    await db.execute('''
            create table $tableAchievements ( 
            $columnAchievementId integer primary key autoincrement, 
            $columnAchievementState integer not null,
            $columnAchievementTitle text not null,
            $columnAchievementDescription text not null,
            $columnAchievementIconName text not null,
            $columnAchievementSetId integer not null,
            $columnAchievementIsSecret boolean not null,
            $columnAchievementProgress double not null)
          ''');

    await db.execute('''
            insert into $tableAchievements values
                (0, 0, 'Rabbit', 'Create 5 tasks', 'rabbit.png', 0, false, 0.0),
                (1, 0, 'Elephant', 'Create 25 tasks', 'elephant.png', 0, false, 0.0),
                (2, 0, 'Whale', 'Create 100 tasks', 'whale.png', 0, false, 0.0),
                (3, 0, 'Fox', 'Complete 5 tasks in any sphere', 'fox.png', 0, false, 0.0),
                (4, 0, 'Duck', 'Complete 50 tasks in any sphere', 'duck.png', 0, false, 0.0),
                (5, 0, 'Pig', 'Complete 150 tasks in any sphere', 'pig.png', 0, false, 0.0),
                (6, 0, 'Frog', 'Complete 5 tasks in each sphere', 'frog.png', 0, false, 0.0),
                (7, 0, 'Parrot', 'Complete 10 tasks in each sphere', 'parrot.png', 0, false, 0.0),
                (8, 0, 'Swan', 'Complete 30 tasks in each sphere', 'swan.png', 0, false, 0.0);
          ''');
  }
}
