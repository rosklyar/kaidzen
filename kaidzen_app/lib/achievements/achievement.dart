import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/EventsRepository.dart';

abstract class Achievement {
  final EventsRepository eventsRepository;
  final Widget completedDetails;
  final CompletedDetailsType completedDetailsType;
  Achievement(
      {required this.eventsRepository,
      required this.completedDetails,
      this.completedDetailsType = CompletedDetailsType.COMING_SOON});

  int get id;
  Future<double> get progress;

  Future<Widget> get detailsWidget;

  Widget getCompletedDetails() {
    return completedDetails;
  }

  CompletedDetailsType getCompletedDetailsType() {
    return completedDetailsType;
  }
}

enum CompletedDetailsType { COMING_SOON, ORIGAMI_INSTRUCTION }
