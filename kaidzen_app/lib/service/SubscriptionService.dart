import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:kaidzen_app/tutorial/TutorialState.dart';

import '../achievements/EventsRepository.dart';
import '../achievements/event.dart';
import '../views/subscribePaintedDoor.dart';
import 'AnalyticsService.dart';
import 'LocalPropertiesService.dart';

class SubscriptionService extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey;
  final LocalPropertiesService localPropertiesService;
  final EventsRepository eventsRepositry;
  final TutorialState tutorialState;
  bool _subscribePageShown = true;

  SubscriptionService(
      {required this.navigatorKey,
      required this.localPropertiesService,
      required this.eventsRepositry,
      required this.tutorialState}) {
  }

  Future<void> load() async {
    _subscribePageShown =
        localPropertiesService.getBool(PropertyKey.SUBSCRIBE_PAGE_SHOWN) ??
            false;
    if (!_subscribePageShown) {
      Event? earliestEvent = await eventsRepositry.getEarliestEvent();

      var comparisonDate = DateTime(2024, 3, 1);
      _subscribePageShown =
          earliestEvent?.timestamp.isBefore(comparisonDate) ?? false;
    }
    notifyListeners();
  }

  bool get canShowSubscribePage =>
      !_subscribePageShown && tutorialState.tutorialCompleted();

  Future<void> markSubscribePageAsShown() async {
    _subscribePageShown = true;
    await localPropertiesService.setBool(
        PropertyKey.SUBSCRIBE_PAGE_SHOWN, true);
    await localPropertiesService.setString(
        PropertyKey.SUBSCRIBE_PAGE_SHOW_DATE, DateTime.now().toIso8601String());
    await FirebaseAnalytics.instance.logEvent(
        name: AnalyticsEventType.subscription_painted_door_page_shown.name);
    notifyListeners();
  }

  void showSubsctiptionPage() async {
    markSubscribePageAsShown();
    navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (context) => SubscriptionPage()));
  }
}
