import 'AnnouncementsRepository.dart';

class Announcement {
  final int id;
  final DateTime? validUntil;
  final int priority;
  final String title;
  final String details;
  final DateTime? closedTs;

  Announcement(
      {required this.id,
      required this.validUntil,
      required this.priority,
      required this.title,
      required this.details,
      this.closedTs});

  static Map<String, Object?> toMap(Announcement announcement) {
    return {
      columnAnnouncementId: announcement.id,
      columnAnnouncementValidUntil: announcement.validUntil?.toString(),
      columnAnnouncementPriority: announcement.priority,
      columnAnnouncementTitle: announcement.title,
      columnAnnouncementDetails: announcement.details,
      columnAnnouncementClosedTs: announcement.closedTs?.toString(),
    };
  }

  static Announcement fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map[columnAnnouncementId] as int,
      validUntil: map[columnAnnouncementValidUntil] != null
          ? DateTime.parse(map[columnAnnouncementValidUntil] as String)
          : null,
      priority: map[columnAnnouncementPriority] as int,
      title: map[columnAnnouncementTitle] as String,
      details: map[columnAnnouncementDetails] as String,
      closedTs: map[columnAnnouncementClosedTs] != null
          ? DateTime.parse(map[columnAnnouncementClosedTs] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'Announcement{id: $id, validUntil: $validUntil, priority: $priority, title: $title, details: $details, closedTs: $closedTs}';
  }

  @override
  List<Object?> get props =>
      [id, validUntil, priority, title, details, closedTs];
}
