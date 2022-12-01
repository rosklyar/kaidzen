import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
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
const String columnTaskPriority = '_priority';
const String columnTaskParentId = 'parent_id';
const String columnTaskCategory = 'category_id';
const String columnTaskDifficulty = 'difficulty_id';
const String columnTaskDoneTs = 'done_ts';

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

const String tableEmotionPoints = 'emotionPoints';
const String columnEmotionId = '_id';
const String columnEmotionPoints = 'points';
const String columnEmotionUpdateTs = 'update_ts';

const String tableTutorialSteps = 'tutorialSteps';
const String columnTutorialStepId = 'step_id';
const String columnTutorialUpdateTs = 'update_ts';

class KaizenDb {
  static Database? _db;

  static Future<Database> getDb() async {
    _db ??= await _open();
    debugPrint(_db?.path);
    return _db!;
  }

  static Future<Database> _open() async {
    List<String> initialScripts = [
      '''
            create table $tableProgress (
            $columnProgressId integer primary key,
            $columnProgressLevel integer not null,
            $columnPoints integer not null)
          ''',
      '''
            insert into $tableProgress values
                (${DevelopmentCategory.NO_CATEGORY.id}, 0, 0),
                (${DevelopmentCategory.MIND.id}, 0, 0),
                (${DevelopmentCategory.HEALTH.id}, 0, 0),
                (${DevelopmentCategory.ENERGY.id}, 0, 0),
                (${DevelopmentCategory.RELATIONS.id}, 0, 0),
                (${DevelopmentCategory.WEALTH.id}, 0, 0);
          ''',
      '''
          create table $tableTask (
          $columnTaskId integer primary key autoincrement,
          $columnTaskTitle text not null,
          $columnTaskPriority integer not null,
          $columnTaskCategory integer not null,
          $columnTaskDifficulty integer not null,
          $columnTaskStatus text not null,
          $columnTaskParentId integer,
          $columnTaskDoneTs datetime default null)
        ''',
      '''
            insert into $tableTask values
                (0, 'Help it to hatch out!', 0, 0, 0, '${Status.TODO}', null, null),
                (1, 'Press the arrow to move this goal to "Doing", and then to "Done"', 0, 0, 0, '${Status.TODO}', 0, null),
                (2, 'Read the "Philosophy" concept (find it in the Menu)', 0, 0, 0, '${Status.TODO}', 0, null),
                (3, 'Clear your mind by adding goals (press “+” button)', 0, 0, 0, '${Status.TODO}', 0, null);
          ''',
      '''
            create table $tableEvents ( 
            $columnEventtId integer primary key autoincrement, 
            $columnEventType integer not null,
            $columnEventTaskCategory integer not null,
            $columnEventTs datetime not null)
          ''',
      '''
            create table $tableAchievements ( 
            $columnAchievementId integer primary key autoincrement, 
            $columnAchievementState integer not null,
            $columnAchievementTitle text not null,
            $columnAchievementDescription text not null,
            $columnAchievementIconName text not null,
            $columnAchievementSetId integer not null,
            $columnAchievementIsSecret boolean not null,
            $columnAchievementProgress double not null)
          ''',
      '''
            insert into $tableAchievements values
                (0, 0, 'Initiator', 'Create 25 goals', 'Fish.svg', 0, 0, 0.0),
                (1, 0, 'Composer', 'Create 50 goals', 'Duck.svg', 0, 0, 0.0),
                (2, 0, 'Writer', 'Create 100 goals', 'Seahorse.svg', 0, 0, 0.0),
                (3, 0, 'Beginner', 'Complete 5 goals in one sphere', 'Hedgehog.svg', 0, 0, 0.0),
                (4, 0, 'Skilled', 'Complete 50 goals in one sphere', 'Cat.svg', 0, 0, 0.0),
                (5, 0, 'Expert', 'Complete 150 goals in one sphere', 'Dog.svg', 0, 0, 0.0),
                (6, 0, 'Toddler', 'Complete 5 goals in each sphere', 'Owl.svg', 0, 0, 0.0),
                (7, 0, 'Teenager', 'Complete 15 goals in each sphere', 'Flamingo.svg', 0, 0, 0.0),
                (8, 0, 'Adult', 'Complete 40 goals in each sphere', 'Bird.svg', 0, 0, 0.0),
                (9, 0, 'Sprinter', '2 weeks in a row close at least 5 goals', 'Elephant.svg', 0, 0, 0.0),
                (10, 0, 'Half marathoner', '3 weeks in a row close at least 10 goals', 'Unicorn.svg', 0, 0, 0.0),
                (11, 0, 'Marathoner', '4 weeks in a row close at least 20 goals', 'Dragon.svg', 0, 0, 0.0);
          ''',
      '''
            create table $tablePeriodAchievementInfo ( 
            $columnPeriodAchievementInfoId integer primary key autoincrement, 
            $columnPeriodAchievementInfoAchId integer not null,
            $columnPeriodAchievementInfoStartEventId integer not null)
          ''',
      '''
            insert into $tablePeriodAchievementInfo values
                (0, 9, -1),
                (1, 10, -1),
                (2, 11, -1);
          ''',
      '''
            create table $tableEmotionPoints ( 
            $columnEmotionId integer primary key, 
            $columnEmotionPoints integer not null,
            $columnEmotionUpdateTs datetime not null)
          ''',
      '''
            insert into $tableEmotionPoints values
                (1, 40, '${DateTime.now().toString()}');
          ''',
      '''
            create table $tableTutorialSteps ( 
            $columnTutorialStepId integer primary key, 
            $columnTutorialUpdateTs datetime not null)
          '''
    ];

    List<String> migrationScripts = [];

    return await openDatabase(join(await getDatabasesPath(), 'sticky_goals.db'),
        version: migrationScripts.length + 1,
        onCreate: (Database db, int version) async {
      for (var script in initialScripts) {
        log("Initial scripts [" + script + "]");
        await db.execute(script);
      }
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      for (var i = oldVersion - 1; i < newVersion - 1; i++) {
        log("Migration script [" + migrationScripts[i] + "]");
        await db.execute(migrationScripts[i]);
      }
    });
  }
}
