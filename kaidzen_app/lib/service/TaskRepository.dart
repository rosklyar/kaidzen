import 'package:kaidzen_app/service/KaizenState.dart';
import 'package:sqflite/sqflite.dart';
import '../assets/constants.dart';

import '../models/task.dart';

Map<String, Object?> toMap(Task task) {
  var map = <String, Object?>{
    columnTaskTitle: task.name,
    columnTaskStatus: task.status,
    columnTaskCategory: task.category.id,
  };
  if (task.id != -1) {
    map[columnTaskId] = task.id;
  }
  return map;
}

Task fromMap(Map<String, Object?> map) {
  return Task(
      map[columnTaskTitle] as String,
      DevelopmentCategory.values.firstWhere(
          (element) => element.id == (map[columnTaskCategory] as int)),
      id: map[columnTaskId] as int,
      status: map[columnTaskStatus] as String,
      subtasks: []);
}

class TaskRepository {
  Database? db;

  Future open() async {
    db = await KaizenDb.getDb();
  }

  Future<Task> insert(Task todo) async {
    if (db == null) {
      await open();
    }
    todo.id = await db!.insert(tableTask, toMap(todo));
    return todo;
  }

  Future<List<Task>> getAll() async {
    if (db == null) {
      await open();
    }
    List<Map> maps = await db!.query(tableTask, columns: [
      columnTaskId,
      columnTaskCategory,
      columnTaskStatus,
      columnTaskTitle
    ]);
    List<Task> tasks = maps
        .map((element) => fromMap(element as Map<String, Object?>))
        .toList();

    return tasks;
  }

  Future<Task?> getTask(int id) async {
    List<Map> maps = await db!.query(tableTask,
        columns: [columnTaskId, columnTaskStatus, columnTaskTitle],
        where: '$columnTaskId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int> delete(int? id) async {
    return await db!
        .delete(tableTask, where: '$columnTaskId = ?', whereArgs: [id]);
  }

  Future<int> update(Task task) async {
    return await db!.update(tableTask, toMap(task),
        where: '$columnTaskId = ?', whereArgs: [task.id]);
  }

  Future close() async => db!.close();
}
