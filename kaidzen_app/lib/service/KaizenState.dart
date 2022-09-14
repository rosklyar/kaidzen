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

const String tablePeriodAchievementInfo = 'period_achievements_info';
const String columnPeriodAchievementInfoId = '_id';
const String columnPeriodAchievementInfoAchId = 'achievement_id';
const String columnPeriodAchievementInfoStartEventId = 'start_event_id';

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
                (${DevelopmentCategory.NO_CATEGORY.id}, 0, 0),
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
                (0, 0, 'Initiator', 'Create 5 tasks', 'Frog.svg', 0, false, 0.0),
                (1, 0, 'Composer', 'Create 25 tasks', 'Crane.svg', 0, false, 0.0),
                (2, 0, 'Writer', 'Create 100 tasks', 'Elephant.svg', 0, false, 0.0),
                (3, 0, 'Trainee', 'Complete 5 tasks in any sphere', 'Bird.svg', 0, false, 0.0),
                (4, 0, 'Master', 'Complete 50 tasks in any sphere', 'Dino.svg', 0, false, 0.0),
                (5, 0, 'Adept', 'Complete 150 tasks in any sphere', 'Dragon.svg', 0, false, 0.0),
                (6, 0, 'Toddler', 'Complete 5 tasks in each sphere', 'Fish.svg', 0, false, 0.0),
                (7, 0, 'Teenager', 'Complete 15 tasks in each sphere', 'Duck.svg', 0, false, 0.0),
                (8, 0, 'Adult', 'Complete 40 tasks in each sphere', 'Boat.svg', 0, false, 0.0),
                (9, 0, 'Sprinter', '4 weeks in a row close at least 5 tasks', 'Cat.svg', 0, false, 0.0),
                (10, 0, 'Stayer', '4 weeks in a row close at least 10 tasks', 'Unicorn.svg', 0, false, 0.0),
                (11, 0, 'Secret', 'Do smth secret', 'Dog.svg', 0, true, 0.0);
          ''');

    await db.execute('''
            create table $tablePeriodAchievementInfo ( 
            $columnPeriodAchievementInfoId integer primary key autoincrement, 
            $columnPeriodAchievementInfoAchId integer not null,
            $columnPeriodAchievementInfoStartEventId integer not null)
          ''');

    await db.execute('''
            insert into $tablePeriodAchievementInfo values
                (0, 9, -1),
                (1, 10, -1);
          ''');
  }
}
