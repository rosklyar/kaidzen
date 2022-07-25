import 'package:sqflite/sqflite.dart';
import 'package:kaidzen_app/assets/constants.dart';
import '../models/progress.dart';
import '../models/task.dart';

const String tableProgress = 'progress';
const String columnProgressId = '_id';
const String columnProgressLevel = 'level';
const String columnProgressValue = 'value';

const String tableTask = 'task';
const String columnTaskId = '_id';
const String columnTaskTitle = 'title';
const String columnTaskStatus = 'status';
const String columnTaskCategory = 'category_id';
const String columnTaskDifficulty = 'difficulty_id';

const String tableSubtaskMapping = 'taskToParent';
const String columnSubtaskId = '_task_id';
const String columnParentId = '_parent_id';

class KaizenDb {
  static Database? _db;

  static Future<Database> getDb() async {
    _db ??= await _open();
    return _db!;
  }

  static Future<Database> _open() async {
    return await openDatabase('kaizen.db', version: 5,
        onCreate: (Database db, int version) async {
      await db.execute('''
            create table $tableProgress ( 
            $columnProgressId integer primary key,
            $columnProgressLevel integer not null,
            $columnProgressValue double not null)
          ''');
      await db.execute('''
            insert into $tableProgress values
                (${DevelopmentCategory.CAREER_AND_FINANCES.id}, 1, 0.0),
                (${DevelopmentCategory.HEALTH.id}, 2, 0.0),
                (${DevelopmentCategory.PERSONAL_DEVELOPMENT.id}, 3, 0.0),
                (${DevelopmentCategory.RELATIONSHIPS.id}, 4, 0.0),
                (${DevelopmentCategory.LEISURE.id}, 5, 0.0);
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
    });
  }
}
