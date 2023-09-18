import 'dart:developer';

import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/service/KaizenState.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kaidzen_app/achievements/event.dart';

class EventsRepository {
  Database? db;
  EventsRepository();

  Future open() async {
    db = await KaizenDb.getDb();
  }

  Future close() async => db!.close();

  Future<List<Event>> getEvents(int tsFrom, int tsTo) async {
    if (db == null) {
      await open();
    }
    final List<Map<String, dynamic>> maps = await db!.query(tableEvents,
        where: '$columnEventTs >= ? AND $columnEventTs <= ?',
        whereArgs: [tsFrom, tsTo]);
    return maps.map((map) => Event.fromMap(map)).toList();
  }

  Future<Event?> getLatestEventByType(EventType eventType) async {
    if (db == null) {
      await open();
    }
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT * FROM $tableEvents WHERE $columnEventType = ${eventType.id} ORDER BY $columnEventTs DESC LIMIT 1');
    return maps.isEmpty ? null : Event.fromMap(maps.first);
  }

  Future<int> getMaxEventsNumberAmongAllCategories(EventType eventType) async {
    if (db == null) {
      await open();
    }
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT COUNT(*) FROM $tableEvents WHERE $columnEventType = ${eventType.id} GROUP BY $columnEventTaskCategory ORDER BY COUNT(*) DESC LIMIT 1');
    return maps.isNotEmpty ? maps.first['COUNT(*)'] as int : 0;
  }

  Future<int> getEventsNumberByType(EventType eventType) async {
    if (db == null) {
      await open();
    }
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT COUNT(*) FROM $tableEvents WHERE $columnEventType = ${eventType.id}');
    return maps.isNotEmpty ? maps.first['COUNT(*)'] as int : 0;
  }

  Future<int> getEventsCountByCategory(
      EventType eventType, int category) async {
    if (db == null) {
      await open();
    }
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT COUNT(*) FROM $tableEvents WHERE $columnEventType = ${eventType.id} AND $columnEventTaskCategory = $category');
    return maps.isNotEmpty ? maps.first['COUNT(*)'] as int : 0;
  }

  Future<int> addEvent(Event event) async {
    if (db == null) {
      await open();
    }
    var createdId = await db!.insert(tableEvents, Event.toMap(event));
    await startPeriodAchievementsIfNeeded(event.type, createdId);
    return createdId;
  }

  Future<int> startPeriodAchievementsIfNeeded(
      EventType eventType, int eventId) async {
    if (db == null) {
      await open();
    }
    if (eventType == EventType.taskCompleted) {
      return await db!.update(tablePeriodAchievementInfo,
          {columnPeriodAchievementInfoStartEventId: eventId},
          where: '$columnPeriodAchievementInfoStartEventId = ?',
          whereArgs: [-1]);
    }
    return 0;
  }

  Future<PeriodAchievementInfo> getPeriodAchievementInfo(
      int achievementId) async {
    if (db == null) {
      await open();
    }
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT * FROM $tablePeriodAchievementInfo WHERE $columnPeriodAchievementInfoAchId = $achievementId');
    return PeriodAchievementInfo.fromMap(maps.first);
  }

  Future<List<PeriodAchievementInfo>> getAllPeriodAchievementInfo() async {
    if (db == null) {
      await open();
    }
    List<Map> maps = await db!.query(tablePeriodAchievementInfo, columns: [
      columnPeriodAchievementInfoId,
      columnPeriodAchievementInfoAchId,
      columnPeriodAchievementInfoStartEventId
    ]);
    List<PeriodAchievementInfo> infos = maps
        .map((element) =>
            PeriodAchievementInfo.fromMap(element as Map<String, Object?>))
        .toList();
    return infos;
  }

  Future<Event> getEventById(int eventId) async {
    if (db == null) {
      await open();
    }
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT * FROM $tableEvents WHERE $columnEventtId = $eventId');
    return Event.fromMap(maps.first);
  }

  Future<List<Event>> getEventsAfter(DateTime ts) async {
    if (db == null) {
      await open();
    }
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT * FROM $tableEvents WHERE $columnEventTs > \'$ts\'');
    return maps.isNotEmpty ? maps.map((e) => Event.fromMap(maps.first)).toList() : List.empty();
  }

  Future<int> getNumberOfTasksCompletedInPeriod(
      DateTime tsFrom, DateTime tsTo) async {
    if (db == null) {
      await open();
    }
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT COUNT(*) FROM $tableEvents WHERE $columnEventType = ${EventType.taskCompleted.id} AND $columnEventTs BETWEEN \'${tsFrom.toString()}\' AND \'${tsTo.toString()}\'');
    return maps.isNotEmpty ? maps.first['COUNT(*)'] as int : 0;
  }

  Future<int> breakPeriodAchievement(
      PeriodAchievementInfo periodAchievementInfo) async {
    if (db == null) {
      await open();
    }

    return await db!.update(
        tablePeriodAchievementInfo,
        PeriodAchievementInfo.toMap(PeriodAchievementInfo(
            periodAchievementInfo.id, periodAchievementInfo.achievementId, -1)),
        where: '$columnPeriodAchievementInfoId = ?',
        whereArgs: [periodAchievementInfo.id]);
  }
}
