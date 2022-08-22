import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/service/KaizenState.dart';

class Event {
  final int? id;
  final EventType type;
  final DevelopmentCategory category;
  final DateTime timestamp;

  Event(this.type, this.timestamp, this.category, {this.id});

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      EventType.values
          .firstWhere((element) => element.id == map[columnEventType]),
      DateTime.parse(map[columnEventTs]),
      DevelopmentCategory.values
          .firstWhere((element) => element.id == map[columnEventTaskCategory]),
      id: map[columnEventtId],
    );
  }

  static Map<String, Object?> toMap(Event event) {
    var map = <String, Object?>{
      columnEventType: event.type.id,
      columnEventTaskCategory: event.category.id,
      columnEventTs: event.timestamp.toString()
    };
    return map;
  }
}

enum EventType {
  taskCreated(0),
  taskInProgress(1),
  taskCompleted(2),
  taskDeleted(3);

  const EventType(this.id);
  final int id;
}
