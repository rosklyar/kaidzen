import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/EventsRepository.dart';

abstract class Achievement {
  final EventsRepository eventsRepository;
  final Widget completedDetails;
  Achievement({required this.eventsRepository, required this.completedDetails});

  int get id;
  Future<double> get progress;

  Future<Widget> get detailsWidget;

  Widget getCompletedDetails() {
    return completedDetails;
  }
}
