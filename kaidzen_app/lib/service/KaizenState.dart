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
const String columnTaskCategory = 'category_id';
const String columnTaskDifficulty = 'difficulty_id';

const String tableSubtaskMapping = 'taskToParent';
const String columnSubtaskId = '_task_id';
const String columnParentId = '_parent_id';

const String tableEvents = 'events';
const String columnEventtId = '_id';
const String columnEventType = 'type';
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
    return await openDatabase('kaizen.db', version: 9,
        onCreate: (Database db, int version) async {
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
            $columnTaskStatus integer not null)
          ''');

      await db.execute('''
            create table $tableSubtaskMapping ( 
            $columnSubtaskId integer not null, 
            $columnParentId integer not null,
            UNIQUE($columnSubtaskId, $columnParentId))
          ''');

      await db.execute('''
            create table $tableEvents ( 
            $columnEventtId integer primary key autoincrement, 
            $columnEventType integer not null,
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
                (0, 0, 'Rabbit', 'Create any task and get Rabbit origami', 'first.png', 0, false, 0.0),
                (1, 0, 'Elephant', 'Complete any task and get Elephant origami', 'second.png', 0, false, 0.0),
                (2, 0, 'Whale', 'Complete any 5 tasks and get Whale origami', 'third.png', 0, false, 0.0);
          ''');
    });
  }
}
