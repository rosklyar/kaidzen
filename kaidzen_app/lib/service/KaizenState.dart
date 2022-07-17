import 'package:sqflite/sqflite.dart';
import 'package:kaidzen_app/assets/constants.dart';
import '../models/progress.dart';
import '../models/task.dart';

const String tableProgress = 'progress';
const String columnProgressId = '_id';
const String columnProgressCategory = 'category';
const String columnProgressLevel = 'level';
const String columnProgressValue = 'value';

const String tableTask = 'task';
const String columnTaskId = '_id';
const String columnTaskTitle = 'title';
const String columnTaskStatus = 'status';

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
            $columnProgressCategory varchar(40) not null unique,
            $columnProgressLevel integer not null,
            $columnProgressValue double not null)
          ''');
      await db.execute('''
            insert into $tableProgress values
                (1, '${Category.CAREER_AND_FINANCES.name}', 1, 0.0),
                (2, '${Category.HEALTH.name}', 2, 0.0),
                (3, '${Category.PERSONAL_DEVELOPMENT.name}', 3, 0.0),
                (4, '${Category.RELATIONSHIPS.name}', 4, 0.0),
                (5, '${Category.LEISURE.name}', 5, 0.0);
          ''');

      await db.execute('''
            create table $tableTask ( 
            $columnTaskId integer primary key autoincrement, 
            $columnTaskTitle text not null,
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
