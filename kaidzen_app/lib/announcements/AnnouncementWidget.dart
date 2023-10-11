import 'package:flutter/material.dart';
import 'package:kaidzen_app/announcements/AnnouncementsState.dart';

abstract class AnnouncementWidget {
  final AnnouncementsState announcementsState;

  AnnouncementWidget({required this.announcementsState});

  int get id;

  Widget get widget;

  bool get shouldBeShown;

  Future<void> close() async {
    await announcementsState.announcementClosed(id);
  }
}
