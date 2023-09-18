import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:kaidzen_app/features/Feature.dart';

import '../service/AnalyticsService.dart';
import 'FeaturesRepository.dart';

class FeaturesState extends ChangeNotifier {
  FeaturesRepository featuresRepository;
  Map<int, Feature>? features;

  FeaturesState({required this.featuresRepository});

  loadAll() async {
    features = (await featuresRepository.getAll()).asMap().map(
          (index, feature) => MapEntry(feature.id, feature),
        );
    debugPrint(features.toString());
  }

  isFeatureDiscovered(int id) {
    return features![id]!.discovered;
  }

  discoverFeature(int id) async {
    await featuresRepository.featureDiscovered(id);
    await FirebaseAnalytics.instance.logEvent(
        name: AnalyticsEventType.feature_discovered.name,
        parameters: {"featureId": id});
    await loadAll();
    notifyListeners();
  }
}
