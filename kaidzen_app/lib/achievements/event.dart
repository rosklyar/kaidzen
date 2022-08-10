import 'package:kaidzen_app/service/KaizenState.dart';

class Event {
  int id;
  final EventType type;
  final DateTime timestamp;

  Event(this.type, this.timestamp, {this.id = -1});

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      EventType.values
          .firstWhere((element) => element.id == map[columnEventType]),
      DateTime.parse(map[columnEventTs]),
      id: map[columnEventtId],
    );
  }

  static Map<String, Object?> toMap(Event event) {
    var map = <String, Object?>{
      columnEventType: event.type.id,
      columnEventTs: event.timestamp.toString()
    };
    return map;
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
