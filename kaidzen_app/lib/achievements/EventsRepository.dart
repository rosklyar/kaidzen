import 'package:kaidzen_app/assets/constants.dart';
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
    return await db!.insert(tableEvents, Event.toMap(event));
  }
}
