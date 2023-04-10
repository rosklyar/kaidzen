import 'package:kaidzen_app/announcements/Announcement.dart';
import 'package:kaidzen_app/service/KaizenState.dart';
import 'package:sqflite/sqflite.dart';

const String tableAnnouncements = 'announcements';
const String columnAnnouncementId = 'announcement_id';
const String columnAnnouncementValidUntil = 'valid_until_ts';
const String columnAnnouncementPriority = 'priority';
const String columnAnnouncementTitle = 'title';
const String columnAnnouncementDetails = 'details';
const String columnAnnouncementClosedTs = 'closed_ts';

class AnnouncementsRepository {
  Database? db;
  AnnouncementsRepository();

  Future open() async {
    db = await KaizenDb.getDb();
  }

  Future close() async => db!.close();

  Future<List<Announcement>> getAll() async {
    if (db == null) {
      await open();
    }
    // read only not closed announcements and that are valid
    List<Map> maps = await db!.query(tableAnnouncements,
        where: '$columnAnnouncementClosedTs IS NULL AND('
            '$columnAnnouncementValidUntil IS NULL OR '
            '$columnAnnouncementValidUntil > ?)',
        whereArgs: [DateTime.now().toString()]);

    List<Announcement> announcements = maps
        .map((element) => Announcement.fromMap(element as Map<String, Object?>))
        .toList();
    return announcements;
  }

  Future<void> closeAnnoucement(int id) async {
    if (db == null) {
      await open();
    }
    await db!.update(
        tableAnnouncements,
        <String, Object?>{
          columnAnnouncementClosedTs: DateTime.now().toString()
        },
        where: '$columnAnnouncementId = ?',
        whereArgs: [id]);
  }
}
