import 'package:kaidzen_app/achievements/EventsRepository.dart';

abstract class Achievement {
  final EventsRepository eventsRepository;

  Achievement({required this.eventsRepository});

  int get id;
  Future<double> get progress;
}
