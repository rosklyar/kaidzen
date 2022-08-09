import 'package:kaidzen_app/service/KaizenState.dart';

class Event {
  final int id;
  final int type;
  final DateTime timestamp;

  Event(this.id, this.type, this.timestamp);

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(map[columnEventtId], map[columnEventType],
        DateTime.parse(map[columnEventTs]));
  }
}

enum EventType {
  created(0),
  inProgress(1),
  completed(2),
  deleted(3);

  const EventType(this.id);
  final int id;
}
