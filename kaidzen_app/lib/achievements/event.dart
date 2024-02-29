import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/service/KaizenState.dart';

import '../assets/light_dark_theme.dart';

class Event {
  final int? id;
  final EventType type;
  final DevelopmentCategoryDark category;
  final DateTime timestamp;

  Event(this.type, this.timestamp, this.category, {this.id});

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      EventType.values
          .firstWhere((element) => element.id == map[columnEventType]),
      DateTime.parse(map[columnEventTs]),
      DevelopmentCategoryDark.values
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
  taskDeleted(3),
  habitCreated(4),
  habitInProgress(5),
  habitTracked(6),
  habitCompleted(7),
  habitDeleted(8);

  const EventType(this.id);
  final int id;
}
