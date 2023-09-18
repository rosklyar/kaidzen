import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:kaidzen_app/announcements/Announcement.dart';
import 'package:kaidzen_app/announcements/AnnouncementWidget.dart';
import 'package:kaidzen_app/announcements/AnnouncementsRepository.dart';
import 'package:kaidzen_app/announcements/SurveyAnnouncementWidget.dart';
import 'package:kaidzen_app/tutorial/TutorialState.dart';

import '../service/AnalyticsService.dart';
import 'ReorderingAnnouncementWidget.dart';

class AnnouncementsState extends ChangeNotifier {
  TutorialState tutorialState;
  AnnouncementsRepository announcementsRepository;
  List<Announcement>? announcements;
  Announcement? lastClosed;
  Map<int, AnnouncementWidget> announcementsWidgets = {};

  AnnouncementsState(
      {required this.tutorialState, required this.announcementsRepository}) {
    announcementsWidgets.putIfAbsent(
        0, () => SurveyAnnouncementWidget(announcementsState: this));
    announcementsWidgets.putIfAbsent(
        1, () => ReorderingAnnouncementWidget(announcementsState: this));
  }

  loadAll() async {
    announcements = await announcementsRepository.getAll();
    // filter out closed announcements, not valid anymore and sort by priority
    announcements = announcements!..sort((a, b) => a.priority - b.priority);
    lastClosed = await announcementsRepository.getLastClosedAnnouncement();
  }

  announcementClosed(int id) async {
    await announcementsRepository.closeAnnoucement(id);
    await FirebaseAnalytics.instance.logEvent(
        name: AnalyticsEventType.announcement_closed.name,
        parameters: {"announcementId": id});
    await loadAll();
    notifyListeners();
  }

  AnnouncementWidget? getTopAnnouncement() {
    if (!tutorialState.tutorialCompleted() ||
        announcements == null ||
        announcements!.isEmpty) {
      return null;
    }
    if (lastClosed != null) {
      int daysDifference =
          DateTime.now().difference(lastClosed!.closedTs!).inDays;

      return daysDifference >= 1
          ? announcementsWidgets[announcements![0].id]
          : null;
    }
    return announcementsWidgets[announcements![0].id];
  }
}
