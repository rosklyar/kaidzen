import 'package:sqflite/sqflite.dart';
import 'package:kaidzen_app/assets/constants.dart';
import '../models/progress.dart';
import '../models/task.dart';

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

const String tableAchievements = 'achievements';
const String columnAchievementId = '_id';
const String columnAchievementTitle = 'title';
const String columnAchievementProgress = 'progress';
const String columnAchievementSet = 'set_id';
const String columnAchievementIcon = 'icon_key';

class KaizenDb {
  static Database? _db;

  static Future<Database> getDb() async {
    _db ??= await _open();
    return _db!;
  }

  static Future<Database> _open() async {
    return await openDatabase('kaizen.db', version: 6,
        onCreate: (Database db, int version) async {
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
            $columnTaskStatus integer not null)
          ''');

      await db.execute('''
            create table $tableSubtaskMapping ( 
            $columnSubtaskId integer not null, 
            $columnParentId integer not null,
            UNIQUE($columnSubtaskId, $columnParentId))
          ''');

      await db.execute('''
            create table $tableAchievements ( 
            $columnAchievementId integer primary key autoincrement, 
            $columnAchievementTitle text not null,
            $columnAchievementProgress double not null,
            $columnAchievementSet integer not null,
            $columnAchievementIcon text not null)
          ''');

      await db.execute('''
            insert into $tableAchievements values
                (1, 'Crane', 1.0, 0, 'crane.png'),
                (2, 'Fortune teller', 0.5, 0, 'fortune_teller.png'),
                (3, 'Lotus Flower', 0.1, 0, 'lotus_flower.png'),
                (4, 'Masu box', 0.0, 0, 'masu_box.png'),
                (5, 'Jumping frog', 0.0, 0, 'jumping_frog.png'),
                (6, 'Butterfly', 0.0, 0, 'butterfly.png');
          ''');
    });
  }
}
