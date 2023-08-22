import 'package:sqflite/sqflite.dart';
import '../assets/constants.dart';

import '../models/habit.dart';
import '../models/task.dart';
import 'KaizenState.dart';

Map<String, Object?> toMap(Habit habit) {
  var map = <String, Object?>{
    columnHabitTitle: habit.task.name,
    columnHabitStatus: habit.task.status,
    columnHabitPriority: habit.task.priority,
    columnHabitParentId: habit.task.parent,
    columnHabitCategory: habit.task.category.id,
    columnHabitDifficulty: habit.task.difficulty.id,
    columnHabitDoneTs: habit.task.doneTs?.toString(),
    columnHabitInProgressTs: habit.task.inProgressTs?.toString(),
    columnHabitStage: habit.stage,
    columnHabitStageCount: habit.stageCount,
    columnHabitTotalCount: habit.totalCount,
    columnHabitType: habit.type,
    columnHabitLastCompleteTs: habit.lastCompleteTs?.toString()
  };
  if (habit.id != -1) {
    map[columnHabitId] = habit.id;
  }
  return map;
}

Habit fromMap(Map<String, Object?> map) {
  return Habit(
    Task(
        map[columnHabitTitle] as String,
        DevelopmentCategory.values.firstWhere(
            (element) => element.id == (map[columnHabitCategory] as int)),
        Difficulty.values.firstWhere(
            (element) => element.id == (map[columnHabitDifficulty] as int)),
        id: map[columnHabitId] as int,
        status: map[columnHabitStatus] as String,
        priority: map[columnHabitPriority] as int,
        parent: map[columnHabitParentId] as int?,
        doneTs: map[columnHabitDoneTs] != null
            ? DateTime.parse(map[columnHabitDoneTs] as String)
            : null,
        inProgressTs: map[columnHabitInProgressTs] != null
            ? DateTime.parse(map[columnHabitInProgressTs] as String)
            : null),
    map[columnHabitStage] as int,
    map[columnHabitStageCount] as int,
    map[columnHabitTotalCount] as int,
    map[columnHabitType] as int,
    id: map[columnHabitId] as int,
    lastCompleteTs: map[columnHabitLastCompleteTs] != null
        ? DateTime.parse(map[columnHabitLastCompleteTs] as String)
        : null
  );
}

class HabitRepository {
  Database? db;

  Future open() async {
    db = await KaizenDb.getDb();
  }

  Future<Habit> insert(Habit habit) async {
    if (db == null) {
      await open();
    }
    habit.id = await db!.insert(tableHabit, toMap(habit));
    return habit;
  }

  Future<List<Habit>> getAll() async {
    if (db == null) {
      await open();
    }
    List<Map> maps = await db!.query(tableHabit, columns: [
      columnHabitId,
      columnHabitCategory,
      columnHabitStatus,
      columnHabitPriority,
      columnHabitParentId,
      columnHabitTitle,
      columnHabitDifficulty,
      columnHabitDoneTs,
      columnHabitInProgressTs,
      columnHabitStage,
      columnHabitStageCount,
      columnHabitTotalCount,
      columnHabitType,
      columnHabitLastCompleteTs
    ]);
    List<Habit> habits = maps
        .map((element) => fromMap(element as Map<String, Object?>))
        .toList();
    return habits;
  }

  Future<Habit?> getHabit(int id) async {
    List<Map> maps = await db!.query(tableHabit,
        columns: [
          columnHabitId,
          columnHabitStatus,
          columnHabitPriority,
          columnHabitTitle,
          columnHabitParentId,
          columnHabitDoneTs,
          columnHabitInProgressTs,
          columnHabitStage,
          columnHabitStageCount,
          columnHabitTotalCount,
          columnHabitType,
          columnHabitLastCompleteTs
        ],
        where: '$columnHabitId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int> delete(int? id) async {
    return await db!.delete(tableHabit,
        where: '$columnHabitId = ? OR $columnHabitParentId = ?',
        whereArgs: [id, id]);
  }

  Future<int> update(Habit habit) async {
    return await db!.update(tableHabit, toMap(habit),
        where: '$columnHabitId = ?', whereArgs: [habit.id]);
  }

  Future close() async => db!.close();
}
